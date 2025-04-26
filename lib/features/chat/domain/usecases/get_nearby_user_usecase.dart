import 'package:dartz/dartz.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/interest_model.dart';
import 'package:neighborly_flutter_app/features/chat/data/model/nearby_user_model.dart';
import '../../../../core/error/failures.dart';
import '../../data/model/pinned_message_model.dart';
import '../repositories/chat_repositories.dart';

class GetNearByUserUsecase {
  final ChatRepositories repository;

  GetNearByUserUsecase(this.repository);

  Future<Either<Failure, List<NearbyUserModel>>> call() async {
    return await repository.getNearByUser();
  }
}
