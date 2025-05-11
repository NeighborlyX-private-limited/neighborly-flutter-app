// lib/domain/usecases/get_reward_details_usecase.dart

import '../../data/model/request_history_model.dart';
import '../../data/model/reward_model.dart';

import '../repository/reward_repository.dart';

class GetRequestHistoryUseCase {
  final RewardRepository repository;

  GetRequestHistoryUseCase(this.repository);

  Future<RewardRequestHistoryModel> call() async {
    // Future<List<RewardRequestHistoryModel>> call() async {
    return await repository.getRequestHistory();
  }
}
