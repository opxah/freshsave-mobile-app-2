class AuthService {
  // Hardcoded users
  static const Map<String, String> _users = {
    'user@freshsave.com': 'password123',
    'admin@freshsave.com': 'admin123',
  };

  static bool _isLoggedIn = false;
  static String? _currentUser;

  // Login method
  static bool login(String email, String password) {
    if (_users.containsKey(email) && _users[email] == password) {
      _isLoggedIn = true;
      _currentUser = email;
      return true;
    }
    return false;
  }

  // Logout method
  static void logout() {
    _isLoggedIn = false;
    _currentUser = null;
  }

  // Check if user is logged in
  static bool get isLoggedIn => _isLoggedIn;

  // Get current user
  static String? get currentUser => _currentUser;

  // Get user display name
  static String get userDisplayName {
    if (_currentUser == null) return '';
    return _currentUser!.split('@')[0];
  }
} 