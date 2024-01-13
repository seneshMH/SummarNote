import logging

from constants import USE_GEMINI

import uvicorn
from fastapi import FastAPI, UploadFile, File,Request
from fastapi.exceptions import HTTPException
import torch

from summary import create_summary
from load_models import load_local_llm,load_gemini_llm
from logger import setup_logger

from qa_local import data_ingestion_local,process_answer_local
from qa_gemini import data_ingestion_gemini,process_answer_gemini

app = FastAPI()
setup_logger()

device = "cuda" if torch.cuda.is_available() else "cpu"


if USE_GEMINI:
    load_gemini_llm()
else:
    base_model,tokenizer =  load_local_llm(device)


@app.post("/chat")
async def chat(chat: str):
    answer = ''
    if chat:
        if USE_GEMINI:
            answer = process_answer_gemini(chat)
        else:
            answer = process_answer_local({'query': chat},base_model,tokenizer)

    return answer


@app.post("/summary-from-url")
async def upload_url(request: Request,data: dict):
   
    url = data.get('url')

    logging.info(f"URL: {url}")
    if url is None:
        raise HTTPException(400, detail="Invalid URL")
    else:
        summary = create_summary(url,base_model,tokenizer,type="url")

    return {"summary": summary}


@app.post("/summary-from-file")
async def upload_file_summary(request: Request,file: UploadFile = File(...)):
    try:
        if file.content_type != "application/pdf":
            raise HTTPException(400, detail="Invalid document type")
        else:
            filepath = "docs/" + file.filename
            content = await file.read()
            with open(filepath, "wb") as temp_file:
                temp_file.write(content)

            summary = create_summary("docs",base_model,tokenizer,type="file")

            return {"summary": summary}
    except Exception as e:
        return {"error": str(e)}



@app.post("/data-ingestion")
async def upload_file_chat(file: UploadFile = File(...)):
    if file.content_type != "application/pdf":
        raise HTTPException(400, detail="Invalid document type")
    else:
        filepath = "docs/" + file.filename
        content = await file.read()
        with open(filepath, "wb") as temp_file:
            temp_file.write(content)
        if USE_GEMINI:
            data_ingestion_gemini()
        else:
            data_ingestion_local()

    return {"File analysis done"}


if __name__=="__main__":
    uvicorn.run(app, host="127.0.0.1", port=8080)