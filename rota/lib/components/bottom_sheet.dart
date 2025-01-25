import 'package:flutter/material.dart';

class DeliveryBottomSheet {
  static Future<void> show(BuildContext context,
      {required Function onCameraTap, required Function onSignatureTap}) async {
    await showModalBottomSheet(
      context: context,
     // isDismissible: false, // Prevent dismissal by tapping outside
     // enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Complete Delivery',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Use Camera'),
                onTap: () {
                  onCameraTap();
                  Navigator.pop(context);
                },
                  
                  
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.edit),
                title: const Text('Use Signature'),
                onTap: () {
                  
                  onSignatureTap();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
