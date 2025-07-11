import os
import pandas as pd
import requests
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
from supabase import create_client, Client
from dotenv import load_dotenv
from collections import defaultdict

load_dotenv()

SUPABASE_URL = os.getenv('SUPABASE_URL')
SUPABASE_KEY = os.getenv('SUPABASE_KEY')
COMPANY_API_URL = 'https://api.snrtbotola.ma'  # Your company's API

class RecommendationEngine:
    def __init__(self, supabase_url: str, supabase_key: str):
        self.supabase: Client = create_client(supabase_url, supabase_key)
        self.vectorizer = TfidfVectorizer(max_features=100, stop_words='english')
    
    def fetch_articles_from_company_api(self):
        """Fetch articles from your company's API"""
        try:
            response = requests.get(f"{COMPANY_API_URL}/api-fo/articles-videos", 
                                  params={
                                      "pageNo": 0,
                                      "lang": "fr",
                                      "pageSize": 100,  # Get more articles for better recommendations
                                      "rowSize": 2,
                                      "type": "all",
                                  })
            
            if response.status_code == 200:
                data = response.json()
                articles = data.get('content', [])
                
                # Filter non-video articles with images (matching your current logic)
                filtered_articles = [
                    article for article in articles 
                    if not article.get('isVideo', False) and article.get('image', '').strip()
                ]
                
                return pd.DataFrame(filtered_articles)
            else:
                print(f"Error fetching articles: {response.status_code}")
                return pd.DataFrame()
        except Exception as e:
            print(f"Error fetching articles from API: {e}")
            return pd.DataFrame()
    
    def fetch_user_interactions(self, user_id: str):
        """Fetch user interactions from Supabase"""
        try:
            response = self.supabase.table('user_interactions').select('*').eq('user_id', user_id).execute()
            return pd.DataFrame(response.data)
        except Exception as e:
            print(f"Error fetching user interactions: {e}")
            return pd.DataFrame()
    
    def track_user_interaction(self, user_id: str, article_id: int, interaction_type: str = 'view'):
        """Track user interaction in Supabase"""
        try:
            # Map interaction types to scores
            score_map = {'view': 1, 'share': 3, 'like': 5}
            score = score_map.get(interaction_type, 1)
            
            self.supabase.table('user_interactions').insert({
                'user_id': user_id,
                'article_id': article_id,
                'interaction_type': interaction_type,
                'interaction_score': score
            }).execute()
            
            return True
        except Exception as e:
            print(f"Error tracking interaction: {e}")
            return False
    
    def get_user_preference_categories(self, user_id: str):
        """Get user's preferred categories based on interactions"""
        interactions = self.fetch_user_interactions(user_id)
        
        if interactions.empty:
            return []
        
        # Get articles the user has interacted with
        articles = self.fetch_articles_from_company_api()
        
        if articles.empty:
            return []
        
        # Get user's article IDs
        user_article_ids = interactions['article_id'].tolist()
        user_articles = articles[articles['id'].isin(user_article_ids)]
        
        # Count category preferences weighted by interaction score
        category_scores = defaultdict(int)
        
        for _, interaction in interactions.iterrows():
            article = user_articles[user_articles['id'] == interaction['article_id']]
            if not article.empty:
                category = article.iloc[0]['categorieLabel']
                category_scores[category] += interaction.get('interaction_score', 1)
        
        # Return top categories
        return sorted(category_scores.items(), key=lambda x: x[1], reverse=True)
    
    def get_content_based_recommendations(self, user_id: str, num_recommendations: int = 5):
        """Generate content-based recommendations"""
        # Get all articles
        articles = self.fetch_articles_from_company_api()
        
        if articles.empty:
            return pd.DataFrame()
        
        # Get user interactions
        interactions = self.fetch_user_interactions(user_id)
        
        if interactions.empty:
            # New user - return popular articles from different categories
            return articles.groupby('categorieLabel').head(2).head(num_recommendations)
        
        # Get user's preferred categories
        preferred_categories = self.get_user_preference_categories(user_id)
        
        if not preferred_categories:
            return articles.head(num_recommendations)
        
        # Get articles the user hasn't seen
        seen_article_ids = interactions['article_id'].tolist()
        unseen_articles = articles[~articles['id'].isin(seen_article_ids)]
        
        # Prioritize articles from preferred categories
        recommendations = pd.DataFrame()
        
        for category, score in preferred_categories:
            category_articles = unseen_articles[unseen_articles['categorieLabel'] == category]
            if not category_articles.empty:
                # Get recent articles from this category
                category_articles = category_articles.sort_values('publishedAt', ascending=False)
                recommendations = pd.concat([recommendations, category_articles.head(2)])
        
        # Fill remaining slots with popular articles
        if len(recommendations) < num_recommendations:
            remaining = num_recommendations - len(recommendations)
            other_articles = unseen_articles[~unseen_articles['id'].isin(recommendations['id'])]
            recommendations = pd.concat([recommendations, other_articles.head(remaining)])
        
        return recommendations.head(num_recommendations)
    
    def get_recommendations(self, user_id: str, num_recommendations: int = 5):
        """Main method to get recommendations for a user"""
        return self.get_content_based_recommendations(user_id, num_recommendations)


def main():
    # Test the recommendation engine
    engine = RecommendationEngine(SUPABASE_URL, SUPABASE_KEY)
    
    # Test fetching articles
    articles = engine.fetch_articles_from_company_api()
    print(f"Fetched {len(articles)} articles")
    
    # Test recommendations for a new user
    recommendations = engine.get_recommendations(user_id="test_user_123")
    print(f"\nRecommendations for new user:")
    print(recommendations[['id', 'title', 'categorieLabel']].head())
    
    # Simulate user interaction
    if not recommendations.empty:
        article_id = recommendations.iloc[0]['id']
        engine.track_user_interaction("test_user_123", article_id, "view")
        print(f"\nTracked interaction with article {article_id}")
        
        # Get updated recommendations
        updated_recommendations = engine.get_recommendations(user_id="test_user_123")
        print(f"\nUpdated recommendations:")
        print(updated_recommendations[['id', 'title', 'categorieLabel']].head())


if __name__ == "__main__":
    main()
