import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/books_provider.dart';
import './providers/kunjungan_provider.dart';
import './screens/login_screen.dart';
import './screens/dashboard_screen.dart';
import './screens/home_screen.dart';
import './screens/books_screen.dart';
import './screens/kunjungan_screen.dart';
import './screens/setting_screen.dart';

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
        ChangeNotifierProvider(create: (ctx) => BookProvider()),
        ChangeNotifierProvider(create: (ctx) => KunjunganProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          home: auth.token.isEmpty ? const LoginScreen() : const HomeScreen(),
          routes: {
            '/login': (ctx) => const LoginScreen(),
            '/home': (ctx) => const HomeScreen(),
            '/dashboard': (ctx) => const DashboardScreen(),
            '/books': (ctx) => const BooksScreen(),
            '/kunjungan': (ctx) => const KunjunganScreen(),
            '/settings': (ctx) => const SettingScreen(),
          },
        ),
      ),
    );
  }
}
