import 'package:flutter/material.dart';
import 'main_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _scrollController = ScrollController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleKeyboardVisibility(bool isVisible) {
    setState(() {
      _isKeyboardVisible = isVisible;
    });
  }

  void _scrollToShowForm() {
    _handleKeyboardVisibility(true);
    
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.position.pixels;
        final targetScroll = maxScroll - 200;
        
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

  void _signUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate signup process
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        
        // Navigate to main screen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    final isKeyboardVisible = keyboardHeight > 0;
    
    if (isKeyboardVisible != _isKeyboardVisible) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleKeyboardVisibility(isKeyboardVisible);
      });
    }
    
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top section with signup form (50%)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: GestureDetector(
                  onTap: () {
                    // Dismiss keyboard when tapping outside form fields
                    FocusScope.of(context).unfocus();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        
                        // Title
                        const Center(
                          child: Text(
                            "Create Account",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Username Field
                        TextFormField(
                          controller: _usernameController,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                            prefixIcon: const Icon(
                              Icons.person_outlined,
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
                              return 'Please enter a username';
                            }
                            if (value.length < 3) {
                              return 'Username must be at least 3 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 8),
                        
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
                        
                        const SizedBox(height: 8),
                        
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
                              return 'Please enter a password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Confirm Password Field
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
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
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword = !_obscureConfirmPassword;
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
                              return 'Please confirm your password';
                            }
                            if (value != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Create Account Button
                        SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _signUp,
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
                                    'Create Account',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                          ),
                        ),
                        
                        const SizedBox(height: 8),
                        
                        // Sign In link
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop(); // Go back to login
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                "Already have an account? Sign In",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 8), // Minimal bottom padding
                      ],
                    ),
                  ),
                ),
                ),
              ),
            ),
            
            // Bottom section with food animations (50%)
            Expanded(
              flex: 5,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF1A1A1A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Stack(
                  children: [
                    // Animated circles - Positioned in gaps to avoid overlapping food icons
                    Positioned(
                      top: 40,
                      left: 80,
                      child: _AnimatedCircle(
                        color: Colors.blue.withValues(alpha: 0.15),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 40,
                      right: 80,
                      child: _AnimatedCircle(
                        color: Colors.orange.withValues(alpha: 0.1),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 110,
                      left: 60,
                      child: _AnimatedCircle(
                        color: Colors.purple.withValues(alpha: 0.12),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 110,
                      right: 60,
                      child: _AnimatedCircle(
                        color: Colors.green.withValues(alpha: 0.08),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 180,
                      left: 70,
                      child: _AnimatedCircle(
                        color: Colors.pink.withValues(alpha: 0.1),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 180,
                      right: 70,
                      child: _AnimatedCircle(
                        color: Colors.yellow.withValues(alpha: 0.06),
                        controller: _circleController,
                      ),
                    ),
                    Positioned(
                      top: 250,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: _AnimatedCircle(
                          color: Colors.teal.withValues(alpha: 0.09),
                          controller: _circleController,
                        ),
                      ),
                    ),
                    
                    // Food items - Same scattered distribution as login screen
                    // Top row - left and right items
                    Positioned(
                      top: 20,
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
                      top: 20,
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
                    
                    // Second row - left and right items
                    Positioned(
                      top: 100,
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
                      top: 100,
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
                    
                    // Third row - left and right items
                    Positioned(
                      top: 180,
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
                      top: 180,
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
                    
                    // Fourth row - left and right items
                    Positioned(
                      top: 260,
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
                      top: 260,
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
                    
                    // Additional food items to fill middle space - same as login
                    Positioned(
                      top: 60,
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
                      top: 140,
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
                      top: 220,
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