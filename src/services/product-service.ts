import { API } from 'aws-amplify';
import { Storage } from 'aws-amplify';
import { Product, ProductFormData } from '../types';

// Mock product database for Yuka-style demonstration
const MOCK_PRODUCTS = {
  '4000607151002': {
    id: '4000607151002',
    name: 'Alpenvollmilch',
    brand: 'Schogetten',
    image: 'https://via.placeholder.com/80x80/4CAF50/FFFFFF?text=🍫',
    barcode: '4000607151002',
    score: 32,
    rating: 'Mittelmäßig',
    category: 'Chocolate',
    price: 2.99,
    unit: '100g',
    ingredients: ['Zucker', 'Kakaobutter', 'Sahnepulver', 'Kakaomasse', 'Vollmilchpulver'],
    allergens: ['Milch', 'Soja', 'Gluten', 'Ei'],
    nutritionalInfo: {
      calories: 551,
      fat: 33,
      saturatedFat: 20,
      carbohydrates: 57,
      sugar: 56,
      protein: 5.5,
      salt: 0.14
    }
  },
  '3017620422003': {
    id: '3017620422003',
    name: 'Nutella',
    brand: 'Ferrero',
    image: 'https://via.placeholder.com/80x80/8B4513/FFFFFF?text=🥜',
    barcode: '3017620422003',
    score: 25,
    rating: 'Schlecht',
    category: 'Spread',
    price: 4.50,
    unit: '400g',
    ingredients: ['Zucker', 'Palmöl', 'Haselnüsse', 'Kakaopulver', 'Magermilchpulver'],
    allergens: ['Haselnüsse', 'Milch'],
    nutritionalInfo: {
      calories: 539,
      fat: 30.9,
      saturatedFat: 10.6,
      carbohydrates: 57.5,
      sugar: 56.8,
      protein: 6.3,
      salt: 0.11
    }
  },
  '4000417025008': {
    id: '4000417025008',
    name: 'Bio Apfel',
    brand: 'Alnatura',
    image: 'https://via.placeholder.com/80x80/90EE90/FFFFFF?text=🍎',
    barcode: '4000417025008',
    score: 95,
    rating: 'Sehr gut',
    category: 'Fruits',
    price: 3.99,
    unit: '1kg',
    ingredients: ['Bio Apfel'],
    allergens: [],
    nutritionalInfo: {
      calories: 52,
      fat: 0.2,
      saturatedFat: 0,
      carbohydrates: 14,
      sugar: 10,
      protein: 0.3,
      salt: 0
    }
  },
  '4000417025009': {
    id: '4000417025009',
    name: 'Vollkornbrot',
    brand: 'Mestemacher',
    image: 'https://via.placeholder.com/80x80/D2B48C/FFFFFF?text=🍞',
    barcode: '4000417025009',
    score: 78,
    rating: 'Gut',
    category: 'Bread',
    price: 2.49,
    unit: '500g',
    ingredients: ['Vollkornroggenmehl', 'Wasser', 'Sauerteig', 'Salz'],
    allergens: ['Gluten'],
    nutritionalInfo: {
      calories: 220,
      fat: 1.2,
      saturatedFat: 0.2,
      carbohydrates: 45,
      sugar: 2.1,
      protein: 8.5,
      salt: 1.1
    }
  }
};

export class ProductService {
  static async createProduct(productData: ProductFormData, storeId: string): Promise<Product> {
    try {
      let imageUrl = '';
      
      // Upload image if provided
      if (productData.image) {
        const fileName = `products/${storeId}/${Date.now()}-${productData.barcode}`;
        await Storage.put(fileName, productData.image, {
          contentType: productData.image.type,
        });
        imageUrl = await Storage.get(fileName);
      }

      const product = {
        barcode: productData.barcode,
        name: productData.name,
        brand: productData.brand,
        category: productData.category,
        price: productData.price ? parseFloat(productData.price) : undefined,
        unit: productData.unit,
        imageUrl,
        storeId,
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

  static async getProductByBarcode(barcode: string): Promise<Product | null> {
    try {
      // Check mock database first for Yuka-style demonstration
      const mockProduct = MOCK_PRODUCTS[barcode as keyof typeof MOCK_PRODUCTS];
      if (mockProduct) {
        return mockProduct as Product;
      }

      // Fallback to API call
      const response = await API.get('FreshSaveAPI', `/products/${barcode}`);
      return response;
    } catch (error) {
      console.error('Error getting product:', error);
      return null;
    }
  }

  static async getProductsByStore(storeId: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/stores/${storeId}/products`);
      return response.products || [];
    } catch (error) {
      console.error('Error getting store products:', error);
      return [];
    }
  }

  static async updateProduct(barcode: string, productData: Partial<ProductFormData>): Promise<Product> {
    try {
      let imageUrl = productData.imageUrl;
      
      // Upload new image if provided
      if (productData.image) {
        const fileName = `products/${Date.now()}-${barcode}`;
        await Storage.put(fileName, productData.image, {
          contentType: productData.image.type,
        });
        imageUrl = await Storage.get(fileName);
      }

      const updateData = {
        ...productData,
        imageUrl,
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

  static async searchProducts(query: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/products/search?q=${encodeURIComponent(query)}`);
      return response.products || [];
    } catch (error) {
      console.error('Error searching products:', error);
      return [];
    }
  }

  static async getProductsByCategory(category: string): Promise<Product[]> {
    try {
      const response = await API.get('FreshSaveAPI', `/products/category/${encodeURIComponent(category)}`);
      return response.products || [];
    } catch (error) {
      console.error('Error getting products by category:', error);
      return [];
    }
  }
} 