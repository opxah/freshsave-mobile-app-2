import { API } from 'aws-amplify';
import { Storage } from 'aws-amplify';
import { Store } from '../types';

export class StoreService {
  static async createStore(storeData: {
    name: string;
    logo?: any;
    contactInfo: {
      email: string;
      phone?: string;
      address?: string;
    };
    adminId: string;
  }): Promise<Store> {
    try {
      let logoUrl = '';
      
      // Upload logo if provided
      if (storeData.logo) {
        const fileName = `stores/${storeData.adminId}/logo-${Date.now()}`;
        await Storage.put(fileName, storeData.logo, {
          contentType: storeData.logo.type,
        });
        logoUrl = await Storage.get(fileName);
      }

      const store = {
        name: storeData.name,
        logo: logoUrl,
        contactInfo: storeData.contactInfo,
        adminId: storeData.adminId,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      const response = await API.post('FreshSaveAPI', '/stores', {
        body: store,
      });

      return response;
    } catch (error) {
      console.error('Error creating store:', error);
      throw error;
    }
  }

  static async getStore(storeId: string): Promise<Store | null> {
    try {
      const response = await API.get('FreshSaveAPI', `/stores/${storeId}`);
      return response;
    } catch (error) {
      console.error('Error getting store:', error);
      return null;
    }
  }

  static async getStoreByAdmin(adminId: string): Promise<Store | null> {
    try {
      const response = await API.get('FreshSaveAPI', `/stores/admin/${adminId}`);
      return response;
    } catch (error) {
      console.error('Error getting store by admin:', error);
      return null;
    }
  }

  static async updateStore(storeId: string, storeData: Partial<Store>): Promise<Store> {
    try {
      let logoUrl = storeData.logo;
      
      // Upload new logo if provided
      if (storeData.logo && typeof storeData.logo !== 'string') {
        const fileName = `stores/${storeId}/logo-${Date.now()}`;
        await Storage.put(fileName, storeData.logo, {
          contentType: storeData.logo.type,
        });
        logoUrl = await Storage.get(fileName);
      }

      const updateData = {
        ...storeData,
        logo: logoUrl,
        updatedAt: new Date().toISOString(),
      };

      const response = await API.put('FreshSaveAPI', `/stores/${storeId}`, {
        body: updateData,
      });

      return response;
    } catch (error) {
      console.error('Error updating store:', error);
      throw error;
    }
  }

  static async getStoreStats(storeId: string): Promise<{
    totalProducts: number;
    lastUpdated: string;
    categories: string[];
  }> {
    try {
      const response = await API.get('FreshSaveAPI', `/stores/${storeId}/stats`);
      return response;
    } catch (error) {
      console.error('Error getting store stats:', error);
      return {
        totalProducts: 0,
        lastUpdated: new Date().toISOString(),
        categories: [],
      };
    }
  }
} 