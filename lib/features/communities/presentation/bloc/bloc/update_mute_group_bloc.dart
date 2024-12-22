import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/update_mute_community_usecase.dart';

part 'update_mute_group_event.dart';
part 'update_mute_group_state.dart';

// class UpdateMuteGroupBloc extends Bloc<UpdateMuteGroupEvent, UpdateMuteGroupState> {
//   UpdateMuteGroupBloc() : super(UpdateMuteGroupInitial()) {
//     on<UpdateMuteGroupEvent>((event, emit) {
//       // TODO: implement event handler
//     });
//   }
// }

class UpdateMuteGroupBloc
    extends Bloc<UpdateMuteGroupEvent, UpdateMuteGroupState> {
  final UpdateMuteCommunityUsecase _updateMuteCommunityUsecase;

  UpdateMuteGroupBloc({
    required UpdateMuteCommunityUsecase updateMuteCommunityUsecase,
  })  : _updateMuteCommunityUsecase = updateMuteCommunityUsecase,
        super(UpdateMuteGroupInitialState()) {
    on<UpdateMuteGroupButtonPressedEvent>(
      (UpdateMuteGroupButtonPressedEvent event,
          Emitter<UpdateMuteGroupState> emit) async {
        emit(UpdateMuteGroupLoadingState());

        final result = await _updateMuteCommunityUsecase.call(
          communityId: event.communityId,
          isMute: event.isMute,
        );
        print('...Result in UpdateMuteGroupBloc: $result');

        result.fold(
          (error) {
            print('fold error in UpdateMuteGroupBloc: ${error.toString()}');
            emit(UpdateMuteGroupFailureState(error: error.toString()));
          },
          (message) {
            print('fold success response in UpdateBlockUserBloc');
            emit(UpdateMuteGroupSuccessState());
          },
        );
      },
    );
  }
}
