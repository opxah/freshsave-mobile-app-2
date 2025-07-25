import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v0/product';

  // Get product information by barcode
  static Future<Map<String, dynamic>?> getProductByBarcode(String barcode) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$barcode.json'),
        headers: {
          'User-Agent': 'FreshSave/1.0',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data['status'] == 1) {
          return data['product'];
        } else {
          return null; // Product not found
        }
      } else {
        throw Exception('Failed to load product: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching product: $e');
      return null;
    }
  }

  // Extract product name from API response
  static String getProductName(Map<String, dynamic> product) {
    return product['product_name'] ?? 
           product['product_name_en'] ?? 
           product['generic_name'] ?? 
           'Unknown Product';
  }

  // Extract product brand from API response
  static String getProductBrand(Map<String, dynamic> product) {
    return product['brands'] ?? 'Unknown Brand';
  }

  // Extract product image URL from API response
  static String? getProductImage(Map<String, dynamic> product) {
    return product['image_front_url'] ?? 
           product['image_url'] ?? 
           product['image_small_url'];
  }

  // Extract product ingredients from API response
  static String getProductIngredients(Map<String, dynamic> product) {
    return product['ingredients_text'] ?? 
           product['ingredients_text_en'] ?? 
           'Ingredients not available';
  }
} 