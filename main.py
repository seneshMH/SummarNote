import os
from constants import CHROMA_SETTINGS

from fastapi import FastAPI, UploadFile, File
from fastapi.exceptions import HTTPException

from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.document_loaders import PyPDFLoader, DirectoryLoader,PDFMinerLoader 
from langchain.chains.summarize import load_summarize_chain
from langchain.chains import RetrievalQA 
from langchain.embeddings import SentenceTransformerEmbeddings 
from langchain.vectorstores import Chroma
from langchain.llms import HuggingFacePipeline
from transformers import T5Tokenizer, T5ForConditionalGeneration
from transformers import pipeline
import torch
import base64
from goose3 import Goose


g = Goose()

app = FastAPI()

checkpoint = "LaMini-Flan-T5-248M"
tokenizer = T5Tokenizer.from_pretrained(checkpoint)
base_model = T5ForConditionalGeneration.from_pretrained(checkpoint,device_map='cuda:0',offload_folder='offload',torch_dtype=torch.float32)

def file_preprocessing(file):
    loader =  PyPDFLoader(file)
    pages = loader.load_and_split()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=200, chunk_overlap=50)
    texts = text_splitter.split_documents(pages)
    final_texts = ""
    for text in texts:
        print(text)
        final_texts = final_texts + text.page_content
    return final_texts

#LLM pipeline
# def llm_pipeline(filepath):
#     pipe_sum = pipeline(
#         'summarization',
#         model = base_model,
#         tokenizer = tokenizer,
#         max_length = 512, 
#         min_length = 50)
#     input_text = file_preprocessing(filepath)
#     result = pipe_sum(input_text)
#     result = result[0]['summary_text']
#     return result

device = torch.device('cpu')

def llm_pipeline():
    pipe = pipeline(
        'text2text-generation',
        model = base_model,
        tokenizer = tokenizer,
        max_length = 256,
        do_sample = True,
        temperature = 0.3,
        top_p= 0.95,
    )
    local_llm = HuggingFacePipeline(pipeline=pipe)
    return local_llm

def llm_pipeline_url(url):
    pipe_sum = pipeline(
        'summarization',
        model = base_model,
        tokenizer = tokenizer,
        max_length = 512, 
        min_length = 50)
    article = g.extract(url)
    input_text = article.cleaned_text
    result = pipe_sum(input_text)
    result = result[0]['summary_text']
    return result

def llm_summarization_pipeline(text):
    pipe_sum = pipeline(
        'summarization',
        model = base_model,
        tokenizer = tokenizer,
        max_length = 512, 
        min_length = 50)
    result = pipe_sum(text)
    result = result[0]['summary_text']
    return result
    

@app.post("/file")
async def upload_file(file: UploadFile = File(...)):
    if file.content_type != "application/pdf":
        raise HTTPException(400, detail="Invalid document type")
    else:
        filepath = "docs/" + file.filename
        content = await file.read()
        with open(filepath, "wb") as temp_file:
            temp_file.write(content)

        # summary = llm_pipeline(filepath)

    return {"summary": "summary"}

persist_directory = "db"
def data_ingestion():
    for root, dirs, files in os.walk("docs"):
        for file in files:
            if file.endswith(".pdf"):
                print(file)
                loader = PDFMinerLoader(os.path.join(root, file))
    documents = loader.load()
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=500, chunk_overlap=500)
    texts = text_splitter.split_documents(documents)
    #create embeddings here
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    #create vector store here
    db = Chroma.from_documents(texts, embeddings, persist_directory=persist_directory, client_settings=CHROMA_SETTINGS)
    # db = Chroma.from_documents(texts, embeddings)
    db.persist()
    db=None 

def process_answer(instruction):
    response = ''
    instruction = instruction
    qa = qa_llm()
    generated_text = qa(instruction)
    answer = generated_text['result']
    return answer

def qa_llm():
    llm = llm_pipeline()
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    db = Chroma(persist_directory="db", embedding_function = embeddings, client_settings=CHROMA_SETTINGS)
    # db = Chroma(persist_directory="db", embedding_function = embeddings)
    retriever = db.as_retriever()
    qa = RetrievalQA.from_chain_type(
        llm = llm,
        chain_type = "stuff",
        retriever = retriever,
        return_source_documents=True
    )
    return qa

@app.post("/chat")
async def chat(chat: str):
    ingested_data =  data_ingestion()

    answer = ''
    if chat:
        answer = process_answer({'query': chat})

    return answer


@app.post("/url")
async def upload_url(url: str):
    if url is None:
        raise HTTPException(400, detail="Invalid URL")
    else:
        summary = await llm_pipeline_url(url)

    return {"summary": summary}