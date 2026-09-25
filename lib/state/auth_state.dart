import 'package:flutter/material.dart';
import '../models/usermodel.dart';

class AuthState extends ChangeNotifier {
  UserModel? _currentUser;

  // Preset demo accounts for quick testing
  static final List<UserModel> demoUsers = [
    UserModel(
      id: 'usr_student_1',
      name: 'Aarav Sharma',
      email: 'aarav.sharma@college.edu',
      rollNumber: '21CS042',
      userType: 'student',
      walletBalance: 350.0,
      phone: '+91 98765 43210',
    ),
    UserModel(
      id: 'usr_staff_1',
      name: 'Dr. Priya Raman',
      email: 'priya.raman@college.edu',
      rollNumber: 'FAC-804',
      userType: 'staff',
      walletBalance: 720.0,
      phone: '+91 98123 45678',
    ),
    UserModel(
      id: 'usr_admin_1',
      name: 'Chef Suresh (Kitchen)',
      email: 'canteen.admin@college.edu',
      rollNumber: 'KTN-01',
      userType: 'admin',
      walletBalance: 0.0,
      phone: '+91 99000 11223',
    ),
  ];

  AuthState() {
    // Default to student demo user for immediate convenience
    _currentUser = demoUsers[0];
  }

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.userType == 'admin';

  void login({
    required String name,
    required String rollNumber,
    required String email,
    required String userType,
  }) {
    _currentUser = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      rollNumber: rollNumber,
      email: email,
      userType: userType,
      walletBalance: 300.0,
    );
    notifyListeners();
  }

  void switchUser(UserModel user) {
    _currentUser = user;
    notifyListeners();
  }

  void deductWallet(double amount) {
    if (_currentUser != null && _currentUser!.walletBalance >= amount) {
      _currentUser = _currentUser!.copyWith(
        walletBalance: _currentUser!.walletBalance - amount,
      );
      notifyListeners();
    }
  }

  void addWallet(double amount) {
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        walletBalance: _currentUser!.walletBalance + amount,
      );
      notifyListeners();
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
