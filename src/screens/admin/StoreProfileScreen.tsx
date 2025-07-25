import React, { useState, useEffect } from 'react';
import { View, StyleSheet, ScrollView, Alert, Image } from 'react-native';
import { TextInput, Button, Text, Card } from 'react-native-paper';
import { useNavigation } from '@react-navigation/native';
import * as ImagePicker from 'expo-image-picker';
import { useAuth } from '../../contexts/AuthContext';
import { StoreService } from '../../services/store-service';
import { Store } from '../../types';

const StoreProfileScreen: React.FC = () => {
  const [store, setStore] = useState<Store | null>(null);
  const [formData, setFormData] = useState({
    name: '',
    email: '',
    phone: '',
    address: '',
  });
  const [logo, setLogo] = useState<any>(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const navigation = useNavigation();
  const { user } = useAuth();

  useEffect(() => {
    loadStoreProfile();
  }, []);

  const loadStoreProfile = async () => {
    if (!user?.storeId) return;
    
    try {
      setIsLoading(true);
      const storeData = await StoreService.getStore(user.storeId);
      setStore(storeData);
      
      if (storeData) {
        setFormData({
          name: storeData.name,
          email: storeData.contactInfo.email,
          phone: storeData.contactInfo.phone || '',
          address: storeData.contactInfo.address || '',
        });
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to load store profile');
    } finally {
      setIsLoading(false);
    }
  };

  const handleInputChange = (field: string, value: string) => {
    setFormData(prev => ({ ...prev, [field]: value }));
  };

  const handleLogoPick = async () => {
    try {
      const result = await ImagePicker.launchImageLibraryAsync({
        mediaTypes: ImagePicker.MediaTypeOptions.Images,
        allowsEditing: true,
        aspect: [1, 1],
        quality: 0.8,
      });

      if (!result.canceled && result.assets[0]) {
        setLogo(result.assets[0]);
      }
    } catch (error) {
      Alert.alert('Error', 'Failed to pick logo');
    }
  };

  const handleSave = async () => {
    if (!user?.storeId) {
      Alert.alert('Error', 'Store information not found');
      return;
    }

    if (!formData.name || !formData.email) {
      Alert.alert('Error', 'Please fill in store name and email');
      return;
    }

    try {
      setIsSaving(true);
      await StoreService.updateStore(user.storeId, {
        name: formData.name,
        logo,
        contactInfo: {
          email: formData.email,
          phone: formData.phone,
          address: formData.address,
        },
      });
      
      Alert.alert('Success', 'Store profile updated successfully');
      await loadStoreProfile(); // Reload to get updated data
    } catch (error: any) {
      Alert.alert('Error', error.message || 'Failed to update store profile');
    } finally {
      setIsSaving(false);
    }
  };

  if (isLoading) {
    return (
      <View style={styles.loadingContainer}>
        <Text>Loading store profile...</Text>
      </View>
    );
  }

  return (
    <ScrollView style={styles.container}>
      <View style={styles.header}>
        <Text style={styles.title}>Store Profile</Text>
      </View>

      <Card style={styles.logoCard}>
        <Card.Content>
          <Text style={styles.sectionTitle}>Store Logo</Text>
          
          {(logo || store?.logo) ? (
            <View style={styles.logoContainer}>
              <Image 
                source={{ uri: logo?.uri || store?.logo }} 
                style={styles.logoImage} 
              />
              <Button
                mode="outlined"
                onPress={handleLogoPick}
                style={styles.changeLogoButton}
                icon="camera"
              >
                Change Logo
              </Button>
              {logo && (
                <Button
                  mode="outlined"
                  onPress={() => setLogo(null)}
                  style={styles.removeLogoButton}
                >
                  Remove New Logo
                </Button>
              )}
            </View>
          ) : (
            <Button
              mode="outlined"
              onPress={handleLogoPick}
              style={styles.logoButton}
              icon="camera"
            >
              Upload Logo
            </Button>
          )}
        </Card.Content>
      </Card>

      <Card style={styles.formCard}>
        <Card.Content>
          <Text style={styles.sectionTitle}>Store Information</Text>
          
          <TextInput
            label="Store Name *"
            value={formData.name}
            onChangeText={(value) => handleInputChange('name', value)}
            mode="outlined"
            style={styles.input}
          />
          
          <TextInput
            label="Email *"
            value={formData.email}
            onChangeText={(value) => handleInputChange('email', value)}
            mode="outlined"
            style={styles.input}
            keyboardType="email-address"
            autoCapitalize="none"
          />
          
          <TextInput
            label="Phone Number"
            value={formData.phone}
            onChangeText={(value) => handleInputChange('phone', value)}
            mode="outlined"
            style={styles.input}
            keyboardType="phone-pad"
          />
          
          <TextInput
            label="Address"
            value={formData.address}
            onChangeText={(value) => handleInputChange('address', value)}
            mode="outlined"
            style={styles.input}
            multiline
            numberOfLines={3}
          />
        </Card.Content>
      </Card>

      <Card style={styles.infoCard}>
        <Card.Content>
          <Text style={styles.sectionTitle}>Store Details</Text>
          
          <Text style={styles.infoText}>
            <Text style={styles.infoLabel}>Store ID:</Text> {store?.id || 'N/A'}
          </Text>
          
          <Text style={styles.infoText}>
            <Text style={styles.infoLabel}>Admin ID:</Text> {store?.adminId || 'N/A'}
          </Text>
          
          <Text style={styles.infoText}>
            <Text style={styles.infoLabel}>Created:</Text> {store?.createdAt ? new Date(store.createdAt).toLocaleDateString() : 'N/A'}
          </Text>
          
          <Text style={styles.infoText}>
            <Text style={styles.infoLabel}>Last Updated:</Text> {store?.updatedAt ? new Date(store.updatedAt).toLocaleDateString() : 'N/A'}
          </Text>
        </Card.Content>
      </Card>

      <View style={styles.buttonContainer}>
        <Button
          mode="contained"
          onPress={handleSave}
          loading={isSaving}
          disabled={isSaving}
          style={styles.saveButton}
        >
          Save Changes
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
  loadingContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#f5f5f5',
  },
  logoCard: {
    margin: 16,
    elevation: 4,
  },
  formCard: {
    margin: 16,
    marginTop: 0,
    elevation: 4,
  },
  infoCard: {
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
  logoButton: {
    marginVertical: 16,
  },
  logoContainer: {
    alignItems: 'center',
  },
  logoImage: {
    width: 120,
    height: 120,
    borderRadius: 60,
    marginBottom: 16,
  },
  changeLogoButton: {
    marginBottom: 8,
  },
  removeLogoButton: {
    marginBottom: 16,
  },
  infoText: {
    fontSize: 14,
    marginBottom: 8,
    color: '#666',
  },
  infoLabel: {
    fontWeight: 'bold',
    color: '#333',
  },
  buttonContainer: {
    padding: 16,
    paddingTop: 0,
  },
  saveButton: {
    marginBottom: 12,
    backgroundColor: '#4CAF50',
  },
  cancelButton: {
    marginBottom: 12,
  },
});

export default StoreProfileScreen; 