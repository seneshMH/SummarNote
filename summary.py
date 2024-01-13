from documents import create_documents
from langchain.embeddings import SentenceTransformerEmbeddings
from langchain.docstore.document import Document
from transformers import pipeline
import numpy as np
from sklearn.cluster import KMeans 
import json
import logging

def create_embeddings(num_documents,docs):
    
    embeddings = SentenceTransformerEmbeddings(model_name="all-MiniLM-L6-v2")
    vectors = embeddings.embed_documents([x.page_content for x in docs])

    return vectors

def K_means_clustering(docs,num_documents,vectors):
    
    num_clusters = 11
    if num_documents < num_clusters:
        num_clusters = num_documents
    # Perform K-means clustering
    kmeans = KMeans(n_clusters=num_clusters, random_state=42).fit(vectors)
    # Find the closest embeddings to the centroids
    # Create an empty list that will hold your closest points
    closest_indices = []
    # Loop through the number of clusters you have
    for i in range(num_clusters):
        # Get the list of distances from that particular cluster center
        distances = np.linalg.norm(vectors - kmeans.cluster_centers_[i], axis=1)
        # Find the list position of the closest one (using argmin to find the smallest distance)
        closest_index = np.argmin(distances)
        # Append that position to your closest indices list
        closest_indices.append(closest_index)
    
    selected_indices = sorted(closest_indices)
    selected_docs = [docs[doc] for doc in selected_indices]

    return selected_docs , selected_indices

def create_summary(path,llm,tokenizer,type):

    docs , num_documents = create_documents(path,type)
    vectors  = create_embeddings(num_documents,docs)
    selected_docs ,selected_indices = K_means_clustering(docs,num_documents,vectors)

    # Make an empty list to hold your summaries
    summary_list = []

    pipe = pipeline(
        'summarization',
        model = llm,
        tokenizer = tokenizer,
        max_length = 512,
        min_length = 50)

    # Loop through a range of the lenght of your selected docs
    for i, doc in enumerate(selected_docs):
        # Go get a summary of the chunk
        chunk_summary = pipe([doc.page_content])
        # Append that summary to your list
        summary_list.append(chunk_summary)
        logging.info(f"Summary #{i} (chunk #{selected_indices[i]}) - Preview: {chunk_summary[:250]} \n")
    
    summaries = "\n".join(json.dumps(summary) for summary in summary_list)

    # Convert it back to a document
    summaries = Document(page_content=summaries)
    summaries = summaries.page_content.split('\n')

    output = pipe([summaries][0])

    final = ""
    for i, output_dict in enumerate(output):
        final += output_dict["summary_text"]

    logging.info(f"Final summary: {final}")

    return final