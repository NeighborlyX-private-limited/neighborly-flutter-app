import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/add_user_community_usecase.dart';

import '../../../domain/usecases/remove_user_community_usecase.dart';

part 'add_remove_user_in_group_event.dart';
part 'add_remove_user_in_group_state.dart';

// class AddRemoveUserInGroupBloc extends Bloc<AddRemoveUserInGroupEvent, AddRemoveUserInGroupState> {
//   AddRemoveUserInGroupBloc() : super(AddRemoveUserInGroupInitial()) {
//     on<AddRemoveUserInGroupEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

class AddRemoveUserInGroupBloc
    extends Bloc<AddRemoveUserInGroupEvent, AddRemoveUserInGroupState> {
  final AddUserCommunityUsecase _addUserCommunityUsecase;
  final RemoveUserCommunityUsecase _removeUserCommunityUsecase;

  AddRemoveUserInGroupBloc(
      {required AddUserCommunityUsecase addUserCommunityUsecase,
      required RemoveUserCommunityUsecase removeUserCommunityUsecase})
      : _addUserCommunityUsecase = addUserCommunityUsecase,
        _removeUserCommunityUsecase = removeUserCommunityUsecase,
        super(AddRemoveUserInGroupInitialState()) {
    on<AddUserInGroupButtonPressedEvent>(
      (AddUserInGroupButtonPressedEvent event,
          Emitter<AddRemoveUserInGroupState> emit) async {
        emit(AddRemoveUserInGroupLoadingState());

        final result = await _addUserCommunityUsecase.call(
          communityId: event.communityId,
          userId: event.userId,
        );
        print('...Result in AddRemoveUserInGroupBloc $result');

        result.fold(
          (error) {
            print('fold error: ${error.toString()}');
            emit(AddRemoveUserInGroupFailureState(error: error.toString()));
          },
          (response) {
            //  print('fold response: ${response.toString()}');
            emit(AddUserInGroupSuccessState());
          },
        );
      },
    );
    on<RemoveUserInGroupButtonPressedEvent>(
      (RemoveUserInGroupButtonPressedEvent event,
          Emitter<AddRemoveUserInGroupState> emit) async {
        emit(AddRemoveUserInGroupLoadingState());

        final result = await _removeUserCommunityUsecase.call(
          communityId: event.communityId,
          userId: event.userId,
        );
        print('...Result in AddRemoveUserInGroupBloc $result');

        result.fold(
          (error) {
            print('fold error: ${error.toString()}');
            emit(AddRemoveUserInGroupFailureState(error: error.toString()));
          },
          (response) {
            //  print('fold response: ${response.toString()}');
            emit(RemoveUserInGroupSuccessState());
          },
        );
      },
    );
  }
}
