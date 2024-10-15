import 'dart:io';

abstract class UploadRemoteDataSource {
  Future<void> uploadPost({
    required String title,
    required List<double> location,
    String? content,
    required String type,
    List<File>? multimedia,
    // File? multimedia,
    required String city,
    List<dynamic>? options,
    required bool allowMultipleVotes,
  });

  Future<String> uploadFile({required File file});
}
