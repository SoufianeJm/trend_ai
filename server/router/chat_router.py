import logging
from typing import List, Dict
from fastapi import APIRouter
from pydantic import BaseModel, Field
import requests
from services.embedder import embed_query
from services.milvus_query import search_content

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

chat_router = APIRouter(tags=["chat"])

class ChatTurn(BaseModel):
    user: str
    bot: str

class ChatRequest(BaseModel):
    message: str = Field(..., description="User's current message")
    history: List[ChatTurn] = Field(default_factory=list, description="List of previous chat turns")

@chat_router.post("/chat")
async def chat(request: ChatRequest):
    """
    Chatbot endpoint: embeds the user message, retrieves context from Milvus, builds a French prompt,
    sends it to a local LLM server, and returns the generated reply with sources.
    """
    logger.info(f"Received chat message: '{request.message}'")

    # 1. Embed and retrieve context
    query_embedding = embed_query(request.message)
    top_k = 5
    search_results = search_content(query_embedding=query_embedding, top_k=top_k)

    # 2. Build context snippet
    context_snippets = []
    for item in search_results:
        title = item.get('title', '').strip()
        description = item.get('description', '').strip()
        if title or description:
            context_snippets.append(f"[{title}] : {description}")
    context_str = "\n".join(context_snippets)

    # 3. Build chat history in French format
    history_snippets = []
    for turn in request.history[-4:]:  # Limit to last 4 turns for brevity
        history_snippets.append(f"Utilisateur : {turn.user}\nAssistant : {turn.bot}")
    history_str = "\n".join(history_snippets)

    # 4. Assemble the prompt
    prompt = (
        "Tu es un assistant intelligent. Voici des documents contextuels :\n"
        f"{context_str}\n\n"
        "Historique :\n"
        f"{history_str}\n\n"
        f"Nouvelle question : {request.message}\n\n"
        "Réponse :"
    )

    # 5. Call LLM server (Ollama/vLLM)
    llm_url = "http://localhost:11434/api/generate"  # Example for Ollama; adjust as needed
    llm_payload = {
        "model": "mistral",  # or "zephyr" if available
        "prompt": prompt,
        "stream": False
    }
    try:
        llm_response = requests.post(llm_url, json=llm_payload, timeout=60)
        llm_response.raise_for_status()
        llm_data = llm_response.json()
        # Ollama: response in 'response'; vLLM: may differ
        reply = llm_data.get("response") or llm_data.get("text") or "[Aucune réponse générée]"
    except Exception as e:
        logger.error(f"LLM call failed: {e}")
        reply = "Désolé, je ne peux pas répondre pour le moment."

    # 6. Return reply and sources
    return {
        "response": reply.strip(),
        "sources": search_results[:top_k]
    }
