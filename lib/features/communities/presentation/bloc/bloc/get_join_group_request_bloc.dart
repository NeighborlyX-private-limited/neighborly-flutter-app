import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/add_user_community_usecase.dart';

import '../../../data/model/group_join_request_model.dart';
import '../../../domain/usecases/get_join_group_request_usecase.dart';

part 'get_join_group_request_event.dart';
part 'get_join_group_request_state.dart';

class GetJoinGroupRequestBloc
    extends Bloc<GetJoinGroupRequestEvent, GetJoinGroupRequestState> {
  final GetJoinGroupRequestUsecase _getJoinGroupRequestUsecase;

  GetJoinGroupRequestBloc({
    required GetJoinGroupRequestUsecase getJoinGroupRequestUsecase,
  })  : _getJoinGroupRequestUsecase = getJoinGroupRequestUsecase,
        super(GetJoinGroupRequestInitialState()) {
    on<FeatchJoinGroupRequestEvent>(
      (FeatchJoinGroupRequestEvent event,
          Emitter<GetJoinGroupRequestState> emit) async {
        emit(GetJoinGroupRequestLoadingState());

        final result = await _getJoinGroupRequestUsecase.call(
          communityId: event.communityId,
        );

        result.fold(
          (error) {
            emit(GetJoinGroupRequestFailureState(error: error.toString()));
          },
          (response) {
            emit(GetJoinGroupRequestSuccessState(communities: response));
          },
        );
      },
    );
  }
}
