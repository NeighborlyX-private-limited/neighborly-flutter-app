import 'dart:io';

abstract class UploadRemoteDataSource {
  Future<void> uploadPost({
    required String title,
    String? content,
    required String type,
    String? multimedia,
    required List<num> location,
    required String city,
    List<dynamic>? options,
    bool? allowMultipleVotes,
  });

  Future<String> uploadFile({required File file});
}
