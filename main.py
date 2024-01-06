import os
import logging
from constants import  USE_PIPELINE, CHECKPOINT,USE_GEMINI

from fastapi import FastAPI, UploadFile, File,Request
from fastapi.exceptions import HTTPException

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders import PyPDFLoader, DirectoryLoader,PDFMinerLoader 
from langchain.chains.summarize import load_summarize_chain
from langchain.chains import RetrievalQA 
from langchain.embeddings import SentenceTransformerEmbeddings 
from langchain.vectorstores import Chroma
from langchain.llms import HuggingFacePipeline
from transformers import T5Tokenizer, T5ForConditionalGeneration
from transformers import AutoTokenizer, AutoModelForCausalLM
from transformers import pipeline

import torch
import base64
from goose3 import Goose

###################################################################################
#GEMINI

import os
from dotenv import load_dotenv
import google.generativeai as genai

from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_google_genai import ChatGoogleGenerativeAI

from langchain.prompts import PromptTemplate
from langchain.chains.question_answering import load_qa_chain
from langchain.document_loaders import PyPDFDirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.vectorstores import Chroma

load_dotenv()
GOOGLE_API_KEY= os.environ["GOOGLE_API_KEY"]
genai.configure(api_key=GOOGLE_API_KEY)
     

device = "cuda" if torch.cuda.is_available() else "cpu"

logger = logging.getLogger(__name__)
g = Goose()

LOG_FORMAT2 = (
    "[%(asctime)s %(process)d:%(threadName)s] %(name)s - %(levelname)s - %(message)s | %(filename)s:%(lineno)d"
)
logging.basicConfig(level=logging.INFO, format=LOG_FORMAT2)

logging.info(f"Loading Model: {CHECKPOINT}, on: {device}")

tokenizer = T5Tokenizer.from_pretrained(CHECKPOINT,return_tensors='pt',truncation=True,legacy=False)
base_model = T5ForConditionalGeneration.from_pretrained(CHECKPOINT,device_map=device,offload_folder='offload',torch_dtype=torch.float32)
  
# tokenizer = AutoTokenizer.from_pretrained(CHECKPOINT,return_tensors='pt',truncation=True,legacy=False)
# base_model = AutoModelForCausalLM.from_pretrained(CHECKPOINT,device_map=device,offload_folder='offload',torch_dtype=torch.float32)

app = FastAPI()

# ###############################################################################
#setup pipelines
#summarization
def llm_pipeline_summary():
    pipe = pipeline(
        'summarization',
        model = base_model,
        tokenizer = tokenizer,
        max_length = 512, 
        min_length = 50)
    
    return pipe

# text genartion
def llm_pipeline_textgen():
    pipe = pipeline(
        USE_PIPELINE,
        model = base_model,
        tokenizer = tokenizer,
        max_length = 512,
        do_sample = True,
        temperature = 0.3,
        top_p= 0.95,
    )
    
    return pipe

###########################################################################

def summary_file(filepath):

    pipe_sum = llm_pipeline_summary()

    loader =  PyPDFLoader(filepath)
    pages = loader.load_and_split()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=50)
    texts = text_splitter.split_documents(pages)
    result = ""
    for text in texts:
        print(text)
        summary = pipe_sum( text.page_content)
        result += summary[0]['summary_text']
   
    return result

def summary_url(url):
    pipe_sum = llm_pipeline_summary()

    article = g.extract(url)
    input_text = article.cleaned_text
    summary = pipe_sum(input_text)
    result = summary[0]['summary_text']

    return result
######################################################################################
#LOCAL LLM 

persist_directory = "db"
def data_ingestion_local():
    for root, dirs, files in os.walk("docs"):
        for file in files:
            if file.endswith(".pdf"):
                print(file)
                loader = PDFMinerLoader(os.path.join(root, file))
    documents = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=20)
    texts = text_splitter.split_documents(documents)
    #create embeddings here
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    #create vector store here
    db = Chroma.from_documents(texts, embeddings)
    # db = Chroma.from_documents(texts, embeddings)
    db.persist()
    db=None 

