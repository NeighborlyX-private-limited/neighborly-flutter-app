import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/unblock_user_community_usecase.dart';

part 'update_block_user_event.dart';
part 'update_block_user_state.dart';

class UpdateBlockUserBloc
    extends Bloc<UpdateBlockUserEvent, UpdateBlockUserState> {
  final UnblockUserCommunityUsecase _unblockUserCommunityUsecase;

  UpdateBlockUserBloc({
    required UnblockUserCommunityUsecase unblockUserCommunityUsecase,
  })  : _unblockUserCommunityUsecase = unblockUserCommunityUsecase,
        super(UpdateBlockUserInitialState()) {
    on<UpdateBlockUserButtonPressedEvent>(
      (UpdateBlockUserButtonPressedEvent event,
          Emitter<UpdateBlockUserState> emit) async {
        emit(UpdateBlockUserLoadingState());

        final result = await _unblockUserCommunityUsecase.call(
          communityId: event.communityId,
          userId: event.userId,
          isBlock: event.isBlock,
        );

        result.fold(
          (error) {
            emit(UpdateBlockUserFailureState(error: error.toString()));
          },
          (message) {
            emit(UpdateBlockSuccessState(message: message));
          },
        );
      },
    );
  }
}
