import '../repositories/payment_repository.dart';

class VerifyPaymentUseCase {
  final PaymentRepository repository;

  VerifyPaymentUseCase({required this.repository});

  Future<bool> call(Map<String, dynamic> params) {
    return repository.verifyPayment(params);
  }
}
