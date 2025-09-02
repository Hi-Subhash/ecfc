// lib/screens/auth/signup_page.dart
import 'package:ecfc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signin_page.dart'; // For navigating back to sign in

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential? userCredential = await _authService
          .signUpWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (userCredential != null && mounted) {
        // User created and signed in, navigate back (to profile or home)
        Navigator.of(context).popUntil((route) =>
        route
            .isFirst); // Go back to the initial screen in stack (e.g. CfcHomePage)
        // Or pop twice if you came from ProfilePage -> SignInPage -> SignUpPage
        // Navigator.of(context).pop();
        // Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(
              'Account created successfully! You are now signed in.')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message ?? "An error occurred during sign up.";
      });
    } catch (e) {
      setState(() {
        _errorMessage = "An unexpected error occurred. Please try again.";
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Get Started with CFC',
                  style: Theme
                      .of(context)
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Create an account to enjoy all features',
                  style: Theme
                      .of(context)
                      .textTheme
                      .titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                      _errorMessage!,
                      style: TextStyle(color: Theme
                          .of(context)
                          .colorScheme
                          .error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                    foregroundColor: Theme
                        .of(context)
                        .colorScheme
                        .onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _signUp,
                  child: const Text(
                      'Create Account', style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to Sign In page
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignInPage()),
                    );
                  },
                  child: Text(
                    "Already have an account? Sign In",
                    style: TextStyle(color: Theme
                        .of(context)
                        .colorScheme
                        .primary),
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
    