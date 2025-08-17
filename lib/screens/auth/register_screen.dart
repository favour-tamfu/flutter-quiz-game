// lib/screens/auth/register_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/user_model.dart';
import '../../services/database_helper.dart';
import '../../services/user_provider.dart';
import '../main/home_screen.dart'; 

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers for all three input fields.
  final _pseudoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _register() async {
    // 1. Validate the form.
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // 2. Call the database helper to create a new user.
      User? user = await DatabaseHelper().registerUser(
        _pseudoController.text,
        _emailController.text,
        _passwordController.text,
      );

      // 3. Check the result.
      if (user != null && mounted) {
        // If registration is successful:
        // a. Log the user in immediately by setting them in the provider.
        Provider.of<UserProvider>(context, listen: false).setUser(user);

        // b. Navigate to the HomeScreen.
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        // If registration fails (e.g., email or pseudo-name is already taken).
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Registration failed. Email or Pseudo-name may already be in use.'),
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
    _pseudoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // We add an AppBar here to make it easy for the user to go back to the login screen.
      appBar: AppBar(
        title: const Text('Join the Quest'),
        backgroundColor: Colors.transparent, // Makes the app bar blend with the background
        elevation: 0, // Removes the shadow
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Pseudo-name Field
                TextFormField(
                  controller: _pseudoController,
                  decoration: const InputDecoration(labelText: 'Nick-name (Your public name)'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter a pseudo-name' : null,
                ),
                const SizedBox(height: 20),

                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                  value == null || !value.contains('@') ? 'Please enter a valid email' : null,
                ),
                const SizedBox(height: 20),

                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  validator: (value) =>
                  value == null || value.length < 6 ? 'Password must be at least 6 characters' : null,
                ),
                const SizedBox(height: 32),

                // Register Button
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFFFD700))
                    : ElevatedButton(
                  onPressed: _register,
                  child: const Text('BEGIN ADVENTURE'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}