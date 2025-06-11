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
    Chatbot endpoint: only answers greetings or questions with relevant context. Otherwise, apologizes.
    """
    logger.info(f"Received chat message: '{request.message}'")

    # 1. Embed and retrieve context
    query_embedding = embed_query(request.message)
    top_k = 5
    search_results = search_content(query_embedding=query_embedding, top_k=top_k)

    # 2. Determine if there are relevant results
    min_score = 0.5
    relevant_results = [r for r in search_results if r.get('score', 0) > min_score]

    # 3. Detect greeting
    greetings = [
        "bonjour", "salut", "coucou", "bonsoir", "hello", "hey", "allo", "salam"
    ]
    msg_lower = request.message.strip().lower()
    is_greeting = any(greet in msg_lower for greet in greetings) and len(msg_lower.split()) <= 4

    # 4. If not greeting and no relevant results, return apology
    if not is_greeting and not relevant_results:
        return {
            "response": "Désolé, je n'ai pas trouvé d'information pertinente dans ma base de connaissances.",
            "sources": search_results[:top_k]
        }

    # 5. Build context snippet
    context_snippets = []
    for item in relevant_results:
        title = item.get('title', '').strip()
        description = item.get('description', '').strip()
        if title or description:
            context_snippets.append(f"[{title}] : {description}")
    context_str = "\n".join(context_snippets)

    # 6. Build chat history in French format
    history_snippets = []
    for turn in request.history[-4:]:  # Limit to last 4 turns for brevity
        history_snippets.append(f"Utilisateur : {turn.user}\nAssistant : {turn.bot}")
    history_str = "\n".join(history_snippets)

    # 7. Assemble the prompt with system instruction
    prompt = (
        "Tu es un assistant intelligent. Voici des documents contextuels :\n"
        f"{context_str}\n\n"
        "Historique :\n"
        f"{history_str}\n\n"
        f"Nouvelle question : {request.message}\n\n"
        "IMPORTANT : Si la question n'est qu'une salutation, réponds gentiment. Si la question ne concerne pas le contexte fourni, réponds strictement : 'Désolé, je n'ai pas trouvé d'information pertinente dans ma base de connaissances.' Sinon, réponds en te basant uniquement sur les documents contextuels.\n"
        "Réponse :"
    )

    # 8. Call LLM server (Ollama/vLLM) if allowed
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
        reply = llm_data.get("response") or llm_data.get("text") or "[Aucune réponse générée]"
    except Exception as e:
        logger.error(f"LLM call failed: {e}")
        reply = "Désolé, je ne peux pas répondre pour le moment."

    # 9. Return reply and sources
    return {
        "response": reply.strip(),
        "sources": relevant_results[:top_k] if relevant_results else search_results[:top_k]
    }
