import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';

import '../repository/reward_repository.dart';

// import '../repositories/withdraw_repository.dart';

class WithdrawUseCase {
  final RewardRepository repository;

  WithdrawUseCase(this.repository);

  Future<String> call(int amount, String upiId) {
    return repository.withdrawAmount(amount, upiId);
  }
}
