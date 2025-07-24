export type UserRole = 'customer' | 'store_admin';

export interface User {
  id: string;
  email: string;
  role: UserRole;
  storeId?: string; // Only for store_admin
  createdAt: string;
  updatedAt: string;
}

export interface Store {
  id: string;
  name: string;
  logo?: string;
  contactInfo: {
    email: string;
    phone?: string;
    address?: string;
  };
  adminId: string;
  createdAt: string;
  updatedAt: string;
}

export interface Product {
  barcode: string;
  name: string;
  brand: string;
  category: string;
  imageUrl?: string;
  price?: number;
  unit?: string;
  storeId: string;
  createdAt: string;
  updatedAt: string;
}

export interface FavoriteProduct {
  id: string;
  userId: string;
  productBarcode: string;
  createdAt: string;
}

export interface AuthContextType {
  user: User | null;
  isLoading: boolean;
  signIn: (email: string, password: string) => Promise<void>;
  signUp: (email: string, password: string, role: UserRole, storeName?: string) => Promise<void>;
  signOut: () => Promise<void>;
}

export interface ProductFormData {
  barcode: string;
  name: string;
  brand: string;
  category: string;
  price?: string;
  unit?: string;
  image?: any;
} 