import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Alert, Dimensions, Image, TouchableOpacity } from 'react-native';
import { Text, IconButton } from 'react-native-paper';
import { Camera, CameraType, BarCodeScanningResult } from 'expo-camera';
import { useNavigation } from '@react-navigation/native';
import { ProductService } from '../../services/product-service';
import MaterialIcons from '@expo/vector-icons/MaterialIcons';

const { width, height } = Dimensions.get('window');

interface ScannedProduct {
  id: string;
  name: string;
  brand: string;
  image: string;
  barcode: string;
  score?: number;
  rating?: string;
}

const BarcodeScannerScreen: React.FC = () => {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [scanned, setScanned] = useState(false);
  const [scannedProduct, setScannedProduct] = useState<ScannedProduct | null>(null);
  const [flashMode, setFlashMode] = useState(false);
  const navigation = useNavigation();

  useEffect(() => {
    (async () => {
      const { status } = await Camera.requestCameraPermissionsAsync();
      setHasPermission(status === 'granted');
    })();
  }, []);

  const handleBarCodeScanned = async ({ type, data }: BarCodeScanningResult) => {
    setScanned(true);
    
    try {
      const product = await ProductService.getProductByBarcode(data);
      
      if (product) {
        const scannedProduct: ScannedProduct = {
          id: product.id || product.barcode,
          name: product.name,
          brand: product.brand,
          image: product.imageUrl || 'https://via.placeholder.com/80x80/4CAF50/FFFFFF?text=📦',
          barcode: product.barcode,
          score: (product as any).score,
          rating: (product as any).rating
        };
        
        setScannedProduct(scannedProduct);
      } else {
        Alert.alert(
          'Product Not Found',
          `No product found with barcode: ${data}`,
          [
            { text: 'OK', onPress: () => setScanned(false) }
          ]
        );
      }
      
    } catch (error) {
      Alert.alert('Error', 'Failed to lookup product');
      setScanned(false);
    }
  };

  const handleScanAgain = () => {
    setScanned(false);
    setScannedProduct(null);
  };

  const handleProductPress = () => {
    if (scannedProduct) {
      navigation.navigate('ProductDetail' as never, { product: scannedProduct } as never);
    }
  };

  const toggleFlash = () => {
    setFlashMode(!flashMode);
  };

  if (hasPermission === null) {
    return (
      <View style={styles.container}>
        <Text style={styles.loadingText}>Requesting camera permission...</Text>
      </View>
    );
  }

  if (hasPermission === false) {
    return (
      <View style={styles.container}>
        <Text style={styles.errorText}>No access to camera</Text>
        <Text style={styles.errorSubtext}>Please enable camera access in settings</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Camera
        style={styles.camera}
        type={CameraType.back}
        onBarCodeScanned={scanned ? undefined : handleBarCodeScanned}
        flashMode={flashMode ? 'torch' : 'off'}
      >
        {/* Top Controls */}
        <View style={styles.topControls}>
          <IconButton
            icon={flashMode ? "flashlight" : "flashlight-off"}
            iconColor="white"
            size={24}
            onPress={toggleFlash}
            style={styles.controlButton}
          />
          <IconButton
            icon="volume-up"
            iconColor="white"
            size={24}
            style={styles.controlButton}
          />
        </View>

        {/* Scan Overlay */}
        <View style={styles.overlay}>
          <View style={styles.scanFrame}>
            <View style={styles.corner} />
            <View style={[styles.corner, styles.topRight]} />
            <View style={[styles.corner, styles.bottomLeft]} />
            <View style={[styles.corner, styles.bottomRight]} />
          </View>
          <Text style={styles.instructionText}>
            Position the barcode within the frame
          </Text>
        </View>

        {/* Bottom Product Display (Yuka Style) */}
        {scannedProduct && (
          <View style={styles.productDisplay}>
            <TouchableOpacity style={styles.productCard} onPress={handleProductPress}>
              <Image source={{ uri: scannedProduct.image }} style={styles.productImage} />
              <View style={styles.productInfo}>
                <Text style={styles.productName}>{scannedProduct.name}</Text>
                <Text style={styles.productBrand}>{scannedProduct.brand}</Text>
                {scannedProduct.score && (
                  <View style={styles.scoreContainer}>
                    <Text style={styles.score}>{scannedProduct.score}/100</Text>
                    <View style={[styles.scoreDot, { backgroundColor: getScoreColor(scannedProduct.score) }]} />
                  </View>
                )}
                {scannedProduct.rating && (
                  <Text style={styles.rating}>{scannedProduct.rating}</Text>
                )}
              </View>
            </TouchableOpacity>
            
            <TouchableOpacity style={styles.scanAgainButton} onPress={handleScanAgain}>
              <MaterialIcons name="qr-code-scanner" size={24} color="#4CAF50" />
              <Text style={styles.scanAgainText}>Scan Again</Text>
            </TouchableOpacity>
          </View>
        )}
      </Camera>
    </View>
  );
};

const getScoreColor = (score: number): string => {
  if (score >= 75) return '#4CAF50'; // Green
  if (score >= 50) return '#FF9800'; // Orange
  return '#F44336'; // Red
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black',
  },
  camera: {
    flex: 1,
  },
  topControls: {
    position: 'absolute',
    top: 50,
    left: 0,
    right: 0,
    flexDirection: 'row',
    justifyContent: 'space-between',
    paddingHorizontal: 20,
    zIndex: 10,
  },
  controlButton: {
    backgroundColor: 'rgba(0, 0, 0, 0.3)',
    borderRadius: 25,
  },
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanFrame: {
    width: width * 0.7,
    height: width * 0.7,
    position: 'relative',
  },
  corner: {
    position: 'absolute',
    width: 40,
    height: 40,
    borderColor: '#4CAF50',
    borderTopWidth: 4,
    borderLeftWidth: 4,
    top: 0,
    left: 0,
  },
  topRight: {
    borderTopWidth: 4,
    borderRightWidth: 4,
    borderLeftWidth: 0,
    right: 0,
    left: 'auto',
  },
  bottomLeft: {
    borderBottomWidth: 4,
    borderLeftWidth: 4,
    borderTopWidth: 0,
    bottom: 0,
    top: 'auto',
  },
  bottomRight: {
    borderBottomWidth: 4,
    borderRightWidth: 4,
    borderTopWidth: 0,
    borderLeftWidth: 0,
    bottom: 0,
    right: 0,
    top: 'auto',
    left: 'auto',
  },
  instructionText: {
    color: 'white',
    fontSize: 16,
    textAlign: 'center',
    marginTop: 30,
    paddingHorizontal: 40,
    fontWeight: '500',
  },
  productDisplay: {
    position: 'absolute',
    bottom: 100,
    left: 20,
    right: 20,
    backgroundColor: 'white',
    borderRadius: 12,
    padding: 16,
    shadowColor: '#000',
    shadowOffset: { width: 0, height: 2 },
    shadowOpacity: 0.25,
    shadowRadius: 8,
    elevation: 8,
  },
  productCard: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 12,
  },
  productImage: {
    width: 60,
    height: 60,
    borderRadius: 8,
    marginRight: 12,
  },
  productInfo: {
    flex: 1,
  },
  productName: {
    fontSize: 18,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 2,
  },
  productBrand: {
    fontSize: 14,
    color: '#666',
    marginBottom: 4,
  },
  scoreContainer: {
    flexDirection: 'row',
    alignItems: 'center',
    marginBottom: 2,
  },
  score: {
    fontSize: 16,
    fontWeight: 'bold',
    color: '#333',
    marginRight: 8,
  },
  scoreDot: {
    width: 8,
    height: 8,
    borderRadius: 4,
  },
  rating: {
    fontSize: 12,
    color: '#666',
  },
  scanAgainButton: {
    flexDirection: 'row',
    alignItems: 'center',
    justifyContent: 'center',
    paddingVertical: 8,
    borderTopWidth: 1,
    borderTopColor: '#e0e0e0',
  },
  scanAgainText: {
    marginLeft: 8,
    fontSize: 14,
    color: '#4CAF50',
    fontWeight: '500',
  },
  loadingText: {
    color: 'white',
    fontSize: 16,
    textAlign: 'center',
    marginTop: 50,
  },
  errorText: {
    color: 'white',
    fontSize: 18,
    textAlign: 'center',
    marginTop: 50,
    fontWeight: 'bold',
  },
  errorSubtext: {
    color: 'white',
    fontSize: 14,
    textAlign: 'center',
    marginTop: 10,
    opacity: 0.8,
  },
});

export default BarcodeScannerScreen; 