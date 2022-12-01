from fastapi import FastAPI, HTTPException
from psycopg2.extras import LoggingConnection

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
def get_listings(mun_code: int, property_type: str, bathroom: float, bedrooms: int):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.get_listings(
            conn,
            mun_code=mun_code,
            property_type=f"%{property_type}%",
            bathroom=bathroom,
            bedrooms=bedrooms,
        )
        return data

@app.delete("/listings/{id}")
def delete_listings(id: int):
    with psycopg2.connect(DB_URI, connection_factory=LoggingConnection) as conn:
        conn.initialize(logger)
        data = queries.delete_listing(
            conn,
            id=id
        )
        return data

