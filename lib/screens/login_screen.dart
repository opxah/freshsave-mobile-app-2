import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_screen.dart';

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
  bool _isLoading = false;
  bool _obscurePassword = true;

  late AnimationController _character1Controller;
  late AnimationController _character2Controller;
  late AnimationController _character3Controller;
  late AnimationController _character4Controller;
  late AnimationController _circleController;

  @override
  void initState() {
    super.initState();
    
    // Animation controllers for characters
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
    _emailController.dispose();
    _passwordController.dispose();
    _character1Controller.dispose();
    _character2Controller.dispose();
    _character3Controller.dispose();
    _character4Controller.dispose();
    _circleController.dispose();
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));

      final success = AuthService.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      setState(() {
        _isLoading = false;
      });

      if (success) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid email or password'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A), // Dark background
        ),
        child: Stack(
          children: [
            // Animated background circles
            Positioned(
              top: 100,
              left: 50,
              child: _AnimatedCircle(
                color: Colors.pink.withValues(alpha: 0.3),
                controller: _circleController,
              ),
            ),
            Positioned(
              top: 200,
              right: 80,
              child: _AnimatedCircle(
                color: Colors.blue.withValues(alpha: 0.3),
                controller: _circleController,
              ),
            ),
            Positioned(
              bottom: 300,
              left: 100,
              child: _AnimatedCircle(
                color: Colors.green.withValues(alpha: 0.3),
                controller: _circleController,
              ),
            ),
            Positioned(
              bottom: 200,
              right: 60,
              child: _AnimatedCircle(
                color: Colors.yellow.withValues(alpha: 0.3),
                controller: _circleController,
              ),
            ),
            
            // 3D Food Illustrations - Top 50% of screen (Non-overlapping)
            // Top row
            Positioned(
              top: 60,
              left: 40,
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
              top: 60,
              right: 40,
              child: _AnimatedFood(
                food: _FoodData(
                  name: "Fresh Chicken",
                  color: Colors.orange,
                  emoji: "🍗",
                ),
                controller: _character2Controller,
              ),
            ),
            
            // Middle row
            Positioned(
              top: 140,
              left: 0,
              right: 0,
              child: Center(
                child: _AnimatedFood(
                  food: _FoodData(
                    name: "Fresh Bread",
                    color: Colors.amber,
                    emoji: "🥖",
                  ),
                  controller: _character2Controller,
                ),
              ),
            ),
            
            // Third row
            Positioned(
              top: 220,
              left: 60,
              child: _AnimatedFood(
                food: _FoodData(
                  name: "Fresh Milk",
                  color: Colors.blue,
                  emoji: "🥛",
                ),
                controller: _character3Controller,
              ),
            ),
            Positioned(
              top: 220,
              right: 60,
              child: _AnimatedFood(
                food: _FoodData(
                  name: "Fresh Eggs",
                  color: Colors.orange,
                  emoji: "🥚",
                ),
                controller: _character4Controller,
              ),
            ),
            
            // Fourth row
            Positioned(
              top: 300,
              left: 0,
              right: 0,
              child: Center(
                child: _AnimatedFood(
                  food: _FoodData(
                    name: "Fresh Vegetables",
                    color: Colors.green,
                    emoji: "🥬",
                  ),
                  controller: _character4Controller,
                ),
              ),
            ),
            
            // Bottom row
            Positioned(
              top: 380,
              left: 80,
              child: _AnimatedFood(
                food: _FoodData(
                  name: "Fresh Meat",
                  color: Colors.red,
                  emoji: "🥩",
                ),
                controller: _character4Controller,
              ),
            ),
            Positioned(
              top: 380,
              right: 80,
              child: _AnimatedFood(
                food: _FoodData(
                  name: "Fresh Fish",
                  color: Colors.cyan,
                  emoji: "🐟",
                ),
                controller: _character1Controller,
              ),
            ),
            
            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Top 50% - Character space
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                  ),
                  
                  // Login card - Bottom 50%
                  Container(
                    height: MediaQuery.of(context).size.height * 0.5,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Welcome text
                            const Center(
                              child: Text(
                                "Let's get you signed in!",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            
                            const SizedBox(height: 30),
                            
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
                                    // TODO: Navigate to sign up
                                  },
                                  child: const Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            
                            // Email Field
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
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
                                  vertical: 16,
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
                            const SizedBox(height: 20),

                            // Password Field
                            TextFormField(
                              controller: _passwordController,
                              obscureText: _obscurePassword,
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
                                  vertical: 16,
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 10),
                            
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
                            
                            const SizedBox(height: 30),

                            // Sign In Button
                            SizedBox(
                              width: double.infinity,
                              height: 56,
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: food.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: food.color.withValues(alpha: 0.3),
                width: 2,
              ),
            ),
            child: Text(
              food.emoji,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        );
      },
    );
  }
} 