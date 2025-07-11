import requests
import pandas as pd

def test_company_api():
    """Test fetching articles from your company's API"""
    COMPANY_API_URL = 'https://api.snrtbotola.ma'
    
    try:
        response = requests.get(f"{COMPANY_API_URL}/api-fo/articles-videos", 
                              params={
                                  "pageNo": 0,
                                  "lang": "fr",
                                  "pageSize": 10,  # Small test
                                  "rowSize": 2,
                                  "type": "all",
                              })
        
        print(f"Status Code: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            articles = data.get('content', [])
            
            print(f"Total articles fetched: {len(articles)}")
            
            # Filter non-video articles with images
            filtered_articles = [
                article for article in articles 
                if not article.get('isVideo', False) and article.get('image', '').strip()
            ]
            
            print(f"Filtered articles: {len(filtered_articles)}")
            
            if filtered_articles:
                print("\nSample article:")
                sample = filtered_articles[0]
                print(f"ID: {sample.get('id')}")
                print(f"Title: {sample.get('title')}")
                print(f"Category: {sample.get('categorieLabel')}")
                print(f"Published: {sample.get('publishedAt')}")
                
                # Show all available categories
                categories = list(set(article.get('categorieLabel', 'Unknown') for article in filtered_articles))
                print(f"\nAvailable categories: {categories}")
                
                return True
            else:
                print("No articles found after filtering")
                return False
        else:
            print(f"Error: {response.status_code}")
            return False
            
    except Exception as e:
        print(f"Error fetching articles: {e}")
        return False

if __name__ == "__main__":
    test_company_api()
