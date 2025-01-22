import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../domain/usecases/join_community_usecase.dart';
import '../../../domain/usecases/leave_community_usecase.dart';
part 'join_group_event.dart';
part 'join_group_state.dart';

class JoinGroupBloc extends Bloc<JoinGroupEvent, JoinGroupState> {
  final JoinCommunityUsecase _joinCommunityUsecase;
  final LeaveCommunityUsecase _leaveCommunityUsecase;

  JoinGroupBloc(
      {required JoinCommunityUsecase joinCommunityUsecase,
      required LeaveCommunityUsecase leaveCommunityUsecase})
      : _joinCommunityUsecase = joinCommunityUsecase,
        _leaveCommunityUsecase = leaveCommunityUsecase,
        super(JoinGroupInitialState()) {
    /// join group event trigger
    on<JoinGroupButtonPressedEvent>(
      (JoinGroupButtonPressedEvent event, Emitter<JoinGroupState> emit) async {
        emit(JoinGroupLoadingState());

        final result = await _joinCommunityUsecase.call(
          communityId: event.communityId,
          userId: null,
        );

        result.fold(
          (error) {
            emit(JoinGroupFailureState(error: error.toString()));
          },
          (response) {
            emit(JoinGroupSuccessState());
          },
        );
      },
    );

    /// leave group event trigger
    on<LeaveGroupButtonPressedEvent>(
      (LeaveGroupButtonPressedEvent event, Emitter<JoinGroupState> emit) async {
        emit(JoinGroupLoadingState());

        final result = await _leaveCommunityUsecase.call(
          communityId: event.communityId,
          userId: null,
        );

        result.fold(
          (error) {
            emit(JoinGroupFailureState(error: error.toString()));
          },
          (response) {
            emit(LeaveGroupSuccessState());
          },
        );
      },
    );
  }
}
