import { API } from 'aws-amplify';
import { Product } from '../types';

export class ProductService {
  static async searchProducts(query: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/products/search?q=${encodeURIComponent(query)}`);
      return response || [];
    } catch (error) {
      console.error('Error searching products:', error);
      return [];
    }
  }

  static async getProductsByCategory(category: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/products/category/${encodeURIComponent(category)}`);
      return response || [];
    } catch (error) {
      console.error('Error getting products by category:', error);
      return [];
    }
  }

  static async getProduct(barcode: string): Promise<Product | null> {
    try {
      const response = await API.get('FreshSaveAPI', `/products/${barcode}`);
      return response;
    } catch (error) {
      console.error('Error getting product:', error);
      return null;
    }
  }

  static async createProduct(productData: {
    barcode: string;
    name: string;
    brand: string;
    category: string;
    price?: number;
    unit?: string;
    imageUrl?: string;
    storeId: string;
  }): Promise<Product> {
    try {
      const product = {
        ...productData,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      const response = await API.post('FreshSaveAPI', '/products', {
        body: product,
      });

      return response;
    } catch (error) {
      console.error('Error creating product:', error);
      throw error;
    }
  }

  static async updateProduct(barcode: string, productData: Partial<Product>): Promise<Product> {
    try {
      const updateData = {
        ...productData,
        updatedAt: new Date().toISOString(),
      };

      const response = await API.put('FreshSaveAPI', `/products/${barcode}`, {
        body: updateData,
      });

      return response;
    } catch (error) {
      console.error('Error updating product:', error);
      throw error;
    }
  }

  static async deleteProduct(barcode: string): Promise<void> {
    try {
      await API.del('FreshSaveAPI', `/products/${barcode}`);
    } catch (error) {
      console.error('Error deleting product:', error);
      throw error;
    }
  }

  static async getProductsByStore(storeId: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/stores/${storeId}/products`);
      return response || [];
    } catch (error) {
      console.error('Error getting products by store:', error);
      return [];
    }
  }
} 