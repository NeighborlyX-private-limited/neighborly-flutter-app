abstract class PaymentRepository {
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> params);
  Future<bool> verifyPayment(Map<String, dynamic> params);
}
