from fastapi import FastAPI, HTTPException
from psycopg2.extras import LoggingConnection
from pydantic import BaseModel
from typing import List

import json
import logging
import aiosql
import os
import psycopg2


logging.basicConfig(level=logging.DEBUG)
logger = logging.getLogger("LoggerQueries")


DB_URI = os.getenv("DB_URI")

app = FastAPI()

logging.getLogger().setLevel(logging.DEBUG)

queries = aiosql.from_path("./sql/queries.sql", "psycopg2")


@app.get("/listings")
def get_listings():
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        results = queries.get_all_listings(
            conn,
        )
        data_response = []
        for val in results:
            data_response.append(
                        {
                    "amount": val[1],
                    "id": val[0],
                    "colonia": val[2],
                    "bedroooms": val[3],
                    "bathroom": val[4],
                }
            )
        return json.dumps(data_response)

class Listing(BaseModel):
    amount: float
    colonia: str 
    bedrooms: int
    bathroom: int

@app.post("/listings")
def post_listings(listing: List[Listing]):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.insert_listing(
            conn,
            amount = listing[0].amount,
            colonia = listing[0].colonia,
            bedrooms = listing[0].bedrooms, 
            bathroom = listing[0].bathroom
        )
        return "OK"

@app.put("/listings/{id}")
def post_listings(id: int, listing: List[Listing]):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.update_listing(
            conn,
            id = id,
            amount = listing[0].amount,
            colonia = listing[0].colonia,
            bedrooms = listing[0].bedrooms, 
            bathroom = listing[0].bathroom
        )
        return "OK"

@app.get("/colonias")
def get_colonias(delegacion: str):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.get_colonias_by_alcadia(
            conn,
            delegacion=f"%{delegacion.upper()}%",
        )
        colonias = []
        for val in data:
            colonias.append(val[0])
        return {"colonias": colonias}

@app.delete("/listings/{id}")
def delete_listings(id: int):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.delete_listing(
            conn,
            id=id
        )
        return json.dumps({"message": "ok"})

