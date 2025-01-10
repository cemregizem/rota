import 'package:flutter/material.dart';

class CommonTextFormField extends StatelessWidget {
  final String label;
  final String? initialValue;
  final Function(String) onChanged;
  final String? Function(String?)? validator;
  final bool obscureText; // Add this line to handle obscureText

  const CommonTextFormField({
    Key? key,
    required this.label,
    this.initialValue,
    required this.onChanged,
    this.validator,
    this.obscureText = false, // Default to false if not provided
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      obscureText: obscureText, // Use the obscureText parameter
      onChanged: onChanged,
      validator: validator,
    );
  }
}
