import React, { useState } from 'react';
import { View, StyleSheet, FlatList, Image, Alert } from 'react-native';
import { Text, Card, TextInput, Button, Chip, ActivityIndicator } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { ProductService } from '../../services/product-service';
import { Product } from '../../types';

const SearchScreen: React.FC = () => {
  const [query, setQuery] = useState('');
  const [searchResults, setSearchResults] = useState<Product[]>([]);
  const [isLoading, setIsLoading] = useState(false);
  const [hasSearched, setHasSearched] = useState(false);
  const navigation = useNavigation();

  const handleSearch = async () => {
    if (!query.trim()) {
      Alert.alert('Error', 'Please enter a search term');
      return;
    }

    try {
      setIsLoading(true);
      setHasSearched(true);
      const results = await ProductService.searchProducts(query.trim());
      setSearchResults(results);
    } catch (error) {
      Alert.alert('Error', 'Failed to search products');
    } finally {
      setIsLoading(false);
    }
  };

  const handleCategorySearch = async (category: string) => {
    try {
      setIsLoading(true);
      setHasSearched(true);
      setQuery(category);
      const results = await ProductService.getProductsByCategory(category);
      setSearchResults(results);
    } catch (error) {
      Alert.alert('Error', 'Failed to search by category');
    } finally {
      setIsLoading(false);
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
            <Chip style={styles.categoryChip} textStyle={styles.categoryText}>
              {item.category}
            </Chip>
            {item.price && (
              <Text style={styles.productPrice}>
                ${item.price.toFixed(2)}
                {item.unit && ` per ${item.unit}`}
              </Text>
            )}
          </View>
        </View>
      </Card.Content>
    </Card>
  );

  const popularCategories = [
    'Dairy', 'Beverages', 'Snacks', 'Fruits', 'Vegetables', 
    'Meat', 'Bakery', 'Frozen Foods', 'Canned Goods'
  ];

  return (
    <View style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Search Products</Text>
      </View>

      <View style={styles.searchContainer}>
        <TextInput
          label="Search products..."
          value={query}
          onChangeText={setQuery}
          mode="outlined"
          style={styles.searchInput}
          onSubmitEditing={handleSearch}
          returnKeyType="search"
        />
        <Button
          mode="contained"
          onPress={handleSearch}
          loading={isLoading}
          disabled={isLoading}
          style={styles.searchButton}
        >
          Search
        </Button>
      </View>

      {!hasSearched && (
        <View style={styles.categoriesContainer}>
          <Text style={styles.categoriesTitle}>Popular Categories</Text>
          <View style={styles.categoriesGrid}>
            {popularCategories.map((category) => (
              <Chip
                key={category}
                style={styles.categoryChip}
                textStyle={styles.categoryText}
                onPress={() => handleCategorySearch(category)}
              >
                {category}
              </Chip>
            ))}
          </View>
        </View>
      )}

      {isLoading && (
        <View style={styles.loadingContainer}>
          <ActivityIndicator size="large" color="#4CAF50" />
          <Text style={styles.loadingText}>Searching...</Text>
        </View>
      )}

      {hasSearched && !isLoading && (
        <View style={styles.resultsContainer}>
          <Text style={styles.resultsTitle}>
            {searchResults.length} result{searchResults.length !== 1 ? 's' : ''} found
          </Text>
          
          {searchResults.length > 0 ? (
            <FlatList
              data={searchResults}
              renderItem={renderProduct}
              keyExtractor={(item) => item.barcode}
              showsVerticalScrollIndicator={false}
            />
          ) : (
            <View style={styles.emptyContainer}>
              <Text style={styles.emptyTitle}>No products found</Text>
              <Text style={styles.emptySubtitle}>
                Try searching with different keywords or browse categories
              </Text>
            </View>
          )}
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
  },
  searchContainer: {
    flexDirection: 'row',
    padding: 16,
    backgroundColor: 'white',
    elevation: 2,
  },
  searchInput: {
    flex: 1,
    marginRight: 12,
  },
  searchButton: {
    backgroundColor: '#4CAF50',
  },
  categoriesContainer: {
    padding: 16,
  },
  categoriesTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  categoriesGrid: {
    flexDirection: 'row',
    flexWrap: 'wrap',
    gap: 8,
  },
  categoryChip: {
    marginBottom: 8,
    backgroundColor: '#4CAF50',
  },
  categoryText: {
    color: 'white',
  },
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  loadingText: {
    marginTop: 16,
    fontSize: 16,
    color: '#666',
  },
  resultsContainer: {
    flex: 1,
  },
  resultsTitle: {
    fontSize: 16,
    fontWeight: '500',
    padding: 16,
    backgroundColor: 'white',
    borderBottomWidth: 1,
    borderBottomColor: '#e0e0e0',
  },
  productCard: {
    margin: 8,
    marginHorizontal: 16,
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
    marginBottom: 4,
  },
  productPrice: {
    fontSize: 14,
    fontWeight: 'bold',
    color: '#4CAF50',
    marginTop: 4,
  },
  emptyContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 40,
  },
  emptyTitle: {
    fontSize: 20,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
    textAlign: 'center',
  },
  emptySubtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    lineHeight: 24,
  },
});

export default SearchScreen; 