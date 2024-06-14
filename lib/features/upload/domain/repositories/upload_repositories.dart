import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/core/error/failures.dart';

abstract class UploadRepositories {
  Future<Either<Failure, void>> uploadPost({
    String? title,
    String? content,
    String? multimedia,
    required List<num> location,
  });
}
