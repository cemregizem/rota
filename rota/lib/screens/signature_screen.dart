import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';
import 'package:rota/services/delivery_service.dart';
import 'package:signature/signature.dart';
import 'package:rota/providers/signature_provider.dart';


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
   final deliveryService = DeliveryService();
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
                     await deliveryService.saveSignature(
                    context,
                    ref,
                    signatureController,
                    customer,
                    onSave,
                  );
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
