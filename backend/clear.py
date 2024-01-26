from langchain.vectorstores import Chroma
from chromadb.config import Settings 

import os
import logging

CHROMA_SETTINGS = Settings(
    persist_directory = "./chroma_db",
    anonymized_telemetry = False,
    allow_reset = True
)

def clear_db():
    try:
        db = Chroma(client_settings=CHROMA_SETTINGS)
        db._client.reset()
        # for collection in db._client.list_collections():
        #     ids = collection.get()['ids']
        #     print('REMOVE %s document(s) from %s collection' % (str(len(ids)), collection.name))
        #     if len(ids): collection.delete(ids)
        db=None
        logging.info("Chroma DB cleared successfully.")
    except Exception as e:
        logging.error(f"Error clearing DB: {e}")

def clear_docs():
    try:
        folder_path = "docs"
        # Get the list of files in the folder
        files = os.listdir(folder_path)

        # Iterate over each file and delete it
        for file_name in files:
            file_path = os.path.join(folder_path, file_name)
            if os.path.isfile(file_path):
                os.remove(file_path)

        logging.info(f"All files in {folder_path} deleted successfully.")

    except Exception as e:
        logging.error(f"Error deleting files: {e}")