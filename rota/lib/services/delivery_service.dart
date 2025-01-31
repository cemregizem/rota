import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/providers/customer_delivered_provider.dart';
import 'package:rota/providers/user_provider.dart';
import 'package:rota/screens/signature_screen.dart';
import 'package:rota/components/bottom_sheet.dart';

class DeliveryService {
  static Future<void> markAsDelivered(
      BuildContext context, WidgetRef ref, Customer customer) async {
    await DeliveryBottomSheet.show(
      context,
      onCameraTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camera option selected')),
        );
      },
      onSignatureTap: () {
        Navigator.pop(context);
        Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SignatureScreen(
                onSave: (signatureUrl) async {
                  final updatedCustomer =
                      customer.copyWith(deliverStatus: true);
                  await ref.read(
                      customerDeliverStatusProvider(updatedCustomer).future);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Signature saved! URL: $signatureUrl')),
                  );
                },
              ),
            ),
          );
        });
      },
    );

    final updatedCustomer = customer.copyWith(deliverStatus: true);
    await ref.read(customerDeliverStatusProvider(updatedCustomer).future);
    await ref.read(userProvider.notifier).incrementDeliveredPackageCount();

    await Future.delayed(const Duration(seconds: 2));
    if (context.mounted) {
      Navigator.pop(context);
    }
  }
}
