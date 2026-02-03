import 'package:get/get.dart';

abstract class PaymentService extends GetxService {
  Future<bool> processPayment(double amount);
}

class MockPaymentService extends PaymentService {
  @override
  Future<bool> processPayment(double amount) async {
    await Future.delayed(const Duration(seconds: 2));
    // Simulate successful payment
    return true;
  }
}

// Example of how a Stripe implementation would look
class StripePaymentService extends PaymentService {
  @override
  Future<bool> processPayment(double amount) async {
    // Stripe SDK logic here
    throw UnimplementedError("Stripe integration not yet implemented");
  }
}
