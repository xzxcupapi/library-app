import 'package:flutter/material.dart';


class KunjunganScreen extends StatelessWidget {
  const KunjunganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Management'),
      ),
      body: const Center(
        child: Text('Welcome to kunjungan!'),
      ),
    );
  }
}
