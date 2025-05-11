// lib/data/models/reward_model.dart

class RewardModel {
  final int totalRewardReceived;
  final int withdrawableReward;
  final bool eligibleForSignUpReward;
  final bool receivedSignupReward;
  final dynamic validPostStatus;
  final List<UserModel> usersReferred;
  final ReferrerModel? referrer;

  RewardModel({
    required this.totalRewardReceived,
    required this.withdrawableReward,
    required this.eligibleForSignUpReward,
    required this.receivedSignupReward,
    required this.validPostStatus,
    required this.usersReferred,
    required this.referrer,
  });

  factory RewardModel.fromJson(Map<String, dynamic> json) {
    return RewardModel(
      totalRewardReceived: json['totalRewardRecieved'] ?? 0,
      withdrawableReward: json['withdrawableReward'] ?? 0,
      eligibleForSignUpReward: json['eligibleForSignUpReward'] ?? false,
      receivedSignupReward: json['receivedSignupReward'] ?? false,
      validPostStatus: json['validPostStatus'],
      usersReferred: List.from(json['usersReferred'] ?? [])
          .map((e) => UserModel.fromJson(e))
          .toList(),
      referrer: json['referrer'] != null
          ? ReferrerModel.fromJson(json['referrer'])
          : null,
    );
  }
}

class UserModel {
  final String username;
  final String picture;
  final bool isSuccessfulReferral;

  UserModel({
    required this.username,
    required this.picture,
    required this.isSuccessfulReferral,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'],
      picture: json['picture'],
      isSuccessfulReferral: json['isSuccessfulReferral'],
    );
  }
}

class ReferrerModel {
  final String username;
  final String picture;

  ReferrerModel({
    required this.username,
    required this.picture,
  });

  factory ReferrerModel.fromJson(Map<String, dynamic> json) {
    return ReferrerModel(
      username: json['username'],
      picture: json['picture'],
    );
  }
}
