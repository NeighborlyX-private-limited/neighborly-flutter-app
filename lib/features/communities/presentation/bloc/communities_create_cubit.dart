import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../domain/usecases/create_community_usecase.dart';
part 'communities_create_state.dart';

class CommunityCreateCubit extends Cubit<CommunityCreateState> {
  final CreateCommunityUsecase createCommunityUsecase;

  CommunityCreateCubit(
    this.createCommunityUsecase,
  ) : super(const CommunityCreateState());

  ///  create group cubit
  Future createCommunity(
    CommunityModel newCommunity,
    File? pictureFile,
  ) async {
    emit(state.copyWith(status: Status.loading));
    final result = await createCommunityUsecase(
      community: newCommunity,
      pictureFile: pictureFile,
    );
    print('....create group result cubit: $result');

    result.fold(
      (failure) {
        print('...create group failure cubit: ${failure.message}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (newCommunityId) {
        print('....group id create group cubit:$newCommunityId');
        emit(
          state.copyWith(
            status: Status.success,
            newCommunityId: newCommunityId,
          ),
        );
      },
    );
  }
}
