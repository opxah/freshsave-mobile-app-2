import { User, UserRole } from '../types';

// Temporary mock authentication service for development
// This will be replaced with real AWS Amplify authentication once backend is fully set up
export class AuthService {
  private static mockUsers: User[] = [
    {
      id: '1',
      email: 'customer@test.com',
      role: 'customer',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    },
    {
      id: '2',
      email: 'admin@test.com',
      role: 'store_admin',
      storeId: 'store1',
      createdAt: new Date().toISOString(),
      updatedAt: new Date().toISOString(),
    }
  ];

  private static currentUser: User | null = null;

  static async signUp(email: string, password: string, role: UserRole, storeName?: string): Promise<void> {
    try {
      console.log('Mock AuthService.signUp called with:', { email, role, storeName });
      
      // Simulate API delay
      await new Promise(resolve => setTimeout(resolve, 1000));
      
      // Check if user already exists
      const existingUser = this.mockUsers.find(user => user.email === email);
      if (existingUser) {
        throw new Error('User already exists');
      }

      // Create new user
      const newUser: User = {
        id: (this.mockUsers.length + 1).toString(),
        email,
        role,
        storeId: role === 'store_admin' ? `store_${Date.now()}` : undefined,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
      };

      this.mockUsers.push(newUser);
      console.log('Mock signUp completed successfully');
    } catch (error) {
      console.error('Error signing up:', error);
      throw error;
    }
  }

  static async signIn(email: string, password: string): Promise<User> {
    try {
      console.log('Mock AuthService.signIn called with email:', email);

      // Simulate API delay
      await new Promise(resolve => setTimeout(resolve, 1000));

      // For demo purposes, accept any email/password combination
      // In real app, this would validate against Cognito
      let user = this.mockUsers.find(u => u.email === email);
      
      if (!user) {
        // Create a new user if they don't exist (for demo purposes)
        user = {
          id: (this.mockUsers.length + 1).toString(),
          email,
          role: 'customer', // Default to customer
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
        };
        this.mockUsers.push(user);
      }

      this.currentUser = user;
      console.log('Mock signIn completed, user:', user);
      
      return user;
    } catch (error) {
      console.error('Error signing in:', error);
      throw error;
    }
  }

  static async signOut(): Promise<void> {
    try {
      console.log('Mock signOut called');
      this.currentUser = null;
    } catch (error) {
      console.error('Error signing out:', error);
      throw error;
    }
  }

  static async getCurrentUser(): Promise<User | null> {
    try {
      console.log('Mock getCurrentUser called, returning:', this.currentUser);
      return this.currentUser;
    } catch (error) {
      console.error('Error getting current user:', error);
      return null;
    }
  }

  static async isAuthenticated(): Promise<boolean> {
    try {
      return this.currentUser !== null;
    } catch {
      return false;
    }
  }
} 