import 'package:dartz/dartz.dart';

import '../repository/reward_repository.dart';
// import '../repositories/invite_repository.dart';
// import '../../../../core/error/failure.dart';

class InviteUseCase {
  final RewardRepository repository;

  InviteUseCase(this.repository);

  Future<String> call(String inviteCode) {
    return repository.submitInvite(inviteCode);
  }
}
