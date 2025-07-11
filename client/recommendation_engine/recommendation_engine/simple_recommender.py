import os
import json
import urllib.request
import urllib.parse
from collections import defaultdict
from dotenv import load_dotenv

# Load environment variables
load_dotenv('../.env')

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
COMPANY_API_URL = 'https://api.snrtbotola.ma'

class SimpleRecommendationEngine:
    def __init__(self):
        self.supabase_url = SUPABASE_URL
        self.supabase_key = SUPABASE_KEY
        
    def fetch_articles_from_company_api(self, page_size=50):
        """Fetch articles from your company's API"""
        try:
            params = {
                'pageNo': 0,
                'lang': 'fr',
                'pageSize': page_size,
                'rowSize': 2,
                'type': 'all'
            }
            
            url = f"{COMPANY_API_URL}/api-fo/articles-videos?{urllib.parse.urlencode(params)}"
            
            with urllib.request.urlopen(url) as response:
                data = json.loads(response.read().decode())
            
            articles = data.get('content', [])
            
            # Filter non-video articles with images (matching your Flutter logic)
            filtered_articles = [
                article for article in articles 
                if not article.get('isVideo', False) and article.get('image', '').strip()
            ]
            
            return filtered_articles
            
        except Exception as e:
            print(f"Error fetching articles: {e}")
            return []
    
    def supabase_request(self, table, method='GET', data=None, filters=None):
        """Make requests to Supabase API"""
        try:
            url = f"{self.supabase_url}/rest/v1/{table}"
            
            # Add filters for GET requests
            if filters and method == 'GET':
                query_params = []
                for key, value in filters.items():
                    query_params.append(f"{key}=eq.{value}")
                if query_params:
                    url += "?" + "&".join(query_params)
            
            # Create request
            req = urllib.request.Request(url)
            req.add_header('apikey', self.supabase_key)
            req.add_header('Authorization', f'Bearer {self.supabase_key}')
            req.add_header('Content-Type', 'application/json')
            
            if method == 'POST':
                req.data = json.dumps(data).encode('utf-8')
                req.get_method = lambda: 'POST'
            
            with urllib.request.urlopen(req) as response:
                return json.loads(response.read().decode())
                
        except Exception as e:
            print(f"Supabase request error: {e}")
            return [] if method == 'GET' else False
    
    def track_user_interaction(self, user_id, article_id, interaction_type='view'):
        """Track user interaction in Supabase"""
        score_map = {'view': 1, 'share': 3, 'like': 5}
        score = score_map.get(interaction_type, 1)
        
        interaction_data = {
            'user_id': user_id,
            'article_id': article_id,
            'interaction_type': interaction_type,
            'interaction_score': score
        }
        
        result = self.supabase_request('user_interactions', 'POST', interaction_data)
        return result is not False
    
    def get_user_interactions(self, user_id):
        """Get user interactions from Supabase"""
        return self.supabase_request('user_interactions', 'GET', filters={'user_id': user_id})
    
    def get_user_preference_categories(self, user_id):
        """Get user's preferred categories based on interactions"""
        interactions = self.get_user_interactions(user_id)
        
        if not interactions:
            return []
        
        # Get all articles to match interactions
        articles = self.fetch_articles_from_company_api()
        
        # Create article lookup
        article_lookup = {article['id']: article for article in articles}
        
        # Count category preferences
        category_scores = defaultdict(int)
        
        for interaction in interactions:
            article_id = interaction['article_id']
            article = article_lookup.get(article_id)
            
            if article:
                category = article.get('categorieLabel', 'Unknown')
                score = interaction.get('interaction_score', 1)
                category_scores[category] += score
        
        # Return sorted categories by score
        return sorted(category_scores.items(), key=lambda x: x[1], reverse=True)
    
    def get_recommendations(self, user_id, num_recommendations=5):
        """Generate recommendations for a user"""
        print(f"🔍 Getting recommendations for user: {user_id}")
        
        # Get all articles
        articles = self.fetch_articles_from_company_api()
        print(f"📰 Fetched {len(articles)} articles")
        
        if not articles:
            return []
        
        # Get user interactions
        interactions = self.get_user_interactions(user_id)
        print(f"👤 User has {len(interactions)} interactions")
        
        if not interactions:
            # New user - return diverse articles from different categories
            print("🆕 New user detected - providing diverse content")
            
            # Group articles by category
            category_articles = defaultdict(list)
            for article in articles:
                category = article.get('categorieLabel', 'Unknown')
                category_articles[category].append(article)
            
            # Get 2 articles from each category, up to num_recommendations
            recommendations = []
            for category, cat_articles in category_articles.items():
                # Sort by date (most recent first)
                cat_articles.sort(key=lambda x: x.get('publishedAt', ''), reverse=True)
                recommendations.extend(cat_articles[:2])
                
                if len(recommendations) >= num_recommendations:
                    break
            
            return recommendations[:num_recommendations]
        
        # Existing user - personalized recommendations
        print("👨‍💼 Existing user - generating personalized recommendations")
        
        # Get user preferences
        preferences = self.get_user_preference_categories(user_id)
        print(f"📊 User preferences: {preferences}")
        
        # Get articles user has already seen
        seen_article_ids = {interaction['article_id'] for interaction in interactions}
        unseen_articles = [article for article in articles if article['id'] not in seen_article_ids]
        
        print(f"👀 User has seen {len(seen_article_ids)} articles")
        print(f"🔄 {len(unseen_articles)} unseen articles available")
        
        if not preferences:
            # User has interactions but no clear preferences
            return unseen_articles[:num_recommendations]
        
        # Recommend based on preferences
        recommendations = []
        
        # First, add articles from preferred categories
        for category, score in preferences:
            category_articles = [
                article for article in unseen_articles 
                if article.get('categorieLabel') == category
            ]
            
            if category_articles:
                # Sort by date (most recent first)
                category_articles.sort(key=lambda x: x.get('publishedAt', ''), reverse=True)
                recommendations.extend(category_articles[:2])  # Max 2 per category
                
                if len(recommendations) >= num_recommendations:
                    break
        
        # Fill remaining spots with other articles
        if len(recommendations) < num_recommendations:
            other_articles = [
                article for article in unseen_articles 
                if article not in recommendations
            ]
            remaining = num_recommendations - len(recommendations)
            recommendations.extend(other_articles[:remaining])
        
        return recommendations[:num_recommendations]

