import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/make_admin_community_usecase.dart';
import 'package:neighborly_flutter_app/features/communities/domain/usecases/remove_admin_community_usecase.dart';
part 'make_remove_admin_event.dart';
part 'make_remove_admin_state.dart';

class MakeRemoveAdminBloc
    extends Bloc<MakeRemoveAdminEvent, MakeRemoveAdminState> {
  final MakeAdminCommunityUsecase _makeAdminCommunityUsecase;
  final RemoveAdminCommunityUsecase _removeAdminCommunityUsecase;

  MakeRemoveAdminBloc(
      {required MakeAdminCommunityUsecase makeAdminCommunityUsecase,
      required RemoveAdminCommunityUsecase removeAdminCommunityUsecase})
      : _makeAdminCommunityUsecase = makeAdminCommunityUsecase,
        _removeAdminCommunityUsecase = removeAdminCommunityUsecase,
        super(MakeRemoveAdminInitialState()) {
    /// make admin event trigger
    on<MakeAdminButtonPressedEvent>(
      (MakeAdminButtonPressedEvent event,
          Emitter<MakeRemoveAdminState> emit) async {
        emit(MakeRemoveAdminLoadingState());

        final result = await _makeAdminCommunityUsecase.call(
          communityId: event.communityId,
          userId: event.userId,
        );
        print('...Result in MakeAdminBloc $result');

        result.fold(
          (error) {
            print('fold error in MakeAdminBloc: ${error.toString()}');
            emit(MakeRemoveAdminFailureState(error: error.toString()));
          },
          (response) {
            print('fold success response in MakeAdminBloc}');
            emit(MakeAdminSuccessState());
          },
        );
      },
    );

    ///remove admin event trigger
    on<RemoveAdminButtonPressedEvent>(
      (RemoveAdminButtonPressedEvent event,
          Emitter<MakeRemoveAdminState> emit) async {
        emit(MakeRemoveAdminLoadingState());

        final result = await _removeAdminCommunityUsecase.call(
          communityId: event.communityId,
          userId: event.userId,
        );
        print('...Result in RemoveAdminBloc: $result');

        result.fold(
          (error) {
            print('fold error in RemoveAdminBloc: ${error.toString()}');
            emit(MakeRemoveAdminFailureState(error: error.toString()));
          },
          (response) {
            print('fold success response in RemoveAdminBloc}');
            emit(RemoveAdminSuccessState());
          },
        );
      },
    );
  }
}
