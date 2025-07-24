import { API } from 'aws-amplify';
import { Storage } from 'aws-amplify';
import { Product, ProductFormData } from '../types';

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