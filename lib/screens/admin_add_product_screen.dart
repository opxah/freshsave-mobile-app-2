import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'admin_dashboard_screen.dart';

class AdminAddProductScreen extends StatefulWidget {
  const AdminAddProductScreen({super.key});

  @override
  State<AdminAddProductScreen> createState() => _AdminAddProductScreenState();
}

class _AdminAddProductScreenState extends State<AdminAddProductScreen> {
  int _currentStep = 0;
  String _workflowType = '';
  String _foodServiceTask = ''; // New: tracks the selected food service task
  String? _scannedBarcode;
  String? _productName;
  String? _productDescription;
  double? _originalPrice;
  double? _discountPrice;
  DateTime? _expiryDate;
  int _discountHoursBeforeExpiry = 48;
  bool _isScheduled = false;
  DateTime? _scheduleDate;
  TimeOfDay? _scheduleTime;
  bool _isDraft = false;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _originalPriceController = TextEditingController();
  final _discountPriceController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _originalPriceController.dispose();
    _discountPriceController.dispose();
    super.dispose();
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      setState(() {
        _scannedBarcode = barcodes.first.rawValue;
        _currentStep = 1;
      });
      Navigator.of(context).pop(); // Close scanner
      _showProductFoundDialog();
    }
  }

  void _showProductFoundDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Product Found'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Barcode: $_scannedBarcode'),
            const SizedBox(height: 8),
            const Text('Product: Organic Bananas'),
            const Text('Original Price: \$2.99'),
            const SizedBox(height: 16),
            const Text('Would you like to add this product to your discount inventory?'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showManualEntryForm();
            },
            child: const Text('Edit Info'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _currentStep = 2;
              _productName = 'Organic Bananas';
              _originalPrice = 2.99;
              _nameController.text = _productName!;
              _originalPriceController.text = _originalPrice!.toString();
            },
            child: const Text('Use This Product'),
          ),
        ],
      ),
    );
  }

  void _startFoodServiceWorkflow() {
    setState(() {
      _currentStep = 1;
      _workflowType = 'food_service';
    });
  }

  void _startSupermarketWorkflow() {
    setState(() {
      _currentStep = 1;
      _workflowType = 'supermarket';
    });
  }

  void _showManualEntryForm() {
    setState(() {
      _currentStep = 1;
    });
  }

  void _showScanner() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Scan Product'),
            backgroundColor: const Color(0xFF2C3E50),
            foregroundColor: Colors.white,
          ),
          body: MobileScanner(
            onDetect: _onBarcodeDetected,
          ),
        ),
      ),
    );
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    print('Back button pressed. Current step: $_currentStep');
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
        print('Going back to step: $_currentStep');
        // Reset workflow type if going back to step 0
        if (_currentStep == 0) {
          _workflowType = '';
          _foodServiceTask = '';
          print('Reset workflow type and task');
        }
        // Reset food service task if going back to step 1
        if (_currentStep == 1 && _workflowType == 'food_service') {
          _foodServiceTask = '';
          print('Reset food service task');
        }
      });
    } else {
      print('Cannot go back further');
    }
  }

  void _submitProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save product to local database
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Product added successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Column(
        children: [
          // Progress Indicator with Back Button
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Back Button Row
                Row(
                  children: [
                    if (_currentStep > 0) ...[
                      GestureDetector(
                        onTap: _previousStep,
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back_ios_rounded,
                            size: 24,
                            color: Color(0xFF2C3E50),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                    ],
                    Expanded(
                      child: Row(
                        children: [
                          for (int i = 0; i < (_workflowType == 'food_service' ? 5 : 4); i++)
                            Expanded(
                              child: Container(
                                height: 4,
                                margin: EdgeInsets.only(right: i < (_workflowType == 'food_service' ? 4 : 3) ? 8 : 0),
                                decoration: BoxDecoration(
                                  color: i <= _currentStep 
                                    ? const Color(0xFF4CAF50) 
                                    : Colors.grey.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(2),
                                ),
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
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return _buildStep0();
      case 1:
        return _workflowType == 'food_service' ? _buildFoodServiceTaskSelection() : _buildStep1();
      case 2:
        return _workflowType == 'food_service' ? _buildFoodServiceStep1() : _buildStep2();
      case 3:
        return _workflowType == 'food_service' ? _buildFoodServiceStep2() : _buildStep3();
      case 4:
        return _workflowType == 'food_service' ? _buildFoodServiceStep3() : _buildStep0();
      default:
        return _buildStep0();
    }
  }

  Widget _buildStep0() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Your Workflow',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select the workflow that best fits your business type',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),
        
        // Food Service Workflow
        _buildWorkflowCard(
          'Food Service',
          'Restaurants, cafes, and food vendors\n• Quick menu management\n• Same-day pickup items\n• Flexible pricing and availability',
          Icons.restaurant_rounded,
          const Color(0xFF4CAF50),
          () => _startFoodServiceWorkflow(),
        ),
        const SizedBox(height: 16),
        
        // Supermarket Workflow
        _buildWorkflowCard(
          'Supermarket',
          'Grocery stores and retail\n• Barcode scanning\n• Inventory management\n• Expiration-based discounts',
          Icons.store_rounded,
          const Color(0xFF2196F3),
          () => _startSupermarketWorkflow(),
        ),
      ],
    );
  }

  Widget _buildStep1() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Information',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 24),
          
          if (_scannedBarcode != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF4CAF50)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF4CAF50)),
                  const SizedBox(width: 8),
                  Text('Barcode: $_scannedBarcode'),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
          
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Product Name *',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a product name';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _originalPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Original Price *',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter original price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _discountPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Discount Price *',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discount price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text(
                'Next: Set Expiry',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Expiry & Discount Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 24),
        
        // Expiry Date
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Expiry Date',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now().add(const Duration(days: 1)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _expiryDate = date;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        _expiryDate != null 
                          ? '${_expiryDate!.day}/${_expiryDate!.month}/${_expiryDate!.year}'
                          : 'Select expiry date',
                        style: TextStyle(
                          color: _expiryDate != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Automatic Discount Trigger
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Automatic Discount Trigger',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Automatically apply discount this many hours before expiry',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Slider(
                      value: _discountHoursBeforeExpiry.toDouble(),
                      min: 1,
                      max: 168, // 1 week
                      divisions: 167,
                      label: '$_discountHoursBeforeExpiry hours',
                      onChanged: (value) {
                        setState(() {
                          _discountHoursBeforeExpiry = value.round();
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    '$_discountHoursBeforeExpiry hours',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next: Schedule',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Publishing Options',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 24),
        
        // Publish Immediately vs Schedule
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'When to publish?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              
              // Publish Immediately
              RadioListTile<bool>(
                title: const Text('Publish immediately'),
                subtitle: const Text('Make this discount available right away'),
                value: false,
                groupValue: _isScheduled,
                onChanged: (value) {
                  setState(() {
                    _isScheduled = value!;
                  });
                },
              ),
              
              // Schedule for later
              RadioListTile<bool>(
                title: const Text('Schedule for later'),
                subtitle: const Text('Set a specific date and time to publish'),
                value: true,
                groupValue: _isScheduled,
                onChanged: (value) {
                  setState(() {
                    _isScheduled = value!;
                  });
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Schedule Date/Time (if scheduled)
        if (_isScheduled) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Schedule Date & Time',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 365)),
                          );
                          if (date != null) {
                            setState(() {
                              _scheduleDate = date;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_today, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                _scheduleDate != null 
                                  ? '${_scheduleDate!.day}/${_scheduleDate!.month}/${_scheduleDate!.year}'
                                  : 'Select date',
                                style: TextStyle(
                                  color: _scheduleDate != null ? Colors.black : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: () async {
                          final time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              _scheduleTime = time;
                            });
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time, color: Colors.grey),
                              const SizedBox(width: 8),
                              Text(
                                _scheduleTime != null 
                                  ? _scheduleTime!.format(context)
                                  : 'Select time',
                                style: TextStyle(
                                  color: _scheduleTime != null ? Colors.black : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
        
        // Draft Mode
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _isDraft,
                onChanged: (value) {
                  setState(() {
                    _isDraft = value!;
                  });
                },
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save as draft',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Review and publish later',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isDraft ? 'Save Draft' : 'Publish Product',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 28,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkflowCard(
    String title,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(24),
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
        child: Row(
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
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  // Food Service Task Selection
  Widget _buildFoodServiceTaskSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Select Task Type',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Choose how you want to add your food service item',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 32),
        
        // Add item from menu
        _buildTaskCard(
          'Add Item from Menu',
          'Quickly add an existing menu item with current availability',
          Icons.menu_book_rounded,
          const Color(0xFF4CAF50),
          () => _selectFoodServiceTask('from_menu'),
        ),
        const SizedBox(height: 16),
        
        // Add item manually
        _buildTaskCard(
          'Add Item Manually',
          'Create a new item with custom details and pricing',
          Icons.edit_rounded,
          const Color(0xFF2196F3),
          () => _selectFoodServiceTask('manual'),
        ),
        const SizedBox(height: 16),
        
        // Add item to menu
        _buildTaskCard(
          'Add Item to Menu',
          'Save a new item to your menu for future use',
          Icons.add_circle_outline_rounded,
          const Color(0xFF9C27B0),
          () => _selectFoodServiceTask('to_menu'),
        ),
      ],
    );
  }

  void _selectFoodServiceTask(String task) {
    setState(() {
      _foodServiceTask = task;
      _currentStep = 2;
    });
  }

  // Food Service Workflow Steps
  Widget _buildFoodServiceStep1() {
    String title = '';
    String subtitle = '';
    
    switch (_foodServiceTask) {
      case 'from_menu':
        title = 'Select from Menu';
        subtitle = 'Choose an existing menu item to add';
        break;
      case 'manual':
        title = 'Item Details';
        subtitle = 'Enter details for your new item';
        break;
      case 'to_menu':
        title = 'Menu Item Details';
        subtitle = 'Create a new item for your menu';
        break;
      default:
        title = 'Item Details';
        subtitle = 'Enter details for your item';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 24),
        
        // Content based on task type
        if (_foodServiceTask == 'from_menu') ...[
          // Menu selection for "from_menu" task
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your Menu Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSampleMenuItem('Vegetarian Burrito'),
                    _buildSampleMenuItem('Mini Pizza'),
                    _buildSampleMenuItem('Caesar Salad'),
                    _buildSampleMenuItem('Chicken Wrap'),
                    _buildSampleMenuItem('Fruit Bowl'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ] else ...[
          // Sample Menu Items for reference (for manual and to_menu tasks)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF50).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF4CAF50).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sample Menu Items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF4CAF50),
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildSampleMenuItem('Vegetarian Burrito'),
                    _buildSampleMenuItem('Mini Pizza'),
                    _buildSampleMenuItem('Caesar Salad'),
                    _buildSampleMenuItem('Chicken Wrap'),
                    _buildSampleMenuItem('Fruit Bowl'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
        
        if (_foodServiceTask == 'from_menu') ...[
          // Simple form for "from_menu" task
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Available Quantity *',
                    border: OutlineInputBorder(),
                    hintText: '10',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter available quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ] else ...[
          // Full form for "manual" and "to_menu" tasks
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Item Name *',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Vegetarian Burrito',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Fresh vegetables with rice and beans',
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _originalPriceController,
                  decoration: const InputDecoration(
                    labelText: 'Price *',
                    border: OutlineInputBorder(),
                    prefixText: '\$',
                    hintText: '8.99',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a price';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Available Quantity *',
                    border: OutlineInputBorder(),
                    hintText: '10',
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter available quantity';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: 24),
        
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _nextStep,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              _foodServiceTask == 'from_menu' ? 'Next: Pickup Time' : 'Next: Pickup Time',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFoodServiceStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pickup Time & Availability',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 24),
        
        // Pickup Time Window
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Available Until',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 2),
                  );
                  if (time != null) {
                    setState(() {
                      _scheduleTime = time;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(
                        _scheduleTime != null 
                          ? _scheduleTime!.format(context)
                          : 'Select time (e.g., 8:00 PM)',
                        style: TextStyle(
                          color: _scheduleTime != null ? Colors.black : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Tags
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tags (Optional)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildTagChip('Vegetarian', false),
                  _buildTagChip('Spicy', false),
                  _buildTagChip('Contains Nuts', false),
                  _buildTagChip('Gluten Free', false),
                  _buildTagChip('Dairy Free', false),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next: Photo & Publish',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFoodServiceStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Photo & Publish',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        const SizedBox(height: 24),
        
        // Photo Upload
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Item Photo',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: () {
                  // TODO: Implement image picker
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo upload - Coming Soon!')),
                  );
                },
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.5), style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.withOpacity(0.1),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 32, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Add Photo', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        
        // Save to Menu
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.3)),
          ),
          child: Row(
            children: [
              Checkbox(
                value: _isDraft,
                onChanged: (value) {
                  setState(() {
                    _isDraft = value!;
                  });
                },
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save to menu for future use',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'This item will be available in your menu for quick adding',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: _submitFoodServiceProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4CAF50),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _isDraft ? 'Save to Menu' : 'Publish Item',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSampleMenuItem(String name) {
    return GestureDetector(
      onTap: () {
        _nameController.text = name;
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF4CAF50)),
        ),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4CAF50),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildTagChip(String tag, bool isSelected) {
    return FilterChip(
      label: Text(tag),
      selected: isSelected,
      onSelected: (selected) {
        // TODO: Implement tag selection
      },
      selectedColor: const Color(0xFF4CAF50).withOpacity(0.2),
      checkmarkColor: const Color(0xFF4CAF50),
    );
  }

  void _submitFoodServiceProduct() {
    if (_formKey.currentState!.validate()) {
      // TODO: Save to local database (session-only for MVP)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Food service item added successfully!'),
          backgroundColor: Color(0xFF4CAF50),
        ),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    }
  }
} 