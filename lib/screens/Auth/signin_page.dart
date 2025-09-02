import 'package:ecfc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential? userCredential =
      await _authService.signInWithEmailPassword(
        _emailController.text,
        _passwordController.text,
      );

      if (userCredential != null && mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in successfully!')),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = e.message ?? "Sign in failed.");
    } catch (e) {
      setState(() => _errorMessage = "Unexpected error. Try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
      appBar: AppBar(title: const Text('Sign In')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Welcome Back!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Sign in to continue to CFC',
                  style: Theme.of(context).textTheme.titleMedium,
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
                      return 'Enter your email';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Enter a valid email';
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
                      return 'Enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 20),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: _signIn,
                  child: const Text('Sign In',
                      style: TextStyle(fontSize: 18)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Sign Up",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary),
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




// import 'package:ecfc/services/auth_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'signup_page.dart';
//
// class SignInPage extends StatefulWidget {
//   const SignInPage({super.key});
//
//   @override
//   State<SignInPage> createState() => _SignInPageState();
// }
//
// class _SignInPageState extends State<SignInPage> {
//   final AuthService _authService = AuthService();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   bool _isLoading = false;
//   String? _errorMessage;
//
//   Future<void> _signIn() async {
//     if (!_formKey.currentState!.validate()) return;
//
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       UserCredential? userCredential = await _authService
//           .signInWithEmailPassword(
//         _emailController.text,
//         _passwordController.text,
//       );
//
//       if (userCredential != null && mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Signed in successfully!')),
//         );
//       }
//     } on FirebaseAuthException catch (e) {
//       setState(() => _errorMessage = e.message ?? "Sign in failed.");
//     } catch (e) {
//       setState(() => _errorMessage = "Unexpected error. Try again.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   Future<void> _signInWithGoogle() async {
//     setState(() {
//       _isLoading = true;
//       _errorMessage = null;
//     });
//
//     try {
//       UserCredential? userCredential = await _authService.signInWithGoogle();
//
//       if (userCredential != null && mounted) {
//         Navigator.of(context).pop();
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Signed in with Google!')),
//         );
//       }
//     } catch (e) {
//       setState(() => _errorMessage = "Google Sign-In failed. Try again.");
//     } finally {
//       if (mounted) setState(() => _isLoading = false);
//     }
//   }
//
//   @override
//   void dispose() {
//     _emailController.dispose();
//     _passwordController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Sign In')),
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(20.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[
//                 Text(
//                   'Welcome Back!',
//                   style: Theme.of(context)
//                       .textTheme
//                       .headlineMedium
//                       ?.copyWith(color: Theme.of(context).colorScheme.primary),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 10),
//                 Text(
//                   'Sign in to continue to CFC',
//                   style: Theme.of(context).textTheme.titleMedium,
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 30),
//
//                 // Email field
//                 TextFormField(
//                   controller: _emailController,
//                   decoration: const InputDecoration(
//                     labelText: 'Email',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.email),
//                   ),
//                   keyboardType: TextInputType.emailAddress,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Enter your email';
//                     }
//                     if (!value.contains('@') || !value.contains('.')) {
//                       return 'Enter a valid email';
//                     }
//                     return null;
//                   },
//                 ),
//                 const SizedBox(height: 20),
//
//                 // Password field
//                 TextFormField(
//                   controller: _passwordController,
//                   decoration: const InputDecoration(
//                     labelText: 'Password',
//                     border: OutlineInputBorder(),
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                   obscureText: true,
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Enter your password';
//                     }
//                     if (value.length < 6) {
//                       return 'Password must be at least 6 characters';
//                     }
//                     return null;
//                   },
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 if (_errorMessage != null)
//                   Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 10.0),
//                     child: Text(
//                       _errorMessage!,
//                       style: TextStyle(
//                           color: Theme.of(context).colorScheme.error),
//                       textAlign: TextAlign.center,
//                     ),
//                   ),
//
//                 const SizedBox(height: 20),
//
//                 // Email/Password Sign-In button
//                 _isLoading
//                     ? const Center(child: CircularProgressIndicator())
//                     : ElevatedButton(
//                   style: ElevatedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                   onPressed: _signIn,
//                   child: const Text('Sign In',
//                       style: TextStyle(fontSize: 18)),
//                 ),
//
//                 const SizedBox(height: 15),
//
//                 // Google Sign-In button
//                 _isLoading
//                     ? const SizedBox()
//                     : OutlinedButton.icon(
//                   icon: Image.asset(
//                     'assets/google_logo.png',
//                     height: 24,
//                     width: 24,
//                   ),
//                   label: const Text(
//                     'Sign in with Google',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   onPressed: _signInWithGoogle,
//                   style: OutlinedButton.styleFrom(
//                     padding: const EdgeInsets.symmetric(vertical: 15),
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 // Navigate to SignUp
//                 TextButton(
//                   onPressed: () {
//                     Navigator.pushReplacement(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => const SignUpPage()),
//                     );
//                   },
//                   child: Text(
//                     "Don't have an account? Sign Up",
//                     style: TextStyle(
//                         color: Theme.of(context).colorScheme.primary),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
