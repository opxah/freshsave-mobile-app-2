import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView, Alert, Dimensions, TouchableOpacity, Image } from 'react-native';
import { Text, Card, Button, IconButton, Chip } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { useAuth } from '../../contexts/AuthContext';
import { ProductService } from '../../services/product-service';
import { Product } from '../../types';

const { width } = Dimensions.get('window');

// Mock data for stores and products
const mockStores = [
  {
    id: '1',
    name: 'Fresh Market',
    logo: '🛒',
    distance: '0.8 km',
    rating: 4.8,
    products: [
      { id: '1', name: 'Organic Bananas', price: 2.99, originalPrice: 4.99, image: '🍌', expiresIn: '2 days' },
      { id: '2', name: 'Fresh Tomatoes', price: 1.99, originalPrice: 3.99, image: '🍅', expiresIn: '1 day' },
    ]
  },
  {
    id: '2',
    name: 'Local Bakery',
    logo: '🥖',
    distance: '1.2 km',
    rating: 4.6,
    products: [
      { id: '3', name: 'Artisan Bread', price: 3.99, originalPrice: 6.99, image: '🍞', expiresIn: 'Today' },
      { id: '4', name: 'Croissants', price: 2.49, originalPrice: 4.99, image: '🥐', expiresIn: 'Today' },
    ]
  },
  {
    id: '3',
    name: 'Dairy Corner',
    logo: '🥛',
    distance: '1.5 km',
    rating: 4.4,
    products: [
      { id: '5', name: 'Greek Yogurt', price: 2.99, originalPrice: 5.99, image: '🥛', expiresIn: '3 days' },
    ]
  }
];

const categories = [
  { id: 'all', name: 'All', icon: '🍽️' },
  { id: 'fruits', name: 'Fruits', icon: '🍎' },
  { id: 'vegetables', name: 'Vegetables', icon: '🥬' },
  { id: 'dairy', name: 'Dairy', icon: '🥛' },
  { id: 'bakery', name: 'Bakery', icon: '🥖' },
  { id: 'meat', name: 'Meat', icon: '🥩' },
];

