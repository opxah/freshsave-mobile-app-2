import React, { useState } from 'react';
import {
  View,
  Text,
  StyleSheet,
  Alert,
  Dimensions,
  SafeAreaView,
  Linking,
} from 'react-native';
import { Button, Card, ActivityIndicator, TextInput } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import { ProductService } from '../../services/product-service';
import { Product } from '../../types';

const { width, height } = Dimensions.get('window');

const BarcodeScannerScreen: React.FC = () => {
  // State management
  const [barcodeInput, setBarcodeInput] = useState<string>('');
  const [isLoading, setIsLoading] = useState(false);
  const [product, setProduct] = useState<Product | null>(null);
  const [error, setError] = useState<string>('');
  const [scannedBarcodes, setScannedBarcodes] = useState<string[]>([]);

  const navigation = useNavigation();

  // Fetch product information from barcode
  const fetchProductInfo = async (barcode: string): Promise<Product | null> => {
    try {
      // First try our local ProductService
      const localProduct = await ProductService.getProduct(barcode);
      if (localProduct) {
        return localProduct;
      }

      // If not found locally, try external API (Open Food Facts)
      const response = await fetch(`https://world.openfoodfacts.org/api/v0/product/${barcode}.json`);
      const data = await response.json();

      if (data.status === 1 && data.product) {
        // Convert external API data to our Product format
        return {
          barcode: barcode,
          name: data.product.product_name || 'Unknown Product',
          brand: data.product.brands || 'Unknown Brand',
          category: data.product.categories_tags?.[0] || 'General',
          imageUrl: data.product.image_url,
          price: undefined, // External API doesn't provide price
          unit: data.product.quantity,
          storeId: 'external', // Placeholder
          createdAt: new Date().toISOString(),
          updatedAt: new Date().toISOString(),
          score: data.product.nutriscore_score,
          rating: data.product.nutriscore_grade,
          ingredients: data.product.ingredients_text_en?.split(',') || [],
          allergens: data.product.allergens_tags || [],
          nutritionalInfo: data.product.nutriments ? {
            calories: data.product.nutriments.energy_100g || 0,
            fat: data.product.nutriments.fat_100g || 0,
            saturatedFat: data.product.nutriments['saturated-fat_100g'] || 0,
            carbohydrates: data.product.nutriments.carbohydrates_100g || 0,
            sugar: data.product.nutriments.sugars_100g || 0,
            protein: data.product.nutriments.proteins_100g || 0,
            salt: data.product.nutriments.salt_100g || 0,
          } : undefined,
        };
      }

      return null;
    } catch (error) {
      console.error('Error fetching product info:', error);
      return null;
    }
  };

  // Handle barcode search
  const handleBarcodeSearch = async () => {
    if (!barcodeInput.trim()) {
      Alert.alert('Error', 'Please enter a barcode');
      return;
    }

    setIsLoading(true);
    setError('');
    setProduct(null);

    try {
      const productData = await fetchProductInfo(barcodeInput.trim());
      
      if (productData) {
        setProduct(productData);
        // Add to scanned barcodes history
        setScannedBarcodes(prev => [barcodeInput.trim(), ...prev.slice(0, 4)]);
      } else {
        setError('Product not found in database');
      }
    } catch (err) {
      console.error('Error searching barcode:', err);
      setError('Failed to fetch product information');
    } finally {
      setIsLoading(false);
    }
  };

  // Navigate to product detail
  const handleViewProduct = () => {
    if (product) {
      navigation.navigate('ProductDetail' as any, { product } as any);
    }
  };

  // Open external barcode scanner app
  const openBarcodeScannerApp = () => {
    Alert.alert(
      'External Scanner',
      'Would you like to open an external barcode scanner app?',
      [
        { text: 'Cancel', style: 'cancel' },
        {
          text: 'Open Scanner',
          onPress: () => {
            // Try to open a popular barcode scanner app
            const scannerApps = [
              'barcodescanner://',
              'qrscanner://',
              'https://play.google.com/store/apps/details?id=com.google.zxing.client.android',
            ];
            
            // Try to open the first available app
            Linking.openURL(scannerApps[0]).catch(() => {
              Alert.alert(
                'No Scanner App',
                'Please install a barcode scanner app from your app store and scan the barcode, then enter it manually here.'
              );
            });
          },
        },
      ]
    );
  };

  // Clear current search
  const handleClearSearch = () => {
    setBarcodeInput('');
    setProduct(null);
    setError('');
  };

  // Use barcode from history
  const useBarcodeFromHistory = (barcode: string) => {
    setBarcodeInput(barcode);
    handleBarcodeSearch();
  };

  return (
    <SafeAreaView style={styles.container}>
      <View style={styles.content}>
        {/* Header */}
        <View style={styles.header}>
          <Text style={styles.title}>Barcode Scanner</Text>
          <Text style={styles.subtitle}>
            Enter a product barcode to find product information
          </Text>
        </View>

        {/* Barcode Input Section */}
        <Card style={styles.inputCard}>
          <Card.Content>
            <TextInput
              label="Enter Barcode"
              value={barcodeInput}
              onChangeText={setBarcodeInput}
              mode="outlined"
              style={styles.barcodeInput}
              placeholder="e.g., 3017620422003"
              keyboardType="numeric"
              onSubmitEditing={handleBarcodeSearch}
              returnKeyType="search"
            />
            
            <View style={styles.buttonRow}>
              <Button 
                mode="contained" 
                onPress={handleBarcodeSearch}
                style={styles.searchButton}
                loading={isLoading}
                disabled={isLoading || !barcodeInput.trim()}
              >
                Search Product
              </Button>
              
              <Button 
                mode="outlined" 
                onPress={handleClearSearch}
                style={styles.clearButton}
                disabled={isLoading}
              >
                Clear
              </Button>
            </View>

            {/* External Scanner Option */}
            <Button 
              mode="text" 
              onPress={openBarcodeScannerApp}
              style={styles.externalButton}
              icon="camera"
            >
              Use External Scanner App
            </Button>
          </Card.Content>
        </Card>

        {/* Recent Barcodes */}
        {scannedBarcodes.length > 0 && (
          <Card style={styles.historyCard}>
            <Card.Content>
              <Text style={styles.historyTitle}>Recent Barcodes</Text>
              <View style={styles.historyList}>
                {scannedBarcodes.map((barcode, index) => (
                  <Button
                    key={index}
                    mode="text"
                    onPress={() => useBarcodeFromHistory(barcode)}
                    style={styles.historyItem}
                    textColor="#4CAF50"
                  >
                    {barcode}
                  </Button>
                ))}
              </View>
            </Card.Content>
          </Card>
        )}

        {/* Loading State */}
        {isLoading && (
          <Card style={styles.resultCard}>
            <Card.Content>
              <View style={styles.loadingContainer}>
                <ActivityIndicator size="large" color="#4CAF50" />
                <Text style={styles.loadingText}>Searching for product...</Text>
              </View>
            </Card.Content>
          </Card>
        )}

        {/* Error State */}
        {error && !isLoading && (
          <Card style={styles.resultCard}>
            <Card.Content>
              <View style={styles.errorContainer}>
                <Text style={styles.errorText}>{error}</Text>
                <Text style={styles.barcodeText}>Barcode: {barcodeInput}</Text>
                <Text style={styles.suggestionText}>
                  Try checking the barcode number or use a different product.
                </Text>
              </View>
            </Card.Content>
          </Card>
        )}

        {/* Product Found */}
        {product && !isLoading && (
          <Card style={styles.resultCard}>
            <Card.Content>
              <View style={styles.productContainer}>
                <Text style={styles.productName}>{product.name}</Text>
                <Text style={styles.productBrand}>{product.brand}</Text>
                <Text style={styles.productCategory}>{product.category}</Text>
                <Text style={styles.barcodeText}>Barcode: {product.barcode}</Text>
                
                {product.price && (
                  <Text style={styles.productPrice}>
                    ${product.price.toFixed(2)}
                    {product.unit && ` per ${product.unit}`}
                  </Text>
                )}

                {product.rating && (
                  <Text style={styles.productRating}>
                    Rating: {product.rating.toUpperCase()}
                  </Text>
                )}
                
                <View style={styles.actionButtons}>
                  <Button 
                    mode="contained" 
                    onPress={handleViewProduct}
                    style={styles.viewButton}
                  >
                    View Full Details
                  </Button>
                </View>
              </View>
            </Card.Content>
          </Card>
        )}

        {/* Help Section */}
        <Card style={styles.helpCard}>
          <Card.Content>
            <Text style={styles.helpTitle}>How to use:</Text>
            <Text style={styles.helpText}>
              • Enter the barcode number manually{'\n'}
              • Use an external barcode scanner app{'\n'}
              • Search for products in our database{'\n'}
              • View detailed product information
            </Text>
          </Card.Content>
        </Card>
      </View>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f5f5f5',
  },
  content: {
    flex: 1,
    padding: 16,
  },
  header: {
    alignItems: 'center',
    marginBottom: 20,
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 16,
    color: '#666',
    textAlign: 'center',
    lineHeight: 22,
  },
  inputCard: {
    marginBottom: 16,
    elevation: 2,
  },
  barcodeInput: {
    marginBottom: 16,
  },
  buttonRow: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    marginBottom: 12,
  },
  searchButton: {
    flex: 1,
    marginRight: 8,
    backgroundColor: '#4CAF50',
  },
  clearButton: {
    flex: 0.3,
    borderColor: '#666',
  },
  externalButton: {
    marginTop: 8,
  },
  historyCard: {
    marginBottom: 16,
    elevation: 2,
  },
  historyTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 12,
    color: '#333',
  },
  historyList: {
    flexDirection: 'row',
    flexWrap: 'wrap',
  },
  historyItem: {
    marginRight: 8,
    marginBottom: 8,
  },
  resultCard: {
    marginBottom: 16,
    elevation: 2,
  },
  loadingContainer: {
    alignItems: 'center',
    padding: 20,
  },
  loadingText: {
    marginTop: 10,
    fontSize: 16,
    color: '#666',
  },
  errorContainer: {
    alignItems: 'center',
    padding: 20,
  },
  errorText: {
    fontSize: 16,
    color: '#f44336',
    textAlign: 'center',
    marginBottom: 10,
    fontWeight: '500',
  },
  barcodeText: {
    fontSize: 12,
    color: '#999',
    fontFamily: 'monospace',
    marginBottom: 8,
  },
  suggestionText: {
    fontSize: 14,
    color: '#666',
    textAlign: 'center',
    fontStyle: 'italic',
  },
  productContainer: {
    padding: 8,
  },
  productName: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 5,
    color: '#333',
  },
  productBrand: {
    fontSize: 16,
    color: '#666',
    marginBottom: 5,
  },
  productCategory: {
    fontSize: 14,
    color: '#888',
    marginBottom: 8,
    textTransform: 'capitalize',
  },
  productPrice: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#4CAF50',
    marginBottom: 8,
  },
  productRating: {
    fontSize: 14,
    color: '#FF9800',
    marginBottom: 15,
    fontWeight: '500',
  },
  actionButtons: {
    marginTop: 8,
  },
  viewButton: {
    backgroundColor: '#4CAF50',
  },
  helpCard: {
    marginTop: 'auto',
    elevation: 1,
  },
  helpTitle: {
    fontSize: 16,
    fontWeight: 'bold',
    marginBottom: 8,
    color: '#333',
  },
  helpText: {
    fontSize: 14,
    color: '#666',
    lineHeight: 20,
  },
});

export default BarcodeScannerScreen; 