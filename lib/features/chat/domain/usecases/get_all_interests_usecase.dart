import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/interest_model.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/pinned_message_model.dart';
import '../repositories/chat_repositories.dart';

class GetAllInterestsUsecase {
  final ChatRepositories repository;

  GetAllInterestsUsecase(this.repository);

  Future<Either<Failure, InterestModel>> call() async {
    return await repository.getAllInterests();
  }
}