const HomeScreen: React.FC = () => {
  const [selectedCategory, setSelectedCategory] = useState('all');
  const [recentProducts, setRecentProducts] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const navigation = useNavigation();
  const { user, signOut } = useAuth();

  useEffect(() => {
    loadRecentProducts();
  }, []);

  const loadRecentProducts = async () => {
    setRecentProducts([]);
  };

  const handleSignOut = async () => {
    Alert.alert(
      'Sign Out',
      'Are you sure you want to sign out?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Sign Out',
          style: 'destructive',
          onPress: async () => {
            try {
              await signOut();
            } catch (error) {
              Alert.alert('Error', 'Failed to sign out');
            }
          },
        },
      ]
    );
  };

  const handleStorePress = (store: any) => {
    navigation.navigate('StoreDetail' as never, { store } as never);
  };

  const handleProductPress = (product: any) => {
    navigation.navigate('ProductDetail' as never, { product } as never);
  };

  const renderCategoryTab = (category: any) => (
    <TouchableOpacity
      key={category.id}
      style={[
        styles.categoryTab,
        selectedCategory === category.id && styles.categoryTabActive
      ]}
      onPress={() => setSelectedCategory(category.id)}
    >
      <Text style={[
        styles.categoryTabText,
        selectedCategory === category.id && styles.categoryTabTextActive
      ]}>
        {category.name}
      </Text>
    </TouchableOpacity>
  );

  const renderStoreCard = (store: any) => (
    <TouchableOpacity
      key={store.id}
      style={styles.storeCard}
      onPress={() => handleStorePress(store)}
    >
      <View style={styles.storeCardHeader}>
        <View style={styles.storeLogo}>
          <Text style={styles.storeLogoText}>{store.logo}</Text>
        </View>
        <View style={styles.storeInfo}>
          <Text style={styles.storeName}>{store.name}</Text>
          <Text style={styles.storeDistance}>{store.distance}</Text>
        </View>
        <View style={styles.storeRating}>
          <Text style={styles.ratingText}>⭐ {store.rating}</Text>
        </View>
      </View>
      
      <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.productsScroll}>
        {store.products.map((product: any) => (
          <TouchableOpacity
            key={product.id}
            style={styles.productCard}
            onPress={() => handleProductPress(product)}
          >
            <View style={styles.productImageContainer}>
              <Text style={styles.productImage}>{product.image}</Text>
              <View style={styles.expiryTag}>
                <Text style={styles.expiryText}>{product.expiresIn}</Text>
              </View>
            </View>
            <View style={styles.productInfo}>
              <Text style={styles.productName} numberOfLines={2}>{product.name}</Text>
              <View style={styles.priceContainer}>
                <Text style={styles.originalPrice}>${product.originalPrice}</Text>
                <Text style={styles.discountedPrice}>${product.price}</Text>
              </View>
            </View>
          </TouchableOpacity>
        ))}
      </ScrollView>
    </TouchableOpacity>
  );

  return (
    <View style={styles.container}>
      {/* Fixed Header */}
      <View style={styles.header}>
        <View style={styles.headerContent}>
          <View style={styles.logoContainer}>
            <Image
              source={require('../../../assets/freshsave_logo.png')}
              style={styles.logo}
              resizeMode="contain"
            />
          </View>
          <View style={styles.userIconContainer}>
            <IconButton
              icon="account-circle"
              size={24}
              iconColor="#4CAF50"
              onPress={handleSignOut}
            />
          </View>
        </View>
      </View>

      <ScrollView style={styles.content} showsVerticalScrollIndicator={false} contentContainerStyle={styles.contentContainer}>
        {/* Category Tabs */}
        <ScrollView 
          horizontal 
          showsHorizontalScrollIndicator={false}
          style={styles.categoryContainer}
          contentContainerStyle={styles.categoryContent}
        >
          {categories.map(renderCategoryTab)}
        </ScrollView>

        {/* Stores Near You Section */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>Stores Near You</Text>
            <TouchableOpacity>
              <Text style={styles.seeAllText}>See all</Text>
            </TouchableOpacity>
          </View>
          
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.storesScroll}>
            {mockStores.map(renderStoreCard)}
          </ScrollView>
        </View>

        {/* Expiring Soon Section */}
        <View style={styles.section}>
          <View style={styles.sectionHeader}>
            <Text style={styles.sectionTitle}>Expiring Soon</Text>
            <TouchableOpacity>
              <Text style={styles.seeAllText}>See all</Text>
            </TouchableOpacity>
          </View>
          
          <ScrollView horizontal showsHorizontalScrollIndicator={false} style={styles.storesScroll}>
            {mockStores.slice(0, 2).map(renderStoreCard)}
          </ScrollView>
        </View>


      </ScrollView>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  header: {
    backgroundColor: 'white',
    paddingTop: 50,
    paddingBottom: 8,
    paddingHorizontal: 16,
    borderBottomWidth: 1,
    borderBottomColor: '#e9ecef',
    position: 'absolute',
    top: 0,
    left: 0,
    right: 0,
    zIndex: 1000,
    elevation: 5,
  },
  headerContent: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    height: 40,
  },
  logoContainer: {
    flex: 1,
    justifyContent: 'center',
  },
  logo: {
    width: 120,
    height: 30,
  },
  userIconContainer: {
    justifyContent: 'center',
    alignItems: 'center',
  },
  content: {
    flex: 1,
    marginTop: 100, // Space for fixed header
  },
  contentContainer: {
    paddingBottom: 20,
  },
  categoryContainer: {
    backgroundColor: 'white',
    paddingVertical: 16,
  },
  categoryContent: {
    paddingHorizontal: 16,
  },
  categoryTab: {
    paddingHorizontal: 20,
    paddingVertical: 8,
    marginRight: 12,
    borderRadius: 20,
    backgroundColor: '#f1f3f4',
  },
  categoryTabActive: {
    backgroundColor: '#4CAF50',
  },
  categoryTabText: {
    fontSize: 14,
    fontWeight: '600',
    color: '#666',
  },
  categoryTabTextActive: {
    color: 'white',
  },
  section: {
    marginTop: 24,
  },
  sectionHeader: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    paddingHorizontal: 16,
    marginBottom: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: '#333',
  },
  seeAllText: {
    fontSize: 14,
    color: '#4CAF50',
    fontWeight: '600',
  },
  storesScroll: {
    paddingLeft: 16,
  },
  storeCard: {
    width: width * 0.85,
    backgroundColor: 'white',
    borderRadius: 16,
    marginRight: 16,
    padding: 16,
    elevation: 3,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.1,
    shadowRadius: 8,
  },
  storeCardHeader: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 16,
  },
  storeLogo: {
    width: 40,
    height: 40,
    borderRadius: 20,
    backgroundColor: '#f0f8f0',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 12,
  },
  storeLogoText: {
    fontSize: 20,
  },
  storeInfo: {
    flex: 1,
  },
  storeName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 2,
  },
  storeDistance: {
    fontSize: 14,
    color: '#666',
  },
  storeRating: {
    alignItems: 'flex-end',
  },
  ratingText: {
    fontSize: 14,
    color: '#666',
  },
  productsScroll: {
    flexDirection: 'row',
  },
  productCard: {
    width: 120,
    marginRight: 12,
    backgroundColor: '#f8f9fa',
    borderRadius: 12,
    overflow: 'hidden',
  },
  productImageContainer: {
    position: 'relative',
    height: 80,
    backgroundColor: 'white',
    justifyContent: 'center',
    alignItems: 'center',
  },
  productImage: {
    fontSize: 32,
  },
  expiryTag: {
    position: 'absolute',
    top: 8,
    left: 8,
    backgroundColor: '#ff9800',
    paddingHorizontal: 6,
    paddingVertical: 2,
    borderRadius: 8,
  },
  expiryText: {
    fontSize: 10,
    color: 'white',
    fontWeight: '600',
  },
  productInfo: {
    padding: 8,
  },
  productName: {
    fontSize: 12,
    fontWeight: '500',
    color: '#333',
    marginBottom: 4,
  },
  priceContainer: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  originalPrice: {
    fontSize: 10,
    color: '#999',
    textDecorationLine: 'line-through',
    marginRight: 4,
  },
  discountedPrice: {
    fontSize: 12,
    fontWeight: '600',
    color: '#4CAF50',
  },

});

export default HomeScreen; 