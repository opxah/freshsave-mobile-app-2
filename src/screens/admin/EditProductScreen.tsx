import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView, Alert, Image } from 'react-native';
import { TextInput, Button, Text, Card, SegmentedButtons } from 'react-native-paper';
import { useNavigation, useRoute } from '@react-navigation/native';
import * as ImagePicker from 'expo-image-picker';
import { ProductService } from '../../services/product-service';
import { Product, ProductFormData } from '../../types';

interface RouteParams {
  product: Product;
}

const EditProductScreen: React.FC = () => {
  const [formData, setFormData] = useState<ProductFormData>({
    barcode: '',
    name: '',
    brand: '',
    category: '',
    price: '',
    unit: '',
  });
  const [image, setImage] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(false);
  const navigation = useNavigation();
  const route = useRoute();
  const { product } = route.params as RouteParams;

  useEffect(() => {
    // Initialize form with existing product data
    setFormData({
      barcode: product.barcode,
      name: product.name,
      brand: product.brand,
      category: product.category,
      price: product.price?.toString() || '',
      unit: product.unit || '',
    });
  }, [product]);

  const handleInputChange = (field: keyof ProductFormData, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleImagePick = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        allowsEditing: true,
        aspect: [1, 1],
        quality: 0.8,
      });

      if (!result.canceled && result.assets[0]) {
        setImage(result.assets[0]);
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to pick image');
    }
  };

  const handleSubmit = async () => {
    if (!formData.barcode || !formData.name || !formData.brand || !formData.category) {
      Alert.alert('Error', 'Please fill in all required fields');
      return;
    }

    try {
      setIsLoading(true);
      await ProductService.updateProduct(product.barcode, {
        ...formData,
        image,
        imageUrl: product.imageUrl, // Keep existing image if no new one selected
      });
      Alert.alert('Success', 'Product updated successfully', [
        { text: 'OK', onPress: () => navigation.goBack() }
      ]);
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to update product');
    } finally {
      setIsLoading(false);
    }
  };

  const categories = [
    'Dairy', 'Beverages', 'Snacks', 'Fruits', 'Vegetables',
    'Meat', 'Bakery', 'Frozen Foods', 'Canned Goods', 'Other'
  ];

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Edit Product</Text>
      </View>

      <Card style={styles.formCard}>
        <Card.Content>
          <Text style={styles.sectionTitle}>Product Information</Text>
          
          <TextInput
            label="Barcode *"
            value={formData.barcode}
            onChangeText={(value) => handleInputChange('barcode', value)}
            mode="outlined"
            style={styles.input}
            keyboardType="numeric"
            disabled // Barcode should not be editable
          />
          
          <TextInput
            label="Product Name *"
            value={formData.name}
            onChangeText={(value) => handleInputChange('name', value)}
            mode="outlined"
            style={styles.input}
          />
          
          <TextInput
            label="Brand *"
            value={formData.brand}
            onChangeText={(value) => handleInputChange('brand', value)}
            mode="outlined"
            style={styles.input}
          />
          
          <Text style={styles.label}>Category *</Text>
          <SegmentedButtons
            value={formData.category}
            onValueChange={(value) => handleInputChange('category', value)}
            buttons={categories.map(cat => ({ value: cat, label: cat }))}
            multiSelect={false}
            style={styles.segmentedButton}
          />
          
          <View style={styles.priceRow}>
            <TextInput
              label="Price"
              value={formData.price}
              onChangeText={(value) => handleInputChange('price', value)}
              mode="outlined"
              style={[styles.input, styles.priceInput]}
              keyboardType="decimal-pad"
            />
            
            <TextInput
              label="Unit"
              value={formData.unit}
              onChangeText={(value) => handleInputChange('unit', value)}
              mode="outlined"
              style={[styles.input, styles.unitInput]}
            />
          </View>
        </Card.Content>
      </Card>

      <Card style={styles.imageCard}>
        <Card.Content>
          <Text style={styles.sectionTitle}>Product Image</Text>
          
          {(image || product.imageUrl) ? (
            <View style={styles.imageContainer}>
              <Image 
                source={{ uri: image?.uri || product.imageUrl }} 
                style={styles.selectedImage} 
              />
              <Button
                mode="outlined"
                onPress={handleImagePick}
                style={styles.changeImageButton}
                icon="camera"
              >
                Change Image
              </Button>
              {image && (
                <Button
                  mode="outlined"
                  onPress={() => setImage(null)}
                  style={styles.removeImageButton}
                >
                  Remove New Image
                </Button>
              )}
            </View>
          ) : (
            <Button
              mode="outlined"
              onPress={handleImagePick}
              style={styles.imageButton}
              icon="camera"
            >
              Select Image
            </Button>
          )}
        </Card.Content>
      </Card>

      <View style={styles.buttonContainer}>
        <Button
          mode="contained"
          onPress={handleSubmit}
          loading={isLoading}
          disabled={isLoading}
          style={styles.submitButton}
        >
          Update Product
        </Button>
        
        <Button
          mode="outlined"
          onPress={() => navigation.goBack()}
          style={styles.cancelButton}
        >
          Cancel
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
  header: {
    padding: 20,
    backgroundColor: '#4CAF50',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: 'white',
  },
  formCard: {
    margin: 16,
    elevation: 4,
  },
  imageCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  sectionTitle: {
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 16,
    color: '#333',
  },
  input: {
    marginBottom: 16,
  },
  label: {
    fontSize: 16,
    fontWeight: '500',
    marginBottom: 8,
    color: '#333',
  },
  segmentedButton: {
    marginBottom: 16,
  },
  priceRow: {
    flexDirection: 'row',
    gap: 12,
  },
  priceInput: {
    flex: 2,
  },
  unitInput: {
    flex: 1,
  },
  imageButton: {
    marginVertical: 16,
  },
  imageContainer: {
    alignItems: 'center',
  },
  selectedImage: {
    width: 200,
    height: 200,
    borderRadius: 8,
    marginBottom: 16,
  },
  changeImageButton: {
    marginBottom: 8,
  },
  removeImageButton: {
    marginBottom: 16,
  },
  buttonContainer: {
    padding: 16,
    paddingTop: 0,
  },
  submitButton: {
    marginBottom: 12,
    backgroundColor: '#4CAF50',
  },
  cancelButton: {
    marginBottom: 12,
  },
});

export default EditProductScreen; 