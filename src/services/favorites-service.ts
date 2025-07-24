import { API } from 'aws-amplify';
import { FavoriteProduct, Product } from '../types';

export class FavoritesService {
  static async addToFavorites(userId: string, productBarcode: string): Promise<FavoriteProduct> {
    try {
      const favorite = {
        userId,
        productBarcode,
        createdAt: new Date().toISOString(),
      };

      const response = await API.post('FreshSaveAPI', '/favorites', {
        body: favorite,
      });

      return response;
    } catch (error) {
      console.error('Error adding to favorites:', error);
      throw error;
    }
  }

  static async removeFromFavorites(userId: string, productBarcode: string): Promise<void> {
    try {
      await API.del('FreshSaveAPI', `/favorites/${userId}/${productBarcode}`);
    } catch (error) {
      console.error('Error removing from favorites:', error);
      throw error;
    }
  }

  static async getFavorites(userId: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/favorites/${userId}`);
      return response.products || [];
    } catch (error) {
      console.error('Error getting favorites:', error);
      return [];
    }
  }

  static async isFavorite(userId: string, productBarcode: string): Promise<boolean> {
    try {
      const response = await API.get('FreshSaveAPI', `/favorites/${userId}/${productBarcode}`);
      return response.isFavorite || false;
    } catch (error) {
      console.error('Error checking favorite status:', error);
      return false;
    }
  }
} 