// lib/screens/edit_profile.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecfc/screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  final User user;
  const EditProfilePage({super.key, required this.user});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  final _addressController = TextEditingController();
  String? _gender;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      _nameController.text = (data['name'] ?? '').toString();
      _dobController.text = (data['dob'] ?? '').toString();
      _addressController.text = (data['address'] ?? '').toString();
      _gender = (data['gender'] ?? '') == '' ? null : data['gender'];
      setState(() {});
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.user.uid)
        .set({
      'name': _nameController.text.trim(),
      'dob': _dobController.text.trim(),
      'address': _addressController.text.trim(),
      'gender': _gender,
      'email': widget.user.email,     // keep email in the doc too
      'updatedAt': DateTime.now(),
    }, SetOptions(merge: true));

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context); // go back to ProfilePage (view)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 15),

              DropdownButtonFormField<String>(
                value: _gender,
                items: const ['Male', 'Female', 'Other']
                    .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                    .toList(),
                onChanged: (val) => setState(() => _gender = val),
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null ? 'Please select gender' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _dobController,
                readOnly: true,
                decoration: const InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2000),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    _dobController.text =
                    '${picked.day}/${picked.month}/${picked.year}';
                  }
                },
                validator: (v) =>
                (v == null || v.isEmpty) ? 'Please select date of birth' : null,
              ),
              const SizedBox(height: 15),

              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 24),

              // Save button
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    _saveProfile(); // <-- call the function
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => const ProfilePage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}





// // lib/screens/edit_profile.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ecfc/screens/profile_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
// class EditProfilePage extends StatefulWidget {
//   final User user;
//   const EditProfilePage({super.key, required this.user});
//
//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }
//
// class _EditProfilePageState extends State<EditProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//   final _nameController = TextEditingController();
//   final _dobController = TextEditingController();
//   final _addressController = TextEditingController();
//   String? _gender;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     var doc = await FirebaseFirestore.instance
//         .collection('users')
//         .doc(widget.user.uid)
//         .get();
//
//     if (doc.exists) {
//       var data = doc.data()!;
//       _nameController.text = data['name'] ?? "";
//       _dobController.text = data['dob'] ?? "";
//       _addressController.text = data['address'] ?? "";
//       _gender = data['gender'];
//       setState(() {});
//     }
//   }
//
//   Future<void> _saveProfile() async {
//     if (_formKey.currentState!.validate()) {
//       await FirebaseFirestore.instance
//           .collection('users')
//           .doc(widget.user.uid)
//           .set({
//         'name': _nameController.text,
//         'dob': _dobController.text,
//         'address': _addressController.text,
//         'gender': _gender,
//       }, SetOptions(merge: true));
//
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("Profile updated successfully")),
//         );
//         Navigator.pop(context);
//       }
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Edit Profile")),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _nameController,
//                 decoration: const InputDecoration(labelText: "Full Name"),
//                 validator: (v) =>
//                 v!.isEmpty ? "Please enter your name" : null,
//               ),
//               const SizedBox(height: 15),
//               DropdownButtonFormField<String>(
//                 value: _gender,
//                 items: ["Male", "Female", "Other"]
//                     .map((g) => DropdownMenuItem(value: g, child: Text(g)))
//                     .toList(),
//                 onChanged: (val) => setState(() => _gender = val),
//                 decoration: const InputDecoration(labelText: "Gender"),
//                 validator: (v) => v == null ? "Please select gender" : null,
//               ),
//               const SizedBox(height: 15),
//               TextFormField(
//                 controller: _dobController,
//                 readOnly: true,
//                 decoration: const InputDecoration(
//                   labelText: "Date of Birth",
//                   suffixIcon: Icon(Icons.calendar_today),
//                 ),
//                 onTap: () async {
//                   DateTime? picked = await showDatePicker(
//                     context: context,
//                     initialDate: DateTime(2000),
//                     firstDate: DateTime(1900),
//                     lastDate: DateTime.now(),
//                   );
//                   if (picked != null) {
//                     _dobController.text =
//                     "${picked.day}/${picked.month}/${picked.year}";
//                   }
//                 },
//                 validator: (v) =>
//                 v!.isEmpty ? "Please select date of birth" : null,
//               ),
//               const SizedBox(height: 15),
//               TextFormField(
//                 controller: _addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//                 validator: (v) =>
//                 v!.isEmpty ? "Please enter your address" : null,
//               ),
//               const SizedBox(height: 30),
//               ElevatedButton(
//                 onPressed:(){ _saveProfile();
//                 Navigator.of(context).pushReplacement(
//                   MaterialPageRoute(
//                     builder: (context) => const ProfilePage(),
//                   ),
//                 );},
//                 child: const Text("Save"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
