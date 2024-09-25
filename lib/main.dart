import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './screens/login_screen.dart';
import './screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          home: auth.token.isEmpty ? const LoginScreen() : const DashboardScreen(),
          routes: {
            '/login': (ctx) => const LoginScreen(),
            '/dashboard': (ctx) => const DashboardScreen(),
          },
        ),
      ),
    );
  }
}