def main():
    """Test the recommendation engine"""
    print("🚀 Testing Simple Recommendation Engine")
    print("=" * 50)
    
    engine = SimpleRecommendationEngine()
    
    # Test 1: New user recommendations
    print("\n🧪 TEST 1: New user recommendations")
    new_user_recs = engine.get_recommendations("new_user_123", 5)
    
    if new_user_recs:
        print(f"✅ Got {len(new_user_recs)} recommendations for new user:")
        for i, article in enumerate(new_user_recs, 1):
            print(f"  {i}. {article.get('title', 'No title')} ({article.get('categorieLabel', 'No category')})")
    else:
        print("❌ No recommendations for new user")
    
    # Test 2: Simulate user interaction
    print("\n🧪 TEST 2: Tracking user interaction")
    if new_user_recs:
        article_id = new_user_recs[0]['id']
        success = engine.track_user_interaction("test_user_456", article_id, "view")
        print(f"✅ Interaction tracked: {success}")
        
        # Get recommendations for this user
        print("\n🧪 TEST 3: Recommendations for user with interactions")
        user_recs = engine.get_recommendations("test_user_456", 5)
        
        if user_recs:
            print(f"✅ Got {len(user_recs)} recommendations for existing user:")
            for i, article in enumerate(user_recs, 1):
                print(f"  {i}. {article.get('title', 'No title')} ({article.get('categorieLabel', 'No category')})")
    
    print("\n🎉 All tests completed!")

if __name__ == "__main__":
    main()
