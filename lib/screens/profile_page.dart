// lib/screens/profile_page.dart
import 'package:ecfc/screens/auth/signin_page.dart';
import 'package:ecfc/screens/auth/signup_page.dart';
import 'package:ecfc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      UserCredential? userCredential = await _authService.signInWithGoogle();
      if (userCredential != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Signed in with Google!')),
        );
      }
    } catch (e) {
      setState(() => _errorMessage = "Google Sign-In failed. Try again.");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          StreamBuilder<User?>(
            stream: _authService.authStateChanges,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await _authService.signOut();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Successfully signed out')),
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: StreamBuilder<User?>(
        stream: _authService.authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            User? user = snapshot.data;
            return _buildUserProfile(context, user);
          } else {
            return _buildAuthOptions(context);
          }
        },
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context, User? user) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome!', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 10),
          if (user?.email != null)
            Text('Email: ${user!.email}',
                style: Theme.of(context).textTheme.titleMedium),
          if (user?.uid != null)
            Text('UID: ${user!.uid}',
                style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildAuthOptions(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Sign In Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Sign In', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 15),

            // Google Sign In Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: Image.asset(
                'assets/google_logo.png',
                height: 24,
                width: 24,
              ),
              label: const Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 16),
              ),
            ),

            const SizedBox(height: 20),

            // Sign Up Button
            OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                foregroundColor: Theme.of(context).colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child:
              const Text('Create Account', style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 30),

            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 20),

            // Bottom Text Link
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: Text(
                "Don't have an account? Sign Up",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





// // lib/screens/profile_page.dart
// import 'package:ecfc/screens/auth/signin_page.dart'; // We'll create this
// import 'package:ecfc/screens/auth/signup_page.dart'; // We'll create this
// import 'package:ecfc/services/auth_service.dart'; // Import your AuthService
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class ProfilePage extends StatefulWidget {
//   const ProfilePage({super.key});
//
//   @override
//   State<ProfilePage> createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final AuthService _authService = AuthService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Profile'),
//         actions: [
//           // Add a sign-out button if the user is logged in
//           StreamBuilder<User?>(
//             stream: _authService.authStateChanges,
//             builder: (context, snapshot) {
//               if (snapshot.hasData) { // User is logged in
//                 return IconButton(
//                   icon: const Icon(Icons.logout),
//                   onPressed: () async {
//                     await _authService.signOut();
//                     // Optionally navigate to home or show a message
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Successfully signed out')),
//                     );
//                   },
//                 );
//               }
//               return const SizedBox.shrink(); // No button if not logged in
//             },
//           ),
//         ],
//       ),
//       body: StreamBuilder<User?>(
//         stream: _authService.authStateChanges,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.hasData) {
//             // User is logged in - Show profile information
//             User? user = snapshot.data;
//             return _buildUserProfile(context, user);
//           } else {
//             // User is not logged in - Show Sign In / Sign Up options
//             return _buildAuthOptions(context);
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildUserProfile(BuildContext context, User? user) {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             'Welcome!',
//             style: Theme
//                 .of(context)
//                 .textTheme
//                 .headlineSmall,
//           ),
//           const SizedBox(height: 10),
//           if (user?.email != null)
//             Text(
//               'Email: ${user!.email}',
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .titleMedium,
//             ),
//           if (user?.uid != null)
//             Text(
//               'UID: ${user!.uid}',
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .bodySmall,
//             ),
//           const SizedBox(height: 30),
//           // You can add more profile details or edit profile button here
//         ],
//       ),
//     );
//   }
//
//   Widget _buildAuthOptions(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Theme
//                     .of(context)
//                     .colorScheme
//                     .primary,
//                 foregroundColor: Theme
//                     .of(context)
//                     .colorScheme
//                     .onPrimary,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//               ),
//               child: const Text('Sign In', style: TextStyle(fontSize: 18)),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignInPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 20),
//             OutlinedButton(
//               style: OutlinedButton.styleFrom(
//                 side: BorderSide(color: Theme
//                     .of(context)
//                     .colorScheme
//                     .primary),
//                 foregroundColor: Theme
//                     .of(context)
//                     .colorScheme
//                     .primary,
//                 padding: const EdgeInsets.symmetric(vertical: 15),
//               ),
//               child: const Text(
//                   'Create Account', style: TextStyle(fontSize: 18)),
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => const SignUpPage()),
//                 );
//               },
//             ),
//             const SizedBox(height: 30),
//             Text(
//               'Access your saved items, cart, and more by signing in or creating an account.',
//               textAlign: TextAlign.center,
//               style: Theme
//                   .of(context)
//                   .textTheme
//                   .bodySmall,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
