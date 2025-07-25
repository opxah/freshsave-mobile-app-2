import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'scanner_screen.dart';
import 'login_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom Header (10% of screen)
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo on the left
                  Image.asset(
                    'assets/images/freshsave_logo.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.contain,
                  ),
                  
                               // Profile icon on the right
             GestureDetector(
               onTap: () {
                 _showProfileMenu(context);
               },
               child: Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: const Color(0xFF4CAF50).withOpacity(0.1),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: const Icon(
                   Icons.person_outline,
                   size: 24,
                   color: Color(0xFF4CAF50),
                 ),
               ),
             ),
                ],
              ),
            ),
            
            // Main content area
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFF8F9FA), Color(0xFFE9ECEF)],
                  ),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16.0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Location Header
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.location_on,
                                color: Color(0xFF4CAF50),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Current Location',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2C3E50),
                                ),
                              ),
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF4CAF50),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Category Filter Bar
                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            _buildCategoryChip('All', true),
                            _buildCategoryChip('Fruits', false),
                            _buildCategoryChip('Vegetables', false),
                            _buildCategoryChip('Dairy', false),
                            _buildCategoryChip('Bakery', false),
                            _buildCategoryChip('Meat', false),
                            _buildCategoryChip('Beverages', false),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Stores and Products Section
                      _buildStoreSection('Fresh Market', '0.8 km', 4.8, [
                        _buildProductCard(context, 'Organic Bananas', '🍌', 4.99, 2.99, '2 days'),
                        _buildProductCard(context, 'Fresh Tomatoes', '🍅', 3.99, 1.99, '1 day'),
                        _buildProductCard(context, 'Greek Yogurt', '🥛', 5.99, 2.99, '3 days'),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      _buildStoreSection('Local Bakery', '1.2 km', 4.6, [
                        _buildProductCard(context, 'Artisan Bread', '🍞', 6.99, 3.99, 'Today'),
                        _buildProductCard(context, 'Croissants', '🥐', 4.99, 2.49, 'Today'),
                        _buildProductCard(context, 'Sourdough', '🥖', 7.99, 4.99, 'Tomorrow'),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      _buildStoreSection('Dairy Corner', '1.5 km', 4.4, [
                        _buildProductCard(context, 'Fresh Milk', '🥛', 4.99, 2.99, '2 days'),
                        _buildProductCard(context, 'Cheddar Cheese', '🧀', 8.99, 5.99, '1 week'),
                        _buildProductCard(context, 'Butter', '🧈', 6.99, 3.99, '5 days'),
                      ]),
                      
                      const SizedBox(height: 24),
                      
                      _buildStoreSection('Green Grocer', '2.1 km', 4.7, [
                        _buildProductCard(context, 'Avocados', '🥑', 3.99, 1.99, '3 days'),
                        _buildProductCard(context, 'Spinach', '🥬', 4.99, 2.49, '2 days'),
                        _buildProductCard(context, 'Carrots', '🥕', 2.99, 1.49, '1 week'),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
            
            // Bottom Navigation Footer
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                               _buildNavItem(
               icon: Icons.home_outlined,
               label: 'Home',
               isSelected: true,
               onTap: () {
                 // Already on home page - no navigation needed
                 print('Home tapped - already on home page');
               },
             ),
             _buildNavItem(
               icon: Icons.map_outlined,
               label: 'Map',
               isSelected: false,
               onTap: null, // Not clickable for now
             ),
             _buildNavItem(
               icon: Icons.favorite_outline,
               label: 'Favorites',
               isSelected: false,
               onTap: null, // Not clickable for now
             ),
             _buildNavItem(
               icon: Icons.qr_code_scanner_outlined,
               label: 'Scan',
               isSelected: false,
               onTap: () {
                 Navigator.of(context).push(
                   MaterialPageRoute(
                     builder: (context) => const ScannerScreen(),
                   ),
                 );
               },
             ),
             _buildNavItem(
               icon: Icons.shopping_cart_outlined,
               label: 'Cart',
               isSelected: false,
               onTap: null, // Not clickable for now
             ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          // TODO: Handle category selection
          print('Category selected: $label');
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.white : const Color(0xFF2C3E50),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStoreSection(String storeName, String distance, double rating, List<Widget> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Store Header
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.store,
                color: Color(0xFF4CAF50),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    storeName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 16,
                        color: Colors.amber[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        distance,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Products Horizontal Scroll
        SizedBox(
          height: 220, // Increased height to accommodate product cards
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: products,
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(BuildContext context, String name, String emoji, double originalPrice, double discountedPrice, String expiresIn) {
    final discountPercentage = ((originalPrice - discountedPrice) / originalPrice * 100).round();
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth < 400 ? 140.0 : 160.0; // Responsive width for smaller screens
    
    return Container(
      width: cardWidth,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image/Emoji
          Container(
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: Text(
                emoji,
                style: const TextStyle(fontSize: 40),
              ),
            ),
          ),
          // Product Info
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '\$${discountedPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF4CAF50),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '\$${originalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '-$discountPercentage%',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4CAF50),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      expiresIn,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: onTap != null ? 1.0 : 0.5, // Make non-clickable items more transparent
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 24,
                color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: const Color(0xFF4CAF50),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showProfileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Profile options
              ListTile(
                leading: const Icon(
                  Icons.person_outline,
                  color: Color(0xFF4CAF50),
                ),
                title: const Text(
                  'Profile Settings',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Navigate to profile settings
                  print('Profile settings tapped');
                },
              ),
              
              const Divider(height: 1),
              
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _signOut(context);
                },
              ),
              
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _signOut(BuildContext context) {
    // Show confirmation dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                // Navigate to sign in page and clear navigation stack
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login',
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
} 