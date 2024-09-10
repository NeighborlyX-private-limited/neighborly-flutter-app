import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../repositories/community_repositories.dart';

class CreateCommunityUsecase {
  final CommunityRepositories repository;

  CreateCommunityUsecase(this.repository);

  Future<Either<Failure, String>> call(
      {required CommunityModel community, File? pictureFile}) async {
    return await repository.createCommunity(
      community: community,
      pictureFile: pictureFile,
    );
  }
}
