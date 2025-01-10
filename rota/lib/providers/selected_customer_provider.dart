import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rota/models/customer.dart';

final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);
