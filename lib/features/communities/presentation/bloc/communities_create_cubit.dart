import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../../upload/domain/usecases/upload_file_usecase.dart';
import '../../domain/usecases/create_community_usecase.dart';

part 'communities_create_state.dart';

class CommunityCreateCubit extends Cubit<CommunityCreateState> {
  final CreateCommunityUsecase createCommunityUsecase;
  final UploadFileUsecase uploadFileUsecase;

  CommunityCreateCubit(
    this.createCommunityUsecase,
    this.uploadFileUsecase,
  ) : super(const CommunityCreateState());

  void init() async {}

  Future onUpdateFile(File fileToUpload) async {
    emit(state.copyWith(uploadIsLoading: true));
    var result = await uploadFileUsecase(file: fileToUpload);

    print('...BLOC onUpdateFile start');

    result.fold(
      (failure) {
        print('...BLOC onUpdateFile error: ${failure.message}');
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
            uploadIsLoading: false));
      },
      (imageUrl) {
        print('... BLOC imageUrl=$imageUrl');
        emit(state.copyWith(
            imageToUpload: fileToUpload,
            imageUrl: imageUrl,
            uploadIsLoading: false));
      },
    );
  }

  Future createCommunity(CommunityModel newCommunity, File? pictureFile) async {
    emit(state.copyWith(status: Status.loading));
    final result = await createCommunityUsecase(
        community: newCommunity.copyWith(avatarUrl: state.imageUrl));

    result.fold(
      (failure) {
        emit(state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message));
      },
      (newCommunityId) {
        emit(state.copyWith(
            status: Status.success, newCommunityId: newCommunityId));
      },
    );
  }
}
