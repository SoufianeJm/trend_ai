from typing import List, Dict

def format_response(
    intent: str,
    confidence: float,
    intent_description: str,
    search_results: List[Dict],
    query: str
) -> Dict:
    """
    Format the search response with intent details and results.
    
    Args:
        intent (str): The classified intent
        confidence (float): Confidence score of the intent
        intent_description (str): Description of the intent
        search_results (List[Dict]): List of search results from Milvus
        query (str): The original user query
        
    Returns:
        Dict: Formatted response containing intent details and search results
    """
    response = {
        "query": query,
        "intent": intent,
        "confidence": confidence,
        "description": intent_description,
        "results": search_results
    }
    
    # Add message if no results found
    if not search_results:
        response["message"] = "Aucun résultat trouvé pour cette requête."
    
    return response 