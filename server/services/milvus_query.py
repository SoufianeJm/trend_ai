import os
from typing import List, Dict, Optional
from pymilvus import connections, Collection

# Milvus configuration
# These values are expected to be set in the environment:
# - MILVUS_URI: The full Zilliz Cloud connection URI (e.g., "https://in01-xxxx.zillizcloud.com")
# - MILVUS_TOKEN: The Zilliz Cloud API token/key
COLLECTION_NAME = "content_items"
VECTOR_FIELD_NAME = "embedding"

def search_content(query_embedding: List[float], top_k: int = 3, filter_expr: Optional[str] = None) -> List[Dict]:
    """
    Search Milvus collection for similar content using the query embedding and optional filters.
    
    Args:
        query_embedding (List[float]): The embedding vector of the query
        top_k (int): Number of results to return (default: 3)
        filter_expr (Optional[str]): Milvus filter expression to apply to the search.
            Examples:
            - Filter by year: 'date LIKE "2017%"'
            - Filter by content type: 'type == "match"'
            - Compound filter: 'type == "match" AND date LIKE "2017%"'
            If None, no filter will be applied.
        
    Returns:
        List[Dict]: List of search results, each containing the document fields
    """
    # Get Milvus connection details from environment
    milvus_uri = os.getenv("MILVUS_URI")
    milvus_token = os.getenv("MILVUS_TOKEN")
    
    if not milvus_uri or not milvus_token:
        raise RuntimeError("MILVUS_URI and MILVUS_TOKEN environment variables must be set for Zilliz Cloud connection")
    
    # Connect to Zilliz Cloud Milvus instance using URI and token
    connections.connect(
        uri=milvus_uri,
        token=milvus_token
    )
    
    # Get collection and load it
    collection = Collection(COLLECTION_NAME)
    collection.load()
    
    # Define search parameters
    search_params = {
        "metric_type": "COSINE",
        "params": {"nprobe": 10}
    }
    
    # Perform search with optional filter
    results = collection.search(
        data=[query_embedding],
        anns_field=VECTOR_FIELD_NAME,
        param=search_params,
        limit=top_k,
        expr=filter_expr,  # Apply the filter expression if provided
        output_fields=['id', 'type', 'title', 'description', 'date', 'time', 'extra'],
        consistency_level="Strong"
    )
    
    # Process results
    search_results = []
    for hits in results:
        for hit in hits:
            result = {
                'id': hit.id,
                'score': hit.score,
                **{field: hit.entity.get(field) for field in ['type', 'title', 'description', 'date', 'time', 'extra']}
            }
            search_results.append(result)
    
    return search_results 