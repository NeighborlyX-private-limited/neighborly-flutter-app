import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/edit_profile_usecase.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  final EditProfileUsecase _editProfileUsecase;

  EditProfileBloc({required EditProfileUsecase editProfileUsecase})
      : _editProfileUsecase = editProfileUsecase,
        super(EditProfileInitialState()) {
    on<EditProfileButtonPressedEvent>((
      EditProfileButtonPressedEvent event,
      Emitter<EditProfileState> emit,
    ) async {
      emit(EditProfileLoadingState());

      final result = await _editProfileUsecase.call(
        username: event.username,
        gender: event.gender,
        phoneNumber: event.phoneNumber,
        toggleFindMe: event.toggleFindMe,
        // homeCoordinates: event.homeCoordinates,
        bio: event.bio,
        image: event.image,
      );
      print('...Result in EditProfileBloc $result');

      result.fold((error) {
        print('fold error: ${error.toString()}');
        emit(EditProfileFailureState(error: error.toString()));
      }, (response) {
        // print('fold response: ${response.toString()}');
        emit(EditProfileSuccessState());
      });
    });
  }
}
