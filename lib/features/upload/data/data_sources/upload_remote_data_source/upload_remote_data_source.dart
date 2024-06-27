import 'dart:io';

abstract class UploadRemoteDataSource {
  Future<void> uploadPost({
    required String title,
    String? content,
    required String type,
    String? multimedia,
    required List<num> location,
    required String city,
  });

  Future<String> uploadFile({required File file});
  Future<void> uploadPoll(
      {required String question, required List<String> options});
}
