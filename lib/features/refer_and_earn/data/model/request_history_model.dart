class RewardRequestHistoryModel {
  final List<RewardRequestItem> requestsHistory;

  RewardRequestHistoryModel({required this.requestsHistory});

  factory RewardRequestHistoryModel.fromJson(Map<String, dynamic> json) {
    return RewardRequestHistoryModel(
      requestsHistory: (json['requestsHistory'] as List<dynamic>?)
              ?.map((e) => RewardRequestItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class RewardRequestItem {
  final String requestId;
  final String refereeUserId;
  final int amount;
  final String upiId;
  final String? transactionId;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;

  RewardRequestItem({
    required this.requestId,
    required this.refereeUserId,
    required this.amount,
    required this.upiId,
    required this.transactionId,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RewardRequestItem.fromJson(Map<String, dynamic> json) {
    return RewardRequestItem(
      requestId: json['request_id'] as String,
      refereeUserId: json['referee_user_id'] as String,
      amount: json['amount'] as int,
      upiId: json['upi_id'] as String,
      transactionId: json['transaction_id'],
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
