import 'dart:io';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rota/components/bottom_sheet.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/auth_provider.dart';
import 'package:rota/providers/customer_delivered_provider.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/signature_screen.dart';
import 'package:signature/signature.dart';

class DeliveryService {
  Future<void> markAsDelivered(BuildContext context, WidgetRef ref, Customer customer) async {
    await ref.read(customerDeliverStatusProvider(customer).future);

    await DeliveryBottomSheet.show(
      context,
      onCameraTap: () async {
        Navigator.pop(context);
        await handleCameraTap(context, ref, customer);
      },
      onSignatureTap: () {
        Navigator.pop(context);
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignatureScreen(
                onSave: (signatureUrl) async {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signature saved!')),
                  );
                },
                customer: customer,
              ),
            ),
          );
        });
      },
    );

    await ref.read(userProvider.notifier).incrementDeliveredPackageCount();
    if (!context.mounted) return;
    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  Future<void> handleCameraTap(BuildContext context, WidgetRef ref, Customer customer) async {
    final authUser = ref.read(firebaseAuthProvider).currentUser;
    if (authUser == null) return;

    final PermissionStatus status = await Permission.camera.request();
    if (status.isDenied) {
      await Permission.camera.request();
      return;
    }

    final ImagePicker imagePicker = ImagePicker();
    final XFile? image = await imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );

    if (image != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child('photos/${customer.id}.png');
        await storageRef.putFile(File(image.path));
        final photoUrl = await storageRef.getDownloadURL();

        final database = FirebaseDatabase.instance.ref(
          'rotaData/${authUser.uid}/customers/${customer.id}',
        );
        await database.update({'photoUrl': photoUrl});

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Photo saved!')),
          );
        }
      } catch (e) {
        print("Error uploading photo: $e");
      }
    }
  }

    Future<void> saveSignature(
    BuildContext context,
    WidgetRef ref,
    SignatureController signatureController,
    Customer customer,
    Function(String imageUrl) onSave,
  ) async {
    if (signatureController.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a signature')),
      );
      return;
    }

    try {
      final signatureImage = await signatureController.toImage();
      final byteData = await signatureImage!.toByteData(format: ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final storageRef = FirebaseStorage.instance.ref().child('signatures/${customer.id}.png');
      await storageRef.putData(buffer);
      final signatureUrl = await storageRef.getDownloadURL();

      final authUser = ref.read(firebaseAuthProvider).currentUser;
      if (authUser == null) return;

      final database = FirebaseDatabase.instance.ref(
        'rotaData/${authUser.uid}/customers/${customer.id}',
      );
      await database.update({'signatureUrl': signatureUrl});

      onSave(signatureUrl);

      
      signatureController.clear();

      if (context.mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving signature: $e')),
        );
      }
    }
  }
}
