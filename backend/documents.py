import os
import logging
from concurrent.futures import ProcessPoolExecutor, ThreadPoolExecutor, as_completed
from constants import DOCUMENT_MAP,INGEST_THREADS
from langchain.docstore.document import Document
from langchain.text_splitter import RecursiveCharacterTextSplitter
from goose3 import Goose

# from langchain_community.document_loaders import DirectoryLoader

g = Goose()

def load_single_document(file_path: str) -> Document:
    # Loads a single document from a file path
    try:
       file_extension = os.path.splitext(file_path)[1]
       logging.info("FILE EXTENSION : " + file_extension)
       loader_class = DOCUMENT_MAP.get(file_extension)
       if loader_class:
           logging.info(file_path + ' loaded.')
           loader = loader_class(file_path)
       else:
           logging.error(file_path + ' document type is undefined.')
           raise ValueError("Document type is undefined")
       return loader.load()[0]
    except Exception as ex:
       logging.error('%s loading error: \n%s' % (file_path, ex))
       return None 
    

def load_document_batch(filepaths):
    logging.info("Loading document batch")
    # create a thread pool
    with ThreadPoolExecutor(len(filepaths)) as exe:
        # load files
        futures = [exe.submit(load_single_document, name) for name in filepaths]
        # collect data
        if futures is None:
            logging.error(' failed to submit')
            return None
        else:
           data_list = [future.result() for future in futures]
           # return data and file paths
           return (data_list, filepaths)

def load_documents(source_dir: str) -> list[Document]:
    # Loads all documents from the source documents directory, including nested folders
    paths = []
    for root, _, files in os.walk(source_dir):
        for file_name in files:
            logging.info('Importing: ' + file_name)
            file_extension = os.path.splitext(file_name)[1]
            source_file_path = os.path.join(root, file_name)
            if file_extension in DOCUMENT_MAP.keys():
                paths.append(source_file_path)

    # Have at least one worker and at most INGEST_THREADS workers
    n_workers = min(INGEST_THREADS, max(len(paths), 1))
    chunksize = round(len(paths) / n_workers)
    docs = []
    with ProcessPoolExecutor(n_workers) as executor:
        futures = []
        # split the load operations into chunks
        for i in range(0, len(paths), chunksize):
            # select a chunk of filenames
            filepaths = paths[i : (i + chunksize)]
            # submit the task
            try:
               future = executor.submit(load_document_batch, filepaths)
            except Exception as ex:
               logging.error('executor task failed: %s' % (ex))
               future = None
            if future is not None:
               futures.append(future)
        # process all results
        for future in as_completed(futures):
            # open the file and load the data
            try:
                contents, _ = future.result()
                docs.extend(contents)
            except Exception as ex:
                logging.error('Exception: %s' % (ex))
                
    return docs

def load_url(url : str):
    try:
        logging.info("Loading url")
        article = g.extract(url)
        input_text = article.cleaned_text
        
        return input_text
    except Exception as ex:
       logging.error('%s loading error: \n%s' % (url, ex))
       return None 

# def load_docs(path: str):  
#     loader = DirectoryLoader(path,show_progress=True, use_multithreading=True)
#     docs = loader.load()[0]

#     return docs

def create_documents(path: str,type):
    text = ""
    
    if type == "file":
        pages = load_documents(path)
        # pages = load_docs(path)
        for page in pages:
            text += page.page_content
    elif type == "url":
        pages = load_url(path)
        for page in pages:
            text += page

    text = text.replace('\t', ' ')
    text_splitter = RecursiveCharacterTextSplitter(separators=["\n\n", "\n", "\t"], chunk_size=8000, chunk_overlap=3000)
    docs = text_splitter.create_documents([text])
    num_documents = len(docs)
    logging.info(f"Now our book is split up into {num_documents} documents")
    return (docs , num_documents)