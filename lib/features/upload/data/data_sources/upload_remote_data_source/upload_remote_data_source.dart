abstract class UploadRemoteDataSource {
  Future<void> uploadPost(
      { String? content,
      String? title,
      String? multimedia,
      required List<num> location});
}
