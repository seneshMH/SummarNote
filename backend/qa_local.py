from transformers import pipeline

from constants import USE_PIPELINE
from documents import load_documents
from langchain.chains import RetrievalQA 
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.llms import HuggingFacePipeline
from langchain.embeddings import SentenceTransformerEmbeddings 
from langchain.vectorstores import Chroma

def llm_pipeline_textgen(llm,tokenizer):
    pipe = pipeline(
        USE_PIPELINE,
        model = llm,
        tokenizer = tokenizer,
        max_length = 512,
        do_sample = True,
        temperature = 0.3,
        top_p= 0.95,
    )

    return pipe

def data_ingestion_local():
    documents = load_documents("docs")
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=20)
    texts = text_splitter.split_documents(documents)
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    db = Chroma.from_documents(texts, embeddings, persist_directory="./chroma_db")
    db.persist()
    db=None 

def process_answer_local(instruction,local_llm,tokenizer):
    response = ''
    instruction = instruction
    qa = qa_llm(local_llm,tokenizer)
    generated_text = qa(instruction)
    answer = generated_text['result']
    return answer

def qa_llm(local_llm,tokenizer):
    pipe = llm_pipeline_textgen(local_llm,tokenizer)
    llm = HuggingFacePipeline(pipeline=pipe)
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    db = Chroma(persist_directory="./chroma_db",embedding_function = embeddings)
    retriever = db.as_retriever()
    qa = RetrievalQA.from_chain_type(
        llm = llm,
        chain_type = "stuff",
        retriever = retriever,
        return_source_documents=True
    )
    return qa