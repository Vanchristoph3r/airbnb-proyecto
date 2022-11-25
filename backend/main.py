from fastapi import FastAPI, HTTPException
import logging

app = FastAPI()

logging.getLogger().setLevel(logging.DEBUG)

@app.get("/listings")
def read_root():
    return {"Hello": "World"}
