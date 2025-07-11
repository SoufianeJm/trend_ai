import json
import urllib.request
import urllib.parse

def test_company_api():
    """Test fetching articles from your company's API using basic urllib"""
    base_url = 'https://api.snrtbotola.ma/api-fo/articles-videos'
    
    # Build query parameters
    params = {
        'pageNo': 0,
        'lang': 'fr',
        'pageSize': 5,
        'rowSize': 2,
        'type': 'all'
    }
    
    # Create URL with parameters
    url = f"{base_url}?{urllib.parse.urlencode(params)}"
    
    print(f"Testing URL: {url}")
    
    try:
        # Make request
        with urllib.request.urlopen(url) as response:
            data = json.loads(response.read().decode())
            
        print(f"✅ Successfully fetched data!")
        print(f"Status: {response.status}")
        
        # Extract articles
        articles = data.get('content', [])
        print(f"Total articles: {len(articles)}")
        
        # Filter articles (same logic as your Flutter app)
        filtered_articles = [
            article for article in articles 
            if not article.get('isVideo', False) and article.get('image', '').strip()
        ]
        
        print(f"Filtered articles: {len(filtered_articles)}")
        
        if filtered_articles:
            print("\n📰 Sample article:")
            sample = filtered_articles[0]
            print(f"  ID: {sample.get('id')}")
            print(f"  Title: {sample.get('title', 'No title')}")
            print(f"  Category: {sample.get('categorieLabel', 'No category')}")
            print(f"  Published: {sample.get('publishedAt', 'No date')}")
            
            # Show categories
            categories = list(set(
                article.get('categorieLabel', 'Unknown') 
                for article in filtered_articles
            ))
            print(f"\n🏷️  Available categories: {categories}")
            
            return True
        else:
            print("❌ No articles found after filtering")
            return False
            
    except Exception as e:
        print(f"❌ Error: {e}")
        return False

if __name__ == "__main__":
    print("🚀 Testing company API connection...")
    success = test_company_api()
    
    if success:
        print("\n✅ API test successful! Ready to build recommendations.")
    else:
        print("\n❌ API test failed. Check your internet connection.")
