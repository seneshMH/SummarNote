import re
import nltk
import string
import heapq

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


def calculate_sentences_score(sentences, important_words, distance):
  scores = []
  sentence_index = 0

  for sentence in [nltk.word_tokenize(sentence) for sentence in sentences]:
    word_index = []
    for word in important_words:
      try:
        word_index.append(sentence.index(word))
      except ValueError:
        pass

    word_index.sort()

    if len(word_index) == 0:
      continue

    groups_list = []
    group = [word_index[0]]
    i = 1 # 3
    while i < len(word_index): # 3
      # first execution: 1 - 0 = 1
      # second execution: 2 - 1 = 1
      if word_index[i] - word_index[i - 1] < distance:
        group.append(word_index[i])
      else:
        groups_list.append(group[:])
        group = [word_index[i]]
      i += 1
    groups_list.append(group)

    max_group_score = 0
    for g in groups_list:
      #print(g)
      important_words_in_group = len(g)
      total_words_in_group = g[-1] - g[0] + 1
      score = 1.0 * important_words_in_group**2 / total_words_in_group

      if score > max_group_score:
        max_group_score = score

    scores.append((max_group_score, sentence_index))
    sentence_index += 1
  return scores


def summarize(text, top_n_words, distance, number_of_sentences, percentage = 0):
  original_sentences = [sentence for sentence in nltk.sent_tokenize(text)]
  formatted_sentences = [preprocess(original_sentence) for original_sentence in original_sentences]
  words = [word for sentence in formatted_sentences for word in nltk.word_tokenize(sentence)]
  frequency = nltk.FreqDist(words)
  top_n_words = [word[0] for word in frequency.most_common(top_n_words)]
  sentences_score = calculate_sentences_score(formatted_sentences, top_n_words, distance)
  if percentage > 0:
    best_sentences = heapq.nlargest(int(len(formatted_sentences) * percentage), sentences_score)
  else:  
    best_sentences = heapq.nlargest(number_of_sentences, sentences_score)
  best_sentences = [original_sentences[i] for (score, i) in best_sentences]

  return  best_sentences

def extract(original_text):
  best_sentences = summarize(original_text, 5, 2, 3)
  return  best_sentences



