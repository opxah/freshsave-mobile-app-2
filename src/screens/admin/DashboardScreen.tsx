import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView, Alert } from 'react-native';
import { Text, Card, Button, ActivityIndicator, IconButton } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../../contexts/AuthContext';
import { StoreService } from '../../services/store-service';
import { ProductService } from '../../services/product-service';
import { Store } from '../../types';

const DashboardScreen: React.FC = () => {
  const [store, setStore] = useState<Store | null>(null);
  const [stats, setStats] = useState({
    totalProducts: 0,
    lastUpdated: '',
    categories: [] as string[],
  });
  const [isLoading, setIsLoading] = useState(true);
  const navigation = useNavigation();
  const { user, signOut } = useAuth();

  useEffect(() => {
    loadDashboardData();
  }, []);

  const loadDashboardData = async () => {
    if (!user?.storeId) return;
    
    try {
      setIsLoading(true);
      
      // Load store information
      const storeData = await StoreService.getStore(user.storeId);
      setStore(storeData);
      
      // Load store statistics
      const statsData = await StoreService.getStoreStats(user.storeId);
      setStats(statsData);
    } catch (error) {
      Alert.alert('Error', 'Failed to load dashboard data');
    } finally {
      setIsLoading(false);
    }
  };

  const handleSignOut = async () => {
    try {
      await signOut();
    } catch (error) {
      Alert.alert('Error', 'Failed to sign out');
    }
  };

  if (isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#4CAF50" />
        <Text style={styles.loadingText}>Loading dashboard...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View>
            <Text style={styles.title}>Store Dashboard</Text>
            <Text style={styles.subtitle}>
              Welcome back, {user?.email}
            </Text>
          </View>
          <IconButton
            icon="logout"
            size={24}
            iconColor="white"
            onPress={handleSignOut}
            style={styles.signOutButton}
          />
        </View>
      </View>

      {store && (
        <Card style={styles.storeCard}>
          <Card.Content>
            <Text style={styles.storeName}>{store.name}</Text>
            <Text style={styles.storeEmail}>{store.contactInfo.email}</Text>
            {store.contactInfo.phone && (
              <Text style={styles.storePhone}>{store.contactInfo.phone}</Text>
            )}
          </Card.Content>
        </Card>
      )}

      <View style={styles.statsContainer}>
        <Card style={styles.statCard}>
          <Card.Content>
            <Text style={styles.statNumber}>{stats.totalProducts}</Text>
            <Text style={styles.statLabel}>Total Products</Text>
          </Card.Content>
        </Card>

        <Card style={styles.statCard}>
          <Card.Content>
            <Text style={styles.statNumber}>{stats.categories.length}</Text>
            <Text style={styles.statLabel}>Categories</Text>
          </Card.Content>
        </Card>
      </View>

      <Card style={styles.actionsCard}>
        <Card.Content>
          <Text style={styles.cardTitle}>Quick Actions</Text>
          
          <Button
            mode="contained"
            onPress={() => navigation.navigate('AddProduct' as never)}
            style={styles.actionButton}
            icon="plus"
          >
            Add New Product
          </Button>
          
          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Products' as never)}
            style={styles.actionButton}
            icon="package-variant"
          >
            Manage Products
          </Button>
          
          <Button
            mode="outlined"
            onPress={() => navigation.navigate('Profile' as never)}
            style={styles.actionButton}
            icon="store"
          >
            Store Profile
          </Button>
        </Card.Content>
      </Card>

      <Card style={styles.recentCard}>
        <Card.Content>
          <Text style={styles.cardTitle}>Recent Activity</Text>
          
          {stats.lastUpdated ? (
            <Text style={styles.activityText}>
              Last updated: {new Date(stats.lastUpdated).toLocaleDateString()}
            </Text>
          ) : (
            <Text style={styles.activityText}>No recent activity</Text>
          )}
        </Card.Content>
      </Card>

      <Card style={styles.categoriesCard}>
        <Card.Content>
          <Text style={styles.cardTitle}>Product Categories</Text>
          
          {stats.categories.length > 0 ? (
            stats.categories.map((category, index) => (
              <Text key={index} style={styles.categoryText}>
                • {category}
              </Text>
            ))
          ) : (
            <Text style={styles.emptyText}>No categories yet</Text>
          )}
        </Card.Content>
      </Card>


    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  header: {
    padding: 20,
    backgroundColor: '#4CAF50',
  },
  headerContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
  },
  signOutButton: {
    margin: 0,
  },
  title: {
    fontSize: 28,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 4,
  },
  subtitle: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#666',
  },
  storeCard: {
    margin: 16,
    elevation: 4,
  },
  storeName: {
    fontSize: 20,
    fontWeight: 'bold',
    marginBottom: 8,
    color: '#333',
  },
  storeEmail: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  storePhone: {
    fontSize: 14,
    color: '#666',
  },
  statsContainer: {
    flexDirection: 'row',
    paddingHorizontal: 16,
    marginBottom: 16,
  },
  statCard: {
    flex: 1,
    marginHorizontal: 4,
    elevation: 4,
  },
  statNumber: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#4CAF50',
    textAlign: 'center',
  },
  statLabel: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
    marginTop: 4,
  },
  actionsCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  recentCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  categoriesCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  actionButton: {
    marginVertical: 8,
  },
  activityText: {
    fontSize: 14,
    color: '#666',
  },
  categoryText: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  emptyText: {
    fontSize: 14,
    color: '#999',
    fontStyle: 'italic',
  },
});

export default DashboardScreen; 