import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../repositories/community_repositories.dart';

class UpdateIconCommunityUsecase {
  final CommunityRepositories repository;

  UpdateIconCommunityUsecase(this.repository);

  Future<Either<Failure, void>> call({
    required String communityId,
    File? pictureFile,
    String? imageUrl,
  }) async {
    return await repository.updateIcon(
      communityId: communityId,
      pictureFile: pictureFile,
      imageUrl: imageUrl,
    );
  }
}
