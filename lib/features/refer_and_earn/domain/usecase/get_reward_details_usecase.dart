// lib/domain/usecases/get_reward_details_usecase.dart

import '../../data/model/reward_model.dart';

import '../repository/reward_repository.dart';

class GetRewardDetailsUseCase {
  final RewardRepository repository;

  GetRewardDetailsUseCase(this.repository);

  Future<RewardModel> call() async {
    return await repository.getRewardDetails();
  }
}
