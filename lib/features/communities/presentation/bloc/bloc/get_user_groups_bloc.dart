import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/core/models/community_model.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/get_user_groups_usecase.dart';

part 'get_user_groups_event.dart';
part 'get_user_groups_state.dart';

class GetUserGroupsBloc extends Bloc<GetUserGroupsEvent, GetUserGroupsState> {
  final GetUserGroupsUsecase _getUserGroupsUsecase;

  GetUserGroupsBloc({
    required GetUserGroupsUsecase getUserGroupsUsecase,
  })  : _getUserGroupsUsecase = getUserGroupsUsecase,
        super(GetUserGroupsInitialState()) {
    on<GetUserGroupsButtonPressedEvent>(
      (
        GetUserGroupsButtonPressedEvent event,
        Emitter<GetUserGroupsState> emit,
      ) async {
        emit(GetUserGroupsLoadingState());

        final result = await _getUserGroupsUsecase.call();

        result.fold(
          (error) {
            emit(GetUserGroupsFailureState(error: error.toString()));
          },
          (communities) {
            emit(GetUserGroupsSuccessState(communities: communities));
          },
        );
      },
    );
  }
}
