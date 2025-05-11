// lib/data/repositories/reward_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/data/data_source/reward_remote_data_source.dart';
import 'package:neighborly_flutter_app/features/refer_and_earn/data/model/reward_model.dart';

import '../../../profile/data/data_sources/profile_remote_data_source/profile_remote_data_source.dart';
import '../../domain/repository/reward_repository.dart';
import '../data_source/reward_remote_data_source_impl.dart';
import '../model/request_history_model.dart';

class RewardRepositoryImpl implements RewardRepository {
  // final ApiService apiService;
  final RewardRemoteDataSource remoteDataSource;

  RewardRepositoryImpl(this.remoteDataSource);

  @override
  Future<RewardModel> getRewardDetails() async {
    final response = await remoteDataSource.getRewardDetails();
    return RewardModel.fromJson(response);
  }

  @override
  Future<RewardRequestHistoryModel> getRequestHistory() async {
    // Future<List<RewardRequestHistoryModel>> getRequestHistory() async {
    final response = await remoteDataSource.getRewardDetails();
    return RewardRequestHistoryModel.fromJson(response);
  }

  @override
  Future<String> withdrawAmount(int amount, String upiId) async {
    final response = await remoteDataSource.withdrawAmmount(amount, upiId);
    return response;
  }

  @override
  Future<String> submitInvite(String inviteCode) async {
    final response = await remoteDataSource.submitInvite(inviteCode);
    return response;
  }
  // @override
  // Future<Either<Failure, String>> withdrawAmount(
  //     int amount, String upiId) async {
  //   try {
  //     final response = await remoteDataSource.withdrawAmmount(amount, upiId);
  //     return Right(response); // Wrap success string inside Right
  //   } catch (e) {
  //     return Left(Failure( message:e.toString())); // Wrap error inside Left
  //   }
  // }
}
