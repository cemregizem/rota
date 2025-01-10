// Reusable Elevated Button Widget
import 'package:flutter/material.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final bool isDelivered;
  const CommonElevatedButton({
    Key? key,
    required this.onPressed,
    required this.label,
    required this.isDelivered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(
          isDelivered ? Colors.green : Colors.blue,
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}