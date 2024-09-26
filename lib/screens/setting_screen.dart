import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  void _showLogoutSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final message =
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logout(context);

              if (context.mounted) {
                _showLogoutSnackbar(context, message);
              }
            },
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome to Settings!'),
      ),
    );
  }
}
