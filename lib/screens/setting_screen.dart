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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildGridItem(context, 'Dashboard', Icons.dashboard, '/dashboard'),
            const SizedBox(height: 10),
            _buildGridItem(context, 'Books', Icons.book, '/books'),
            const SizedBox(height: 10),
            _buildGridItem(
                context, 'Kunjungan', Icons.visibility, '/kunjungan'),
          ],
        ),
      ),
    );
  }

  Widget _buildGridItem(
      BuildContext context, String title, IconData icon, String route) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(route);
      },
      child: Card(
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 20),
              Text(title, style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      ),
    );
  }
}
