import os 
import chromadb
# from chromadb.config import Settings 

# CHROMA_SETTINGS = Settings(
#         chroma_db_impl='duckdb+parquet',
#         persist_directory='db',
#         anonymized_telemetry=False
# )

USE_PIPELINE = "text2text-generation"
CHECKPOINT = "models/LaMini-Flan-T5-248M"

USE_GEMINI = True

# from transformers import AutoTokenizer, AutoModelForCausalLM

# checkpoint = "models/TinyMistral-248M-Instruct"
# tokenizer = AutoTokenizer.from_pretrained(checkpoint)
# base_model = AutoModelForCausalLM.from_pretrained(checkpoint,device_map='cuda:0',offload_folder='offload',torch_dtype=torch.float32)

# 'text2text-generation'
# "text-generation"