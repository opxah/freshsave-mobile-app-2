import React, { useState, useEffect } from 'react';
import { View, StyleSheet, FlatList, Image, Alert } from 'react-native';
import { Text, Card, Button, IconButton, ActivityIndicator } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../../contexts/AuthContext';
import { FavoritesService } from '../../services/favorites-service';
import { Product } from '../../types';

const FavoritesScreen: React.FC = () => {
  const [favorites, setFavorites] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const navigation = useNavigation();
  const { user } = useAuth();

  useEffect(() => {
    loadFavorites();
  }, []);

  const loadFavorites = async () => {
    if (!user) return;
    
    try {
      setIsLoading(true);
      const userFavorites = await FavoritesService.getFavorites(user.id);
      setFavorites(userFavorites);
    } catch (error) {
      Alert.alert('Error', 'Failed to load favorites');
    } finally {
      setIsLoading(false);
    }
  };

  const handleRemoveFavorite = async (productBarcode: string) => {
    if (!user) return;
    
    try {
      await FavoritesService.removeFromFavorites(user.id, productBarcode);
      setFavorites(favorites.filter(p => p.barcode !== productBarcode));
      Alert.alert('Success', 'Removed from favorites');
    } catch (error) {
      Alert.alert('Error', 'Failed to remove from favorites');
    }
  };

  const handleProductPress = (product: Product) => {
    navigation.navigate('ProductDetail' as never, { product } as never);
  };

  const renderProduct = ({ item }: { item: Product }) => (
    <Card style={styles.productCard} onPress={() => handleProductPress(item)}>
      <Card.Content>
        <View style={styles.productRow}>
          {item.imageUrl ? (
            <Image source={{ uri: item.imageUrl }} style={styles.productImage} />
          ) : (
            <View style={styles.placeholderImage}>
              <Text style={styles.placeholderText}>No Image</Text>
            </View>
          )}
          
          <View style={styles.productInfo}>
            <Text style={styles.productName}>{item.name}</Text>
            <Text style={styles.productBrand}>{item.brand}</Text>
            <Text style={styles.productCategory}>{item.category}</Text>
            {item.price && (
              <Text style={styles.productPrice}>
                ${item.price.toFixed(2)}
                {item.unit && ` per ${item.unit}`}
              </Text>
            )}
          </View>
          
          <IconButton
            icon="heart"
            size={20}
            iconColor="#e91e63"
            onPress={() => handleRemoveFavorite(item.barcode)}
          />
        </View>
      </Card.Content>
    </Card>
  );

  if (isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <ActivityIndicator size="large" color="#4CAF50" />
        <Text style={styles.loadingText}>Loading favorites...</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>My Favorites</Text>
        <Text style={styles.subtitle}>
          {favorites.length} saved product{favorites.length !== 1 ? 's' : ''}
        </Text>
      </View>

      {favorites.length > 0 ? (
        <FlatList
          data={favorites}
          renderItem={renderProduct}
          keyExtractor={(item) => item.barcode}
          contentContainerStyle={styles.listContainer}
          showsVerticalScrollIndicator={false}
        />
      ) : (
        <View style={styles.emptyContainer}>
          <Text style={styles.emptyTitle}>No favorites yet</Text>
          <Text style={styles.emptySubtitle}>
            Start scanning products and save them to your favorites
          </Text>
          <Button
            mode="contained"
            onPress={() => navigation.navigate('Home' as never)}
            style={styles.emptyButton}
          >
            Start Scanning
          </Button>
        </View>
      )}
    </View>
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
  title: {
    fontSize: 24,
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
  listContainer: {
    padding: 16,
  },
  productCard: {
    marginBottom: 12,
    elevation: 2,
  },
  productRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  productImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    marginRight: 12,
  },
  placeholderImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    backgroundColor: '#e0e0e0',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  placeholderText: {
    fontSize: 12,
    color: '#666',
  },
  productInfo: {
    flex: 1,
  },
  productName: {
    fontSize: 16,
    fontWeight: '500',
    marginBottom: 4,
  },
  productBrand: {
    fontSize: 14,
    color: '#666',
    marginBottom: 2,
  },
  productCategory: {
    fontSize: 12,
    color: '#999',
    marginBottom: 4,
  },
  productPrice: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#4CAF50',
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  emptyTitle: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 12,
    textAlign: 'center',
  },
  emptySubtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    marginBottom: 24,
    lineHeight: 24,
  },
  emptyButton: {
    backgroundColor: '#4CAF50',
  },
});

export default FavoritesScreen; 