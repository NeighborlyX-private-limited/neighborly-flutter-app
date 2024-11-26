import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> params) async {
    return await remoteDataSource.createOrder(params);
  }

  @override
  Future<bool> verifyPayment(Map<String, dynamic> params) async {
    return await remoteDataSource.verifyPayment(params);
  }
}
