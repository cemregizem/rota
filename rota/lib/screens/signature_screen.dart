import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:signature/signature.dart';
import 'package:rota/providers/signature_provider.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignatureScreen extends ConsumerWidget {
  final Function(String imageUrl) onSave;
  final Customer customer;

  const SignatureScreen(
      {super.key, required this.onSave, required this.customer});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signatureController = ref.watch(signatureControllerProvider);
    //watch() ile widget rebuild olduğunda otomatik güncellenmesini sağlıyoruz.
//Böylece read() yerine sürekli güncel veriyi kullanıyoruz.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF244D3E),
        title: const Text('Signature', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF244D3E),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 500, // Adjust height as needed
                  color: Colors.white,
                  child: Signature(
                    controller: signatureController,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  signatureController.clear();
                },
                child: const Text('Clear'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (signatureController.isNotEmpty) {
                    final signatureImage = await signatureController.toImage();
                    final byteData = await signatureImage!
                        .toByteData(format: ImageByteFormat.png);
                    final buffer = byteData!.buffer.asUint8List();

                    // Check if the widget is still mounted
                    if (!context.mounted) return;

                    // Upload the signature to Firebase Storage
                    final storageRef = FirebaseStorage.instance
                        .ref()
                        .child('signatures/${customer.id}.png');
                    await storageRef.putData(buffer);
                    final signatureUrl = await storageRef.getDownloadURL();

                    // Save the signature URL to the customer's record in Firebase Realtime Database
                    final database = FirebaseDatabase.instance.ref(
                        'rotaData/${ref.read(firebaseAuthProvider).currentUser!.uid}/customers/${customer.id}');
                    await database.update({
                      'signatureUrl': signatureUrl,
                    });

                    // Call the onSave callback with the signature URL
                    onSave(signatureUrl);

                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please provide a signature')),
                    );
                  }
                },
                child: const Text('Save'),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
