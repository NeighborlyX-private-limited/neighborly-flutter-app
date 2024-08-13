import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/domain/usecases/get_my_groups_usecase.dart';

part 'get_my_groups_event.dart';
part 'get_my_groups_state.dart';

class GetMyGroupsBloc extends Bloc<GetMyGroupsEvent, GetMyGroupsState> {
  final GetMyGroupUsecase _getMyGroupsUsecase;

  GetMyGroupsBloc({required GetMyGroupUsecase getMyGroupsUsecase})
      : _getMyGroupsUsecase = getMyGroupsUsecase,
        super(GetMyGroupsInitialState()) {
    on<GetMyGroupsButtonPressedEvent>((GetMyGroupsButtonPressedEvent event,
        Emitter<GetMyGroupsState> emit) async {
      emit(GetMyGroupsLoadingState());

      final result = await _getMyGroupsUsecase.call(
        userId: event.userId,
      );

      result.fold(
          (error) => emit(GetMyGroupsFailureState(error: error.toString())),
          (response) => emit(GetMyGroupsSuccessState(groups: response)));
    });
  }
}
