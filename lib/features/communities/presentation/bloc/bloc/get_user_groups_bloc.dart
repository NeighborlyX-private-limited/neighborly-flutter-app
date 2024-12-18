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
    /// get user group event trigger
    on<GetUserGroupsButtonPressedEvent>(
      (GetUserGroupsButtonPressedEvent event,
          Emitter<GetUserGroupsState> emit) async {
        emit(GetUserGroupsLoadingState());

        final result = await _getUserGroupsUsecase.call();
        print('...Result in GetUserGroupsBloc: $result');

        result.fold(
          (error) {
            print('fold error in GetUserGroupsBloc: ${error.toString()}');
            emit(GetUserGroupsFailureState(error: error.toString()));
          },
          (communities) {
            print('fold success response in GetUserGroupsBloc}');
            emit(GetUserGroupsSuccessState(communities: communities));
          },
        );
      },
    );
  }
}
