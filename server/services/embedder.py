from typing import List
from pymilvus.model.hybrid import BGEM3EmbeddingFunction

def embed_query(query_text: str) -> List[float]:
    """
    Embed a natural language query using BGE-M3 model.
    
    Args:
        query_text (str): The natural language query to embed
        
    Returns:
        List[float]: The dense embedding vector for the query
    """
    # Initialize the BGE-M3 embedding function
    embedder = BGEM3EmbeddingFunction(
        model_name='BAAI/bge-m3',
        device='cpu',
        use_fp16=False
    )
    
    # Get embeddings for the query
    # encode_queries expects a list of strings
    embeddings = embedder.encode_queries([query_text])
    
    # Extract the dense embedding vector
    # The first element since we only passed one query
    dense_embedding = embeddings['dense'][0]
    
    return dense_embedding 