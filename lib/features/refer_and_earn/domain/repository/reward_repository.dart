// lib/domain/repositories/reward_repository.dart

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../data/model/request_history_model.dart';
import '../../data/model/reward_model.dart';

abstract class RewardRepository {
  Future<RewardModel> getRewardDetails();
  Future<RewardRequestHistoryModel> getRequestHistory();
  Future<String> withdrawAmount(int amount, String upiId);
  Future<String> submitInvite(String inviteCode);

  // Future<List<RewardRequestHistoryModel>> getRequestHistory();
}
