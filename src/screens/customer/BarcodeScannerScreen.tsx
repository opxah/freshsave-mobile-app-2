import React, { useState, useEffect } from 'react';
import { View, StyleSheet, Alert } from 'react-native';
import { Text, Button } from 'react-native-paper';
import { Camera, CameraType, BarCodeScanningResult } from 'expo-camera';
import { useNavigation } from '@react-navigation/native';
import { ProductService } from '../../services/product-service';

const BarcodeScannerScreen: React.FC = () => {
  const [hasPermission, setHasPermission] = useState<boolean | null>(null);
  const [scanned, setScanned] = useState(false);
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
        navigation.navigate('ProductDetail' as never, { product } as never);
      } else {
        Alert.alert(
          'Product Not Found',
          `No product found with barcode: ${data}`,
          [
            { text: 'OK', onPress: () => setScanned(false) },
            { text: 'Enter Manually', onPress: () => navigation.goBack() }
          ]
        );
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to lookup product');
      setScanned(false);
    }
  };

  const handleManualEntry = () => {
    navigation.goBack();
  };

  if (hasPermission === null) {
    return (
      <View style={styles.container}>
        <Text>Requesting camera permission...</Text>
      </View>
    );
  }

  if (hasPermission === false) {
    return (
      <View style={styles.container}>
        <Text style={styles.errorText}>No access to camera</Text>
        <Button mode="contained" onPress={handleManualEntry} style={styles.button}>
          Enter Barcode Manually
        </Button>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <Camera
        style={styles.camera}
        type={CameraType.back}
        onBarCodeScanned={scanned ? undefined : handleBarCodeScanned}
      >
        <View style={styles.overlay}>
          <View style={styles.scanArea}>
            <View style={styles.corner} />
            <View style={[styles.corner, styles.topRight]} />
            <View style={[styles.corner, styles.bottomLeft]} />
            <View style={[styles.corner, styles.bottomRight]} />
          </View>
          <Text style={styles.instructionText}>
            Position the barcode within the frame
          </Text>
        </View>
      </Camera>
      
      <View style={styles.buttonContainer}>
        {scanned && (
          <Button
            mode="contained"
            onPress={() => setScanned(false)}
            style={styles.button}
          >
            Scan Again
          </Button>
        )}
        <Button
          mode="outlined"
          onPress={handleManualEntry}
          style={styles.button}
        >
          Enter Manually
        </Button>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: 'black',
  },
  camera: {
    flex: 1,
  },
  overlay: {
    flex: 1,
    backgroundColor: 'rgba(0, 0, 0, 0.5)',
    justifyContent: 'center',
    alignItems: 'center',
  },
  scanArea: {
    width: 250,
    height: 250,
    position: 'relative',
  },
  corner: {
    position: 'absolute',
    width: 30,
    height: 30,
    borderColor: '#4CAF50',
    borderTopWidth: 3,
    borderLeftWidth: 3,
    top: 0,
    left: 0,
  },
  topRight: {
    borderTopWidth: 3,
    borderRightWidth: 3,
    borderLeftWidth: 0,
    right: 0,
    left: 'auto',
  },
  bottomLeft: {
    borderBottomWidth: 3,
    borderLeftWidth: 3,
    borderTopWidth: 0,
    bottom: 0,
    top: 'auto',
  },
  bottomRight: {
    borderBottomWidth: 3,
    borderRightWidth: 3,
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
    marginTop: 20,
    paddingHorizontal: 20,
  },
  buttonContainer: {
    padding: 20,
    backgroundColor: 'white',
  },
  button: {
    marginVertical: 8,
  },
  errorText: {
    fontSize: 18,
    textAlign: 'center',
    marginBottom: 20,
    color: 'white',
  },
});

export default BarcodeScannerScreen; 