import 'package:flutter/material.dart';

class DesignPage extends StatefulWidget {
  const DesignPage({super.key});

  @override
  State<DesignPage> createState() => _DesignPageState();
}

class _DesignPageState extends State<DesignPage> {
  String? _garmentType;
  Color _primaryColor = Colors.blue; // Default color
  String? _selectedFabricType; // Added for fabric dropdown
  String? _fabricDescription;
  String? _patternDescription;
  String? _textToAdd;
  String? _garmentView = 'Front View'; // Default view
  String? _overallStyle;

  final _formKey = GlobalKey<FormState>();

  // Options for dropdowns
  final List<String> _garmentTypeOptions = ['T-Shirt', 'Dress', 'Hoodie', 'Trousers', 'Skirt'];
  // Updated fabric options list
  final List<String> _fabricTypeOptions = ['Cotton', 'Denim', 'Silk', 'Leather', 'Wool', 'Velvet', 'Other'];
  final List<String> _garmentViewOptions = ['Front View', 'Back View', 'Side View', 'On a Mannequin', 'Flat Lay'];

  // Placeholder for the generated image
  Widget _generatedImagePlaceholder() {
    return Container(
      height: 250,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 20.0),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[400]!),
      ),
      child: Center(
        child: Icon(
            Icons.photo_size_select_actual_outlined,
            size: 50,
            color: Colors.grey
        ),
      ),
    );
  }

  void _onGenerateImagePressed() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print('Generating image with the following parameters:');
      print('Garment Type: $_garmentType');
      print('Selected Base Fabric: ${_selectedFabricType ?? 'Not Specified'}'); // Added
      print('Primary Color: $_primaryColor');
      print('Fabric Description: $_fabricDescription');
      print('Pattern Description: $_patternDescription');
      print('Text to Add: $_textToAdd');
      print('Garment View: $_garmentView');
      print('Overall Style: $_overallStyle');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image generation request sent (simulated)')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      appBar: AppBar(
        title: const Text('Customize Your Design', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Describe Your Vision', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),

              // Garment Type Dropdown
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Garment Type'),
                value: _garmentType,
                hint: const Text('Select Garment Type', style: TextStyle(color: Colors.grey)),
                dropdownColor: const Color(0xFF2C2C2C),
                style: const TextStyle(color: Colors.white),
                items: _garmentTypeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _garmentType = newValue;
                  });
                },
                validator: (value) => value == null ? 'Please select a garment type' : null,
                onSaved: (value) => _garmentType = value,
              ),
              const SizedBox(height: 16),

              // Base Fabric Type Dropdown
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Base Fabric Type (Optional)'),
                value: _selectedFabricType,
                hint: const Text('Select Base Fabric', style: TextStyle(color: Colors.grey)),
                dropdownColor: const Color(0xFF2C2C2C),
                style: const TextStyle(color: Colors.white),
                items: _fabricTypeOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFabricType = newValue;
                  });
                },
                // No validator for optional field
                onSaved: (value) => _selectedFabricType = value,
              ),
              const SizedBox(height: 16),

              // Fabric Description
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Fabric Description (e.g., "Smooth Cotton", "Corduroy")'),
                onSaved: (value) => _fabricDescription = value,
                validator: (value) => value == null || value.isEmpty ? 'Please describe the fabric' : null,
              ),
              const SizedBox(height: 16),

              // Pattern Description
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Pattern (e.g., "Blue Stripes", "Floral Print")'),
                onSaved: (value) => _patternDescription = value,
              ),
              const SizedBox(height: 16),

              // Text to Add
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Text to Add (Optional)'),
                onSaved: (value) => _textToAdd = value,
              ),
              const SizedBox(height: 16),

              // Primary Color (Simple placeholder - a real app would use a color picker)
              Text('Primary Color: (Placeholder - Tap to change - Not implemented)', style: TextStyle(color: Colors.white70)),
              Container(
                height: 50,
                color: _primaryColor,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
              ),
              const SizedBox(height: 16),

              // Garment View Dropdown
              DropdownButtonFormField<String>(
                decoration: _inputDecoration('Garment View'),
                value: _garmentView,
                dropdownColor: const Color(0xFF2C2C2C),
                style: const TextStyle(color: Colors.white),
                items: _garmentViewOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _garmentView = newValue;
                  });
                },
                onSaved: (value) => _garmentView = value,
              ),
              const SizedBox(height: 16),

              // Overall Style/Mood
              TextFormField(
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Overall Style/Mood (e.g., "Vintage Formal", "Cyberpunk Casual")'),
                onSaved: (value) => _overallStyle = value,
              ),
              const SizedBox(height: 24),

              _generatedImagePlaceholder(),
              
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurpleAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: _onGenerateImagePressed,
                  child: const Text('Generate Image', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(height: 16),
               Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () {
                     ScaffoldMessenger.of(context).showSnackBar(
                       const SnackBar(content: Text('Place Order button pressed (Not implemented)')),
                     );
                  },
                  child: const Text('Place Order', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.white70),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.white38),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.deepPurpleAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent),
        borderRadius: BorderRadius.circular(8.0),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      filled: true,
      fillColor: const Color(0xFF2C2C2C),
    );
  }
}
