class AuthService {
  // Hardcoded users with roles
  static const Map<String, Map<String, dynamic>> _users = {
    'user@freshsave.com': {
      'password': 'password123',
      'role': 'customer',
    },
    'admin@freshsave.com': {
      'password': 'admin123',
      'role': 'admin',
    },
  };

  static bool _isLoggedIn = false;
  static String? _currentUser;
  static String? _currentUserRole;

  // Login method
  static bool login(String email, String password) {
    final userData = _users[email];
    if (userData != null && userData['password'] == password) {
      _isLoggedIn = true;
      _currentUser = email;
      _currentUserRole = userData['role'];
      return true;
    }
    return false;
  }

  // Logout method
  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _currentUserRole = null;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _isLoggedIn;

  // Get current user
  static String? get currentUser => _currentUser;

  // Get current user role
  static String? get currentUserRole => _currentUserRole;

  // Check if user is admin
  static bool get isAdmin => _currentUserRole == 'admin';

  // Check if user is customer
  static bool get isCustomer => _currentUserRole == 'customer';

  // Get user display name
  static String get userDisplayName {
    if (_currentUser == null) return '';
    return _currentUser!.split('@')[0];
  }
} 