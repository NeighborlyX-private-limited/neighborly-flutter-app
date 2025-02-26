import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';

// UPLOAD POST
abstract class UploadRepositories {
  Future<Either<Failure, void>> uploadPost({
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
  // UPLOAD FILE
  Future<Either<Failure, String>> uploadFile({required File file});
}
