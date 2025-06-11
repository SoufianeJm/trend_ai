# SNRT Semantic Search API

A semantic search API powered by Milvus and Groq.

## Setup

1. Create a virtual environment:
```bash
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
```

2. Install dependencies:
```bash
pip install -r requirements.txt
```

3. Set up environment variables:
Create a `.env` file with:
```
GROQ_API_KEY=your_groq_api_key_here
```

## Running the API

Start the server with:
```bash
uvicorn main:app --reload
```

The API will be available at `http://localhost:8000`

## API Documentation

Once the server is running, you can access:
- Interactive API docs: `http://localhost:8000/docs`
- Alternative API docs: `http://localhost:8000/redoc`

## Endpoints

- `GET /`: Root endpoint
- `POST /api/v1/search`: Semantic search endpoint 