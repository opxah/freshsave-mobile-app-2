import React from 'react';
import { View, StyleSheet, Text } from 'react-native';
import { Text as PaperText } from 'react-native-paper';

const CartScreen: React.FC = () => {
  return (
    <View style={styles.container}>
      <View style={styles.content}>
        <PaperText style={styles.title}>Cart</PaperText>
        <PaperText style={styles.subtitle}>Your shopping cart</PaperText>
        <PaperText style={styles.description}>
          This screen will show your selected products and allow you to checkout.
        </PaperText>
      </View>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#f8f9fa',
    paddingTop: 100, // Space for fixed header
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: 20,
  },
  title: {
    fontSize: 32,
    fontWeight: 'bold',
    color: '#333',
    marginBottom: 8,
  },
  subtitle: {
    fontSize: 18,
    color: '#666',
    marginBottom: 16,
  },
  description: {
    fontSize: 16,
    color: '#888',
    textAlign: 'center',
    lineHeight: 24,
  },
});

export default CartScreen; 