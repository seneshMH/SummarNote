import google.generativeai as genai

from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain.vectorstores import Chroma
from langchain.document_loaders import PyPDFDirectoryLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain.chains.question_answering import load_qa_chain
from langchain.prompts import PromptTemplate


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