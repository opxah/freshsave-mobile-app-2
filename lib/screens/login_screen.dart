import 'package:flutter/material.dart';
import 'main_screen.dart';
import '../services/auth_service.dart';
import 'admin_dashboard_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isKeyboardVisible = false;

  // Animation controllers
  late AnimationController _character1Controller;
  late AnimationController _character2Controller;
  late AnimationController _character3Controller;
  late AnimationController _character4Controller;
  late AnimationController _circleController;

  @override
  void initState() {
    super.initState();
    _character1Controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _character2Controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _character3Controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    _character4Controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    _circleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _character1Controller.dispose();
    _character2Controller.dispose();
    _character3Controller.dispose();
    _character4Controller.dispose();
    _circleController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyboardVisibility(bool isVisible) {
    setState(() {
      _isKeyboardVisible = isVisible;
    });
  }

  void _scrollToShowForm() {
    // Set keyboard visible when form is tapped
    _handleKeyboardVisibility(true);
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final targetScroll = maxScroll - 200; // Leave some space at bottom
        
        if (targetScroll > currentScroll) {
          _scrollController.animateTo(
            targetScroll,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Get email and password from form
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // Attempt login using AuthService
        if (AuthService.login(email, password)) {
          // Login successful - navigate based on user role
          if (AuthService.isAdmin) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
            );
          } else if (AuthService.isCustomer) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          }
        } else {
          // Login failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Detect keyboard visibility
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    // Update keyboard state if it changed
    if (isKeyboardVisible != _isKeyboardVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleKeyboardVisibility(isKeyboardVisible);
      });
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
                         // Top section with animated food items (dynamic sizing)
             AnimatedContainer(
               duration: Duration(milliseconds: _isKeyboardVisible ? 150 : 300),
               curve: _isKeyboardVisible ? Curves.easeOut : Curves.easeInOut,
               height: _isKeyboardVisible 
                   ? MediaQuery.of(context).size.height * 0.15  // 15% when keyboard visible
                   : MediaQuery.of(context).size.height * 0.5, // 50% when keyboard hidden
              child: Stack(
                children: [
                                     // Animated circles - fixed positions
                   Positioned(
                     top: 60,
                     left: 50,
                     child: _AnimatedCircle(
                       color: Colors.blue.withValues(alpha: 0.15),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 120,
                     right: 80,
                     child: _AnimatedCircle(
                       color: Colors.orange.withValues(alpha: 0.1),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 90,
                     left: 180,
                     child: _AnimatedCircle(
                       color: Colors.purple.withValues(alpha: 0.12),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 150,
                     left: 100,
                     child: _AnimatedCircle(
                       color: Colors.green.withValues(alpha: 0.08),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 110,
                     right: 150,
                     child: _AnimatedCircle(
                       color: Colors.pink.withValues(alpha: 0.1),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 180,
                     right: 40,
                     child: _AnimatedCircle(
                       color: Colors.yellow.withValues(alpha: 0.06),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 70,
                     right: 200,
                     child: _AnimatedCircle(
                       color: Colors.teal.withValues(alpha: 0.09),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 140,
                     left: 250,
                     child: _AnimatedCircle(
                       color: Colors.indigo.withValues(alpha: 0.07),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 100,
                     left: 0,
                     right: 0,
                     child: Center(
                       child: _AnimatedCircle(
                         color: Colors.amber.withValues(alpha: 0.05),
                         controller: _circleController,
                       ),
                     ),
                   ),
                  
                                     // Food items - Fixed positioning
                   Positioned(
                     top: 40,
                     left: 20,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Apple",
                         color: Colors.red,
                         emoji: "🍎",
                       ),
                       controller: _character1Controller,
                     ),
                   ),
                   Positioned(
                     top: 40,
                     right: 20,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Chicken",
                         color: Colors.orange,
                         emoji: "🍗",
                       ),
                       controller: _character2Controller,
                     ),
                   ),
                   
                   // Second row
                   Positioned(
                     top: 120,
                     left: 80,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Bread",
                         color: Colors.brown,
                         emoji: "🥖",
                       ),
                       controller: _character3Controller,
                     ),
                   ),
                   Positioned(
                     top: 120,
                     right: 80,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Milk",
                         color: Colors.blue,
                         emoji: "🥛",
                       ),
                       controller: _character4Controller,
                     ),
                   ),
                   
                   // Third row
                   Positioned(
                     top: 200,
                     left: 40,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Eggs",
                         color: Colors.orange,
                         emoji: "🥚",
                       ),
                       controller: _character1Controller,
                     ),
                   ),
                   Positioned(
                     top: 200,
                     right: 40,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Vegetables",
                         color: Colors.green,
                         emoji: "🥬",
                       ),
                       controller: _character2Controller,
                     ),
                   ),
                   
                   // Fourth row
                   Positioned(
                     top: 280,
                     left: 60,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Meat",
                         color: Colors.red,
                         emoji: "🥩",
                       ),
                       controller: _character3Controller,
                     ),
                   ),
                   Positioned(
                     top: 280,
                     right: 60,
                     child: _AnimatedFood(
                       food: _FoodData(
                         name: "Fresh Fish",
                         color: Colors.cyan,
                         emoji: "🐟",
                       ),
                       controller: _character4Controller,
                     ),
                   ),
                   
                   // Additional food items to fill middle space
                   Positioned(
                     top: 80,
                     left: 0,
                     right: 0,
                     child: Center(
                       child: _AnimatedFood(
                         food: _FoodData(
                           name: "Fresh Tomatoes",
                           color: Colors.red,
                           emoji: "🍅",
                         ),
                         controller: _character1Controller,
                       ),
                     ),
                   ),
                   Positioned(
                     top: 160,
                     left: 0,
                     right: 0,
                     child: Center(
                       child: _AnimatedFood(
                         food: _FoodData(
                           name: "Fresh Carrots",
                           color: Colors.orange,
                           emoji: "🥕",
                         ),
                         controller: _character2Controller,
                       ),
                     ),
                   ),
                   Positioned(
                     top: 240,
                     left: 0,
                     right: 0,
                     child: Center(
                       child: _AnimatedFood(
                         food: _FoodData(
                           name: "Fresh Broccoli",
                           color: Colors.green,
                           emoji: "🥦",
                         ),
                         controller: _character3Controller,
                       ),
                     ),
                   ),
                ],
              ),
            ),
            
                         // Bottom section with login form (fills remaining space)
             Expanded(
               child: Container(
                 decoration: const BoxDecoration(
                   color: Colors.white,
                   borderRadius: BorderRadius.only(
                     topLeft: Radius.circular(30),
                     topRight: Radius.circular(30),
                   ),
                 ),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                                             children: [
                         const SizedBox(height: 8),
                         
                         // Welcome text
                        const Center(
                          child: Text(
                            "Let's get you signed in!",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                                                 const SizedBox(height: 12),
                         
                         // Sign up prompt
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "You don't have an account yet? ",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                print('Sign Up clicked!'); // Debug print
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                        
                                                 const SizedBox(height: 16),
                         
                         // Email Field
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          onTap: () {
                            _scrollToShowForm();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                                                 const SizedBox(height: 12),
                         
                         // Password Field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          onTap: () {
                            _scrollToShowForm();
                          },
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.lock_outlined,
                              color: Colors.grey,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        
                                                 const SizedBox(height: 6),
                         
                         // Forgot password
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              // TODO: Navigate to forgot password
                            },
                            child: const Text(
                              "Forgot password?",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                        
                                                 const SizedBox(height: 16),
                         
                         // Sign In Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                        
                                                 const SizedBox(height: 100), // Extra bottom padding for keyboard
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Animated circle widget
class _AnimatedCircle extends StatelessWidget {
  final Color color;
  final AnimationController controller;

  const _AnimatedCircle({
    required this.color,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.8 + (controller.value * 0.4),
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

// Animated food widget
class _AnimatedFood extends StatelessWidget {
  final _FoodData food;
  final AnimationController controller;

  const _AnimatedFood({
    required this.food,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, controller.value * 10),
          child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: food.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: food.color.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  food.emoji,
                  style: const TextStyle(fontSize: 32),
                ),
            ),
          ),
        );
      },
    );
  }
}

// Food data class
class _FoodData {
  final String name;
  final Color color;
  final String emoji;

  _FoodData({
    required this.name,
    required this.color,
    required this.emoji,
  });
} 