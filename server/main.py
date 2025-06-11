from dotenv import load_dotenv
import os

# Load environment variables from .env file if it exists
load_dotenv()

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from router.search_router import search_router

app = FastAPI(
    title="SNRT Semantic Search API",
    description="A semantic search API powered by Milvus and Groq",
    version="1.0.0"
)

# Configure CORS
origins = ["*"]  # Allow all origins for now, can be restricted later

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Include the search router without prefix
app.include_router(search_router)

@app.get("/health")
async def health():
    """
    Health check endpoint for Fly.io monitoring.
    Returns a simple OK status to indicate the service is running.
    """
    return {"status": "ok"}

@app.get("/")
async def root():
    """
    Root endpoint for API information and debugging.
    """
    return {"message": "SNRT Semantic Search API"} 