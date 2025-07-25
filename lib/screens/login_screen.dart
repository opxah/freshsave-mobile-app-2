import 'package:flutter/material.dart';
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
  bool _obscurePassword = true;
  bool _isLoading = false;

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
    super.dispose();
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate login process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
                         // Top section with animated food items (50% of screen)
             SizedBox(
               height: MediaQuery.of(context).size.height * 0.5,
              child: Stack(
                children: [
                                     // Animated circles
                   Positioned(
                     top: 100,
                     left: 50,
                     child: _AnimatedCircle(
                       color: Colors.blue.withValues(alpha: 0.15),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 200,
                     right: 80,
                     child: _AnimatedCircle(
                       color: Colors.orange.withValues(alpha: 0.1),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 150,
                     left: 200,
                     child: _AnimatedCircle(
                       color: Colors.purple.withValues(alpha: 0.12),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 250,
                     left: 100,
                     child: _AnimatedCircle(
                       color: Colors.green.withValues(alpha: 0.08),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 180,
                     right: 150,
                     child: _AnimatedCircle(
                       color: Colors.pink.withValues(alpha: 0.1),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 320,
                     right: 30,
                     child: _AnimatedCircle(
                       color: Colors.yellow.withValues(alpha: 0.06),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 80,
                     right: 200,
                     child: _AnimatedCircle(
                       color: Colors.teal.withValues(alpha: 0.09),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 280,
                     left: 250,
                     child: _AnimatedCircle(
                       color: Colors.indigo.withValues(alpha: 0.07),
                       controller: _circleController,
                     ),
                   ),
                   Positioned(
                     top: 120,
                     left: 0,
                     right: 0,
                     child: Center(
                       child: _AnimatedCircle(
                         color: Colors.amber.withValues(alpha: 0.05),
                         controller: _circleController,
                       ),
                     ),
                   ),
                  
                                     // Food items - First row
                   Positioned(
                     top: 40,
                     left: 30,
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
                     right: 30,
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
                     top: 140,
                     left: 100,
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
                     top: 140,
                     right: 100,
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
                     top: 240,
                     left: 50,
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
                     top: 240,
                     right: 50,
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
                     top: 340,
                     left: 70,
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
                     top: 340,
                     right: 70,
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
                     top: 90,
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
                     top: 190,
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
                     top: 290,
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
                        
                                                 const SizedBox(height: 16),
                         
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
                        
                                                 const SizedBox(height: 18), // Bottom padding for scroll safety
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