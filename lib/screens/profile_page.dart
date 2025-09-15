// lib/screens/profile_page.dart
import 'package:ecfc/screens/auth/signin_page.dart';
import 'package:ecfc/screens/auth/signup_page.dart';
import 'package:ecfc/screens/edit_profile.dart';
import 'package:ecfc/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      await _authService.signInWithGoogle();
      if (mounted) {
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

  Future<void> _confirmSignOut() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content: const Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop(false); // Close the dialog, return false
              },
            ),
            TextButton(
              child: const Text('Logout'),
              onPressed: () {
                Navigator.of(dialogContext).pop(true); // Close the dialog, return true
              },
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _authService.signOut();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed out')),
        );
        // Optionally, navigate to a login screen or home screen after logout
        // For example, if you have a SignInPage:
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(builder: (context) => const SignInPage()),
        //   (Route<dynamic> route) => false,
        // );
      }
    }
  }

  Future<void> createUserProfile(User user) async {
    final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

    await userDoc.set({
      "name": user.displayName ?? "",
      "email": user.email ?? "",
      "photoUrl": user.photoURL ?? "",
      "gender": "",
      "dob": "",
      "address": "",
    }, SetOptions(merge: true));
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
                  onPressed: _confirmSignOut, // Updated here
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
            return _buildUserProfile(snapshot.data!);
          } else {
            return _buildAuthOptions(context);
          }
        },
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        var data = snapshot.data!.data() as Map<String, dynamic>?;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              // Profile Picture
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: data?['photoUrl'] != null
                      ? NetworkImage(data!['photoUrl'])
                      : const AssetImage('assets/default_avatar.png')
                  as ImageProvider,
                ),
              ),
              const SizedBox(height: 20),

              _buildInfoTile("Full Name", data?['name'] ?? ""),
              _buildInfoTile("Email", user.email ?? ""),
              _buildInfoTile("Gender", data?['gender'] ?? ""),
              _buildInfoTile("Date of Birth", data?['dob'] ?? ""),
              _buildInfoTile("Address", data?['address'] ?? ""),

              const SizedBox(height: 30),

              ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user)),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text("Edit Profile"),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(String title, String value) {
    return ListTile(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value.isNotEmpty ? value : "Not set"),
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignInPage()),
                );
              },
              child: const Text('Sign In'),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: _isLoading ? null : _signInWithGoogle,
              icon: Image.asset('assets/google_logo.png', height: 24, width: 24),
              label: const Text('Sign in with Google'),
            ),
            const SizedBox(height: 10),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignUpPage()),
                );
              },
              child: const Text('Create Account'),
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                _errorMessage!,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}