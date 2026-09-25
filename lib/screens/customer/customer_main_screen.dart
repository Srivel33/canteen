import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../state/auth_state.dart';
import '../../state/order_state.dart';
import '../../theme/app_theme.dart';
import '../../state/app_navigation_state.dart';
import '../admin/admin_main_screen.dart';
import 'menu_screen.dart';
import 'profile_tab.dart';
import 'token_status_screen.dart';

class CustomerMainScreen extends StatefulWidget {
  const CustomerMainScreen({super.key});

  @override
  State<CustomerMainScreen> createState() => _CustomerMainScreenState();
}

class _CustomerMainScreenState extends State<CustomerMainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final orderState = Provider.of<OrderState>(context);
    final navState = Provider.of<AppNavigationState>(context);
    final user = authState.currentUser;

    final activeOrdersCount = user != null
        ? orderState.getActiveOrdersForUser(user.id).length
        : 0;

    final screens = [
      const MenuScreen(),
      TokenStatusScreen(
        onGoToMenu: () => navState.setIndex(0),
      ),
      const ProfileTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppTheme.primaryLight,
              child: Text(
                user != null && user.name.isNotEmpty ? user.name[0] : 'U',
                style: const TextStyle(
                  color: AppTheme.primaryDark,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user != null ? 'Hi, ${user.name.split(" ")[0]}' : 'Welcome',
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    user != null
                        ? '${user.userType.toUpperCase()} • ${user.rollNumber}'
                        : 'Guest',
                    style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          // Wallet Balance Chip
          if (user != null)
            GestureDetector(
              onTap: () => setState(() => _currentIndex = 2),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.orange.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_balance_wallet_rounded,
                        size: 14, color: AppTheme.primaryDark),
                    const SizedBox(width: 4),
                    Text(
                      '₹${user.walletBalance.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.primaryDark,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Switch to Kitchen Portal quick button
          TextButton.icon(
            onPressed: () {
              // Switch to the admin demo user
              final adminUser = AuthState.demoUsers.firstWhere((u) => u.userType == 'admin');
              authState.switchUser(adminUser);
            },
            icon: const Icon(Icons.soup_kitchen_rounded, size: 16, color: AppTheme.textSecondary),
            label: const Text(
              'Kitchen',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecondary, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      body: IndexedStack(
        index: navState.currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navState.currentIndex,
        onTap: (index) => navState.setIndex(index),
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu_rounded),
            activeIcon: Icon(Icons.restaurant_menu_rounded),
            label: 'Menu',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.confirmation_number_outlined),
                if (activeOrdersCount > 0)
                  Positioned(
                    top: -4,
                    right: -6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$activeOrdersCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.confirmation_number_rounded),
            label: 'My Tokens',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
