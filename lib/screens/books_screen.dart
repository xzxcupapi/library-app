import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class BooksScreen extends StatelessWidget {
  const BooksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.logout),
        //     onPressed: () {
        //       Provider.of<AuthProvider>(context, listen: false).logout(context);
        //       Navigator.of(context).pushReplacementNamed('/login');
        //     },
        //   ),
        // ],
      ),
      body: const Center(
        child: Text('Welcome to Books Screen!'),
      ),
    );
  }
}
