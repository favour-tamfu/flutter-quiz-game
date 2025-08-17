// lib/screens/auth/login_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/database_helper.dart';
import '../../services/user_provider.dart';
import '../main/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      User? user = await DatabaseHelper().loginUser(
        _emailController.text,
        _passwordController.text,
      );

      if (user != null && mounted) {
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Invalid credentials! Please try again.'),
          ),
        );
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset(
                  'assets/icons/science.png',
                  height: 100,
                  width: 100,
                  errorBuilder: (context, error, stackTrace) {
                    // If it fails, this text will appear.
                    print("!!! ASSET LOADING FAILED !!!");
                    print("Error: $error");
                    return const Text(
                      'ERROR: FAILED TO LOAD start image',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 18),
                    );
                  },
                ),
                const SizedBox(height: 20),
                // ===============================================

                // App Title
                Text(
                  'QuizQuest',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: const Color(0xFFFFD700),
                    fontSize: 32,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Your Adventure in Knowledge',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontStyle: FontStyle.italic
                  ),
                ),
                const SizedBox(height: 48),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter an email' : null,
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a password' : null,
                ),
                const SizedBox(height: 32),

                // Login Button
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                    : ElevatedButton(
                  onPressed: _login,
                  child: const Text('EMBARK ON QUEST'),
                ),
                const SizedBox(height: 16),

                // Link to Register Screen
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: Text(
                    'New Adventurer? Register Here',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}