def process_answer_local(instruction):
    response = ''
    instruction = instruction
    qa = qa_llm()
    generated_text = qa(instruction)
    answer = generated_text['result']
    return answer

def qa_llm():
    pipe = llm_pipeline_textgen()
    llm = HuggingFacePipeline(pipeline=pipe)
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    db = Chroma(embedding_function = embeddings)
    # db = Chroma(persist_directory="db", embedding_function = embeddings)
    retriever = db.as_retriever()
    qa = RetrievalQA.from_chain_type(
        llm = llm,
        chain_type = "stuff",
        retriever = retriever,
        return_source_documents=True
    )
    return qa

########################################################################################
#GEMINI

def data_ingestion_gemini():

    for m in genai.list_models():
        if 'generateContent' in m.supported_generation_methods:
            print(m.name)

    loader = PyPDFDirectoryLoader("docs")
    data = loader.load_and_split()


    context = "\n".join(str(p.page_content) for p in data)
    print("The total number of words in the context:", len(context))

    # Split the Extracted Data into Text Chunks

    text_splitter = RecursiveCharacterTextSplitter(chunk_size=10000, chunk_overlap=200)
    context = "\n\n".join(str(p.page_content) for p in data)

    texts = text_splitter.split_text(context)
    print(len(texts))


    embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
    vector_index = Chroma.from_texts(texts, embeddings)
    vector_index.persist()
    vector_index = None

def process_answer_gemini(chat):
    prompt_template = """
        Answer the question as detailed as possible from the provided context, make sure to provide all the details, if the answer is not in
        provided context just say, "answer is not available in the context", don't provide the wrong answer\n\n
        Context:\n {context}?\n
        Question: \n{question}\n

        Answer:
    """

    embeddings = GoogleGenerativeAIEmbeddings(model = "models/embedding-001")
    vector_index = Chroma(embedding_function = embeddings).as_retriever()
    question = chat
    docs = vector_index.get_relevant_documents(question)
    prompt = PromptTemplate(template = prompt_template, input_variables = ["context", "question"])   
    model = ChatGoogleGenerativeAI(model="gemini-pro",temperature=0.3)
    chain = load_qa_chain(model, chain_type="stuff", prompt=prompt)
    response = chain({"input_documents":docs, "question": question}, return_only_outputs=True)
    return response

########################################################################################

@app.post("/chat")
async def chat(chat: str):
    #ingested_data =  data_ingestion()

    answer = ''
    if chat:
        if USE_GEMINI:
            answer = process_answer_gemini(chat)
        else:
            answer = process_answer_local({'query': chat})

    return answer


@app.post("/summary-from-url")
async def upload_url(url: str):
    if url is None:
        raise HTTPException(400, detail="Invalid URL")
    else:
        summary = summary_url(url)

    return {"summary": summary}


@app.post("/summary-from-file")
async def upload_file_summary(request: Request,file: UploadFile = File(...)):
    try:
        # Accessing information from the Request object
        headers = request.headers
        method = request.method
        path = request.url.path
        query_params = request.query_params

        logging.info(file.filename)
        logging.info(file.content_type)

        if file.content_type != "application/pdf":
            raise HTTPException(400, detail="Invalid document type")
        else:
            filepath = "docs/" + file.filename
            content = await file.read()
            with open(filepath, "wb") as temp_file:
                temp_file.write(content)

            summary = summary_file(filepath)

            return {"summary": summary}
    except Exception as e:
        return {"error": str(e)}



@app.post("/data-ingestion")
async def upload_file_chat(file: UploadFile = File(...)):
    if file.content_type != "application/pdf":
        raise HTTPException(400, detail="Invalid document type")
    else:
        filepath = "docs/" + file.filename
        content = await file.read()
        with open(filepath, "wb") as temp_file:
            temp_file.write(content)
        if USE_GEMINI:
            data_ingestion_gemini()
        else:
            data_ingestion_local()

    return {"File analysis done"}


# if __name__=="__main__":
#     uvicorn.run(app, host="0.0.0.0", port=8080)