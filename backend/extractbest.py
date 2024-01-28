import re
import nltk
import string
import numpy as np
import networkx as nx
from nltk.cluster.util import cosine_distance

nltk.download('punkt')
nltk.download('stopwords')

def preprocess(text):
  stopwords = nltk.corpus.stopwords.words('english')
  formatted_text = text.lower()
  tokens = []
  for token in nltk.word_tokenize(formatted_text):
    tokens.append(token)
  tokens = [word for word in tokens if word not in stopwords and word not in string.punctuation]
  formatted_text = ' '.join(element for element in tokens)

  return formatted_text

def calculate_sentence_similarity(sentence1, sentence2):
  words1 = [word for word in nltk.word_tokenize(sentence1)]
  words2 = [word for word in nltk.word_tokenize(sentence2)]
  all_words = list(set(words1 + words2))
  vector1 = [0] * len(all_words)
  vector2 = [0] * len(all_words)
  
  for word in words1: # Bag of words
    #print(word)
    vector1[all_words.index(word)] += 1
  for word in words2:
    vector2[all_words.index(word)] += 1

  return 1 - cosine_distance(vector1, vector2)

def calculate_similarity_matrix(sentences):
  similarity_matrix = np.zeros((len(sentences), len(sentences)))
  #print(similarity_matrix)
  for i in range(len(sentences)):
    for j in range(len(sentences)):
      if i == j:
        continue
      similarity_matrix[i][j] = calculate_sentence_similarity(sentences[i], sentences[j])
  return similarity_matrix

def summarize(text, number_of_sentences, percentage = 0):
  original_sentences = [sentence for sentence in nltk.sent_tokenize(text)]
  formatted_sentences = [preprocess(original_sentence) for original_sentence in original_sentences]
  similarity_matrix = calculate_similarity_matrix(formatted_sentences)
  #print(similarity_matrix)

  similarity_graph = nx.from_numpy_array(similarity_matrix)
  #print(similarity_graph.nodes)
  #print(similarity_graph.edges)

  scores = nx.pagerank(similarity_graph)
  #print(scores)
  ordered_scores = sorted(((scores[i], score) for i, score in enumerate(original_sentences)), reverse=True)
  #print(ordered_scores)

  if percentage > 0:
    number_of_sentences = int(len(formatted_sentences) * percentage)

  best_sentences = []
  for sentence in range(number_of_sentences):
    best_sentences.append(ordered_scores[sentence][1])
  
  return best_sentences

def extract(original_text,percentage):
  best_sentences = summarize(original_text,5, percentage=percentage)
  return  best_sentences



