import 'package:flutter/material.dart';

// You'll likely want to move your authentication logic to a separate service.
// For this example, we'll keep it simple.
class AuthService {
  bool _isLoggedIn = false; // Simulate login state

  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    // Simulate network request
    await Future.delayed(const Duration(seconds: 1));
    // In a real app, you would validate credentials here
    _isLoggedIn = true;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(seconds: 1));
    _isLoggedIn = false;
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService(); // Instantiate your auth service
  bool _isLoading = false;

  // Method to handle login
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    // In a real app, you'd get email/password from TextFormFields
    await _authService.login("test@example.com", "password");
    setState(() {
      _isLoading = false;
    });
  }

  // Method to handle logout
  Future<void> _logout() async {
    setState(() {
      _isLoading = true;
    });
    await _authService.logout();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        actions: [
          if (_authService.isLoggedIn)
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: _isLoading ? null : _logout,
            ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : _authService.isLoggedIn
            ? _buildProfileView()
            : _buildLoginView(),
      ),
    );
  }

  Widget _buildProfileView() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.person, size: 80),
        SizedBox(height: 16),
        Text(
          "Welcome, User!", // Replace with actual user data
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          "user@example.com", // Replace with actual user data
          style: TextStyle(fontSize: 16),
        ),
        SizedBox(height: 20),
        // Add more profile information here
      ],
    );
  }

  Widget _buildLoginView() {
    // You would typically have TextFormField widgets for email and password here
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        const Text(
          "Please Log In",
          style: TextStyle(fontSize: 20),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: _isLoading ? null : _login,
          child: const Text("Login"),
        ),
        // Add TextFormFields for email and password, and a proper form
      ],
    );
  }
}// import 'package:flutter/material.dart';
//
// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("My Profile")),
//       body: const Center(
//         child: Text(
//           "This is the Profile Page",
//           style: TextStyle(fontSize: 18),
//         ),
//       ),
//     );
//   }
// }
