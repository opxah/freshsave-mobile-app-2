import React, { createContext, useContext, useState, useEffect, ReactNode } from 'react';
import { AuthContextType, User, UserRole } from '../types';
import { AuthService } from '../services/auth-service';

const AuthContext = createContext<AuthContextType | undefined>(undefined);

export const useAuth = () => {
  const context = useContext(AuthContext);
  if (context === undefined) {
    throw new Error('useAuth must be used within an AuthProvider');
  }
  return context;
};

interface AuthProviderProps {
  children: ReactNode;
}

export const AuthProvider: React.FC<AuthProviderProps> = ({ children }) => {
  const [user, setUser] = useState<User | null>(null);
  const [isLoading, setIsLoading] = useState(true);

  console.log('AuthProvider rendering, isLoading:', isLoading);

  useEffect(() => {
    console.log('AuthProvider useEffect running');
    checkAuthState();
  }, []);

  const checkAuthState = async () => {
    try {
      console.log('Checking auth state...');
      const currentUser = await AuthService.getCurrentUser();
      console.log('Current user:', currentUser);
      setUser(currentUser);
    } catch (error) {
      console.error('Error checking auth state:', error);
      setUser(null);
    } finally {
      console.log('Setting isLoading to false');
      setIsLoading(false);
    }
  };

  const signIn = async (email: string, password: string) => {
    try {
      setIsLoading(true);
      const user = await AuthService.signIn(email, password);
      setUser(user);
    } catch (error) {
      console.error('Error signing in:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const signUp = async (email: string, password: string, role: UserRole, storeName?: string) => {
    try {
      setIsLoading(true);
      await AuthService.signUp(email, password, role, storeName);
    } catch (error) {
      console.error('Error signing up:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const signOut = async () => {
    try {
      setIsLoading(true);
      await AuthService.signOut();
      setUser(null);
    } catch (error) {
      console.error('Error signing out:', error);
      throw error;
    } finally {
      setIsLoading(false);
    }
  };

  const value: AuthContextType = {
    user,
    isLoading,
    signIn,
    signUp,
    signOut,
  };

  console.log('AuthProvider rendering with value:', { user: !!user, isLoading });

  return <AuthContext.Provider value={value}>{children}</AuthContext.Provider>;
}; 