import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView, Image, Alert } from 'react-native';
import { Text, Card, Button, Chip, IconButton } from 'react-native-paper';
import { useRoute, useNavigation } from '@react-navigation/native';
import { useAuth } from '../../contexts/AuthContext';
import { FavoritesService } from '../../services/favorites-service';
import { Product } from '../../types';

interface RouteParams {
  product: Product;
}

const ProductDetailScreen: React.FC = () => {
  const [isFavorite, setIsFavorite] = useState(false);
  const [isLoading, setIsLoading] = useState(false);
  const route = useRoute();
  const navigation = useNavigation();
  const { user } = useAuth();
  const { product } = route.params as RouteParams;

  useEffect(() => {
    checkFavoriteStatus();
  }, []);

  const checkFavoriteStatus = async () => {
    if (!user) return;
    
    try {
      const favorite = await FavoritesService.isFavorite(user.id, product.barcode);
      setIsFavorite(favorite);
    } catch (error) {
      console.error('Error checking favorite status:', error);
    }
  };

  const handleToggleFavorite = async () => {
    if (!user) {
      Alert.alert('Error', 'Please sign in to save favorites');
      return;
    }

    try {
      setIsLoading(true);
      
      if (isFavorite) {
        await FavoritesService.removeFromFavorites(user.id, product.barcode);
        setIsFavorite(false);
        Alert.alert('Success', 'Removed from favorites');
      } else {
        await FavoritesService.addToFavorites(user.id, product.barcode);
        setIsFavorite(true);
        Alert.alert('Success', 'Added to favorites');
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to update favorites');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <ScrollView style={styles.container}>
      <Card style={styles.imageCard}>
        {product.imageUrl ? (
          <Image source={{ uri: product.imageUrl }} style={styles.productImage} />
        ) : (
          <View style={styles.placeholderImage}>
            <Text style={styles.placeholderText}>No Image</Text>
          </View>
        )}
      </Card>

      <Card style={styles.infoCard}>
        <Card.Content>
          <View style={styles.headerRow}>
            <Text style={styles.productName}>{product.name}</Text>
            <IconButton
              icon={isFavorite ? 'heart' : 'heart-outline'}
              size={24}
              onPress={handleToggleFavorite}
              disabled={isLoading}
              iconColor={isFavorite ? '#e91e63' : '#666'}
            />
          </View>
          
          <Text style={styles.brand}>{product.brand}</Text>
          <Chip style={styles.categoryChip} textStyle={styles.categoryText}>
            {product.category}
          </Chip>
          
          <Text style={styles.barcode}>Barcode: {product.barcode}</Text>
          
          {product.price && (
            <Text style={styles.price}>
              ${product.price.toFixed(2)}
              {product.unit && ` per ${product.unit}`}
            </Text>
          )}
        </Card.Content>
      </Card>

      <Card style={styles.storeCard}>
        <Card.Content>
          <Text style={styles.cardTitle}>Store Information</Text>
          <Text style={styles.storeInfo}>Store ID: {product.storeId}</Text>
          <Text style={styles.storeInfo}>Added: {new Date(product.createdAt).toLocaleDateString()}</Text>
        </Card.Content>
      </Card>

      <View style={styles.buttonContainer}>
        <Button
          mode="contained"
          onPress={() => navigation.goBack()}
          style={styles.button}
        >
          Back to Search
        </Button>
        
        <Button
          mode="outlined"
          onPress={() => navigation.navigate('Favorites' as never)}
          style={styles.button}
        >
          View Favorites
        </Button>
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  imageCard: {
    margin: 16,
    elevation: 4,
  },
  productImage: {
    width: '100%',
    height: 300,
    resizeMode: 'contain',
  },
  placeholderImage: {
    width: '100%',
    height: 300,
    backgroundColor: '#e0e0e0',
    justifyContent: 'center',
    alignItems: 'center',
  },
  placeholderText: {
    fontSize: 18,
    color: '#666',
  },
  infoCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  headerRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'flex-start',
    marginBottom: 8,
  },
  productName: {
    fontSize: 24,
    fontWeight: 'bold',
    flex: 1,
    marginRight: 8,
  },
  brand: {
    fontSize: 18,
    color: '#666',
    marginBottom: 12,
  },
  categoryChip: {
    alignSelf: 'flex-start',
    marginBottom: 12,
    backgroundColor: '#4CAF50',
  },
  categoryText: {
    color: 'white',
  },
  barcode: {
    fontSize: 14,
    color: '#999',
    marginBottom: 8,
  },
  price: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#4CAF50',
  },
  storeCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  cardTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 12,
    color: '#333',
  },
  storeInfo: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  buttonContainer: {
    padding: 16,
    paddingTop: 0,
  },
  button: {
    marginVertical: 8,
  },
});

export default ProductDetailScreen; 