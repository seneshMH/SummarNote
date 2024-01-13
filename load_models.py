import logging
import os
import torch

import google.generativeai as genai

from transformers import T5Tokenizer, T5ForConditionalGeneration
from dotenv import load_dotenv
from constants import CHECKPOINT

load_dotenv()

def load_local_llm(device):
    logging.info(f"Loading Model: {CHECKPOINT}, on: {device}")
    tokenizer = T5Tokenizer.from_pretrained(CHECKPOINT,return_tensors='pt',truncation=True,legacy=False)
    base_model = T5ForConditionalGeneration.from_pretrained(CHECKPOINT,device_map=device,offload_folder='offload',torch_dtype=torch.float32)

    return (base_model,tokenizer)
  
def load_gemini_llm():
    GOOGLE_API_KEY= os.environ["GOOGLE_API_KEY"]
    genai.configure(api_key=GOOGLE_API_KEY)