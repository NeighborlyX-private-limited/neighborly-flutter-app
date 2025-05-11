abstract class RewardRemoteDataSource {
  Future<Map<String, dynamic>> getRewardDetails();
  Future<Map<String, dynamic>> getRequestHistory();
  Future<String> withdrawAmmount(int amount, String upiId);
  Future<String> submitInvite(String inviteCode);
}
