import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'main.dart';
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _verifyPasswordController = TextEditingController();
  bool _passwordVisible = false;
  bool _verifyPasswordVisible = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _verifyPasswordController.dispose();
    super.dispose();
  }

  bool isValidPassword(String password) {
    return password.length >= 8 && password.contains(RegExp(r'\d'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(fontSize: 24),
                ),
                style: const TextStyle(fontSize: 24),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(fontSize: 24),
                ),
                style: const TextStyle(fontSize: 24),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!RegExp(r'^[^@]+@(?:gmail\.com|yahoo\.com|hotmail\.com)$')
                      .hasMatch(value)) {
                    return 'Email must be @gmail.com, @yahoo.com, or @hotmail.com';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: !_passwordVisible,
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(fontSize: 24),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 24),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  if (!isValidPassword(value)) {
                    return 'at least 8 characters long and contain at least one number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: !_verifyPasswordVisible,
                controller: _verifyPasswordController,
                decoration: InputDecoration(
                  labelText: 'Verify Password',
                  labelStyle: const TextStyle(fontSize: 24),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _verifyPasswordVisible ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _verifyPasswordVisible = !_verifyPasswordVisible;
                      });
                    },
                  ),
                ),
                style: const TextStyle(fontSize: 24),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please verify your password';
                  }
                  if (value.trim() != _passwordController.text.trim()) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _registerUser();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                ),
                child: const Text('Sign Up', style: TextStyle(fontSize: 24)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _registerUser() async {
    String url = 'http://10.0.2.2/check_user.php';
    var response = await http.post(Uri.parse(url), body: {
      'action': 'register',
      'name': _nameController.text.trim(),
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    });

    if (response.statusCode == 200) {
      switch (response.body) {
        case "user_exists":
          _showAlertDialog('This username already exists.');
          break;
        case "register_success":
          _showAlertDialog('Registration successful. You can now log in.', navigateToLogin: true);
          break;
        default:
          _showAlertDialog('Unknown error occurred. Please try again.');
          break;
      }
    } else {
      _showAlertDialog('Failed to connect to server. Please try again later.');
    }
  }

  void _showAlertDialog(String message, {bool navigateToLogin = false}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                if (navigateToLogin) {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginPage()));
                }
              },
            ),
          ],
        );
      },
    );
  }
}


