import React from 'react';
import { View, StyleSheet, ScrollView, Dimensions } from 'react-native';
import { Text, Card, Button, IconButton } from 'react-native-paper';
import { useNavigation, useRoute } from '@react-navigation/native';

const { width } = Dimensions.get('window');

const StoreDetailScreen: React.FC = () => {
  const navigation = useNavigation();
  const route = useRoute();
  const { store } = route.params as any;

  return (
    <ScrollView style={styles.container}>
      {/* Header */}
      <View style={styles.header}>
        <IconButton
          icon="arrow-left"
          size={24}
          iconColor="white"
          onPress={() => navigation.goBack()}
        />
        <View style={styles.headerContent}>
          <View style={styles.storeLogo}>
            <Text style={styles.storeLogoText}>{store?.logo || '🛒'}</Text>
          </View>
          <View style={styles.storeInfo}>
            <Text style={styles.storeName}>{store?.name || 'Store'}</Text>
            <Text style={styles.storeDistance}>{store?.distance || '0.0 km'}</Text>
          </View>
        </View>
      </View>

      {/* Store Products */}
      <View style={styles.content}>
        <Text style={styles.sectionTitle}>Available Products</Text>
        
        {store?.products?.map((product: any) => (
          <Card key={product.id} style={styles.productCard}>
            <Card.Content>
              <View style={styles.productRow}>
                <View style={styles.productImage}>
                  <Text style={styles.productEmoji}>{product.image}</Text>
                </View>
                <View style={styles.productDetails}>
                  <Text style={styles.productName}>{product.name}</Text>
                  <Text style={styles.expiryText}>Expires: {product.expiresIn}</Text>
                  <View style={styles.priceRow}>
                    <Text style={styles.originalPrice}>${product.originalPrice}</Text>
                    <Text style={styles.discountedPrice}>${product.price}</Text>
                  </View>
                </View>
                <Button
                  mode="contained"
                  onPress={() => navigation.navigate('ProductDetail' as never, { product } as never)}
                  style={styles.viewButton}
                >
                  View
                </Button>
              </View>
            </Card.Content>
          </Card>
        ))}
      </View>
    </ScrollView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
  },
  header: {
    backgroundColor: '#4CAF50',
    paddingTop: 50,
    paddingBottom: 20,
    paddingHorizontal: 16,
  },
  headerContent: {
    flexDirection: 'row',
    alignItems: 'center',
    marginTop: 16,
  },
  storeLogo: {
    width: 60,
    height: 60,
    borderRadius: 30,
    backgroundColor: 'rgba(255, 255, 255, 0.2)',
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  storeLogoText: {
    fontSize: 28,
  },
  storeInfo: {
    flex: 1,
  },
  storeName: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
    marginBottom: 4,
  },
  storeDistance: {
    fontSize: 16,
    color: 'rgba(255, 255, 255, 0.8)',
  },
  content: {
    padding: 16,
  },
  sectionTitle: {
    fontSize: 20,
    fontWeight: '700',
    color: '#333',
    marginBottom: 16,
  },
  productCard: {
    marginBottom: 16,
    elevation: 2,
  },
  productRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  productImage: {
    width: 60,
    height: 60,
    backgroundColor: '#f0f8f0',
    borderRadius: 8,
    justifyContent: 'center',
    alignItems: 'center',
    marginRight: 16,
  },
  productEmoji: {
    fontSize: 24,
  },
  productDetails: {
    flex: 1,
  },
  productName: {
    fontSize: 16,
    fontWeight: '600',
    color: '#333',
    marginBottom: 4,
  },
  expiryText: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  priceRow: {
    flexDirection: 'row',
    alignItems: 'center',
  },
  originalPrice: {
    fontSize: 14,
    color: '#999',
    textDecorationLine: 'line-through',
    marginRight: 8,
  },
  discountedPrice: {
    fontSize: 16,
    fontWeight: '600',
    color: '#4CAF50',
  },
  viewButton: {
    backgroundColor: '#4CAF50',
  },
});

export default StoreDetailScreen; 