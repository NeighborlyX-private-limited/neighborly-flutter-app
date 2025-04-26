import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/interest_model.dart';

import '../../../../core/error/failures.dart';
import '../repositories/chat_repositories.dart';

class SaveUserInterestsUsecase {
  final ChatRepositories repository;

  SaveUserInterestsUsecase(this.repository);

  Future<Either<Failure, void>> call(
      {required List<String> userInterest}) async {
    return await repository.saveUserInterest(userInterest: userInterest);
  }
}
