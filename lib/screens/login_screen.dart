import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  final Color customBlack = Color(0xFF3C3D37);

  void _submit() async {
    // Validasi email dan password
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackbar("Email dan Password tidak boleh kosong.", true);
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final errorMessage =
        await Provider.of<AuthProvider>(context, listen: false).login(
      _emailController.text,
      _passwordController.text,
    );

    setState(() {
      _isLoading = false;
    });

    if (errorMessage != null) {
      _showSnackbar(errorMessage, true);
    } else {
      _showSnackbar("Login successful!", false);
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.of(context).pushReplacementNamed('/home');
      });
    }
  }

  void _showSnackbar(String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? Colors.red : Colors.green,
      duration: const Duration(seconds: 2),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.book,
                    size: 68,
                    color: customBlack,
                  ),
                  const SizedBox(height: 70),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: TextStyle(color: customBlack),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: customBlack),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlack),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(color: customBlack),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlack),
                          borderRadius: BorderRadius.circular(10)),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: customBlack),
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: customBlack,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 100, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(fontSize: 14, color: Colors.white),
                          ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
