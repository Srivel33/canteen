import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_state.dart';
import '../../theme/app_theme.dart';
import '../customer/customer_main_screen.dart';
import '../admin/admin_main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'student'; // 'student', 'staff', 'admin'
  final _nameController = TextEditingController(text: 'Aarav Sharma');
  final _idController = TextEditingController(text: '21CS042');
  final _emailController = TextEditingController(text: 'aarav@college.edu');

  void _onRoleChanged(String role) {
    setState(() {
      _selectedRole = role;
      if (role == 'student') {
        _nameController.text = 'Aarav Sharma';
        _idController.text = '21CS042';
        _emailController.text = 'aarav@college.edu';
      } else if (role == 'staff') {
        _nameController.text = 'Dr. Priya Raman';
        _idController.text = 'FAC-804';
        _emailController.text = 'priya.raman@college.edu';
      } else {
        _nameController.text = 'Chef Suresh';
        _idController.text = 'KTN-01';
        _emailController.text = 'canteen.admin@college.edu';
      }
    });
  }

  void _submitLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      final authState = Provider.of<AuthState>(context, listen: false);
      authState.login(
        name: _nameController.text.trim(),
        rollNumber: _idController.text.trim(),
        email: _emailController.text.trim(),
        userType: _selectedRole,
      );

      _navigateToHome();
    }
  }

  void _quickLogin(int index) {
    final authState = Provider.of<AuthState>(context, listen: false);
    final user = AuthState.demoUsers[index];
    authState.switchUser(user);
    _navigateToHome();
  }

  void _navigateToHome() {
    final authState = Provider.of<AuthState>(context, listen: false);
    if (authState.isAdmin) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminMainScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const CustomerMainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                // App Logo & Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.fastfood_rounded,
                        color: AppTheme.primaryDark,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Canteen Token',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          'Campus Food & Smart Pickups',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                const Text(
                  'Select Role',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 10),

                // Role Selector Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _roleTab('Student', 'student', Icons.school_rounded),
                      _roleTab('Faculty', 'staff', Icons.badge_rounded),
                      _roleTab('Kitchen', 'admin', Icons.soup_kitchen_rounded),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Form fields
                Text(
                  _selectedRole == 'student'
                      ? 'Student Roll Number'
                      : _selectedRole == 'staff'
                          ? 'Staff ID'
                          : 'Admin Employee ID',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.tag_rounded, size: 20),
                    hintText: 'Enter your ID',
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter ID' : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Full Name',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.person_outline_rounded, size: 20),
                    hintText: 'Enter full name',
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter name' : null,
                ),
                const SizedBox(height: 16),

                const Text(
                  'Campus Email',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email_outlined, size: 20),
                    hintText: 'Enter college email',
                  ),
                  validator: (v) => v!.isEmpty ? 'Please enter email' : null,
                ),
                const SizedBox(height: 28),

                // Sign In Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submitLogin,
                    child: Text(
                      _selectedRole == 'admin' ? 'Enter Kitchen Portal' : 'Login to Order',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),

                const SizedBox(height: 36),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        'OR QUICK TEST WITH DEMO ACCOUNTS',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textMuted,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),

                // Quick Demo Buttons
                _demoUserCard(
                  title: 'Student: Aarav Sharma (21CS042)',
                  subtitle: 'Has wallet balance ₹350, 1 ready token',
                  roleColor: Colors.blue,
                  icon: Icons.school_rounded,
                  onTap: () => _quickLogin(0),
                ),
                const SizedBox(height: 10),
                _demoUserCard(
                  title: 'Faculty: Dr. Priya Raman (FAC-804)',
                  subtitle: 'Has wallet balance ₹720, 1 preparing token',
                  roleColor: Colors.purple,
                  icon: Icons.badge_rounded,
                  onTap: () => _quickLogin(1),
                ),
                const SizedBox(height: 10),
                _demoUserCard(
                  title: 'Kitchen Admin: Chef Suresh',
                  subtitle: 'Manage live orders, toggle food availability',
                  roleColor: AppTheme.primaryDark,
                  icon: Icons.soup_kitchen_rounded,
                  onTap: () => _quickLogin(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _roleTab(String title, String role, IconData icon) {
    final isSelected = _selectedRole == role;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onRoleChanged(role),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? AppTheme.primary : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _demoUserCard({
    required String title,
    required String subtitle,
    required Color roleColor,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade50,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: roleColor.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: roleColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppTheme.textMuted),
          ],
        ),
      ),
    );
  }
}
