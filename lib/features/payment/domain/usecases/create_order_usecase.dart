import '../repositories/payment_repository.dart';

class CreateOrderUseCase {
  final PaymentRepository repository;

  CreateOrderUseCase({required this.repository});

  Future<Map<String, dynamic>> call(Map<String, dynamic> params) {
    return repository.createOrder(params);
  }
}
