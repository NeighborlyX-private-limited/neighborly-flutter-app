import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/post_repositories.dart';

class ReportPostUsecase {
  final PostRepositories repository;

  ReportPostUsecase(this.repository);

  Future<Either<Failure, void>> call(
      {required String reason,
      required String type,
      required num postId}) async {
    return await repository.reportPost(
      reason: reason,
      type: type,
      postId: postId,
    );
  }
}
