import 'dart:io';

abstract class UploadRemoteDataSource {
  Future<void> uploadPost({
    required String type,
    required String title,
    String? content,
    List<dynamic>? options,
    required bool allowMultipleVotes,
    List<File>? multimedia,
    File? thumbnail,
    required List<double> location,
    required String city,
  });

  Future<String> uploadFile({required File file});
}
