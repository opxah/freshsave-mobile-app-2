import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C3E50),
        elevation: 0,
        title: const Text(
          'Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              AuthService.logout();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings_rounded,
                          size: 32,
                          color: Color(0xFF4CAF50),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Welcome, Admin!',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2C3E50),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Logged in as: ${AuthService.currentUser}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Admin Functions Grid
            const Text(
              'Admin Functions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildAdminCard(
                    context,
                    'Product Management',
                    Icons.inventory_2_rounded,
                    const Color(0xFF4CAF50),
                    () {
                      // TODO: Navigate to Product Management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Management - Coming Soon!'),
                          backgroundColor: Color(0xFF4CAF50),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Store Management',
                    Icons.store_rounded,
                    const Color(0xFF2196F3),
                    () {
                      // TODO: Navigate to Store Management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Store Management - Coming Soon!'),
                          backgroundColor: Color(0xFF2196F3),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'User Management',
                    Icons.people_rounded,
                    const Color(0xFF9C27B0),
                    () {
                      // TODO: Navigate to User Management
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('User Management - Coming Soon!'),
                          backgroundColor: Color(0xFF9C27B0),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Analytics & Reports',
                    Icons.analytics_rounded,
                    const Color(0xFFFF9800),
                    () {
                      // TODO: Navigate to Analytics
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Analytics & Reports - Coming Soon!'),
                          backgroundColor: Color(0xFFFF9800),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Product Reports',
                    Icons.report_problem_rounded,
                    const Color(0xFFF44336),
                    () {
                      // TODO: Navigate to Product Reports
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Product Reports - Coming Soon!'),
                          backgroundColor: Color(0xFFF44336),
                        ),
                      );
                    },
                  ),
                  _buildAdminCard(
                    context,
                    'Settings',
                    Icons.settings_rounded,
                    const Color(0xFF607D8B),
                    () {
                      // TODO: Navigate to Settings
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings - Coming Soon!'),
                          backgroundColor: Color(0xFF607D8B),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 32,
                color: color,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF2C3E50),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 