import 'dart:io';

abstract class UploadRemoteDataSource {
  Future<void> uploadPost({
    required String title,
    String? content,
    required String type,
    File? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  });

  Future<String> uploadFile({required File file});
}
