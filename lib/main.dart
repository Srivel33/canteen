import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/admin/admin_main_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/customer/customer_main_screen.dart';
import 'state/auth_state.dart';
import 'state/cart_state.dart';
import 'state/menu_state.dart';
import 'state/order_state.dart';
import 'theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CanteenApp());
}

class CanteenApp extends StatelessWidget {
  const CanteenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthState()),
        ChangeNotifierProvider(create: (_) => MenuState()),
        ChangeNotifierProvider(create: (_) => CartState()),
        ChangeNotifierProvider(create: (_) => OrderState()),
      ],
      child: MaterialApp(
        title: 'Canteen Token System',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: Consumer<AuthState>(
          builder: (context, auth, _) {
            if (!auth.isAuthenticated) {
              return const LoginScreen();
            }
            if (auth.isAdmin) {
              return const AdminMainScreen();
            }
            return const CustomerMainScreen();
          },
        ),
      ),
    );
  }
}
