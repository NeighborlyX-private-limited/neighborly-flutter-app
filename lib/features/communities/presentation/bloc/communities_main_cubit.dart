import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/constants/status.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/models/community_model.dart';
import '../../domain/usecases/get_all_communities_usecase.dart';
part 'communities_main_state.dart';

class CommunityMainCubit extends Cubit<CommunityMainState> {
  final GetAllCommunitiesUsecase getAllCommunitiesUseCase;
  CommunityMainCubit(this.getAllCommunitiesUseCase)
      : super(const CommunityMainState());

  void init() async {
    await getAllCommunities();
  }

  /// get all community cubit
  Future getAllCommunities() async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllCommunitiesUseCase();
    print('result in get all community cubit:$result');
    result.fold(
      (failure) {
        print('fold error in get all community cubit:${failure.message}');
        emit(
          state.copyWith(
            status: Status.failure,
            failure: failure,
            errorMessage: failure.message,
          ),
        );
      },
      (list) {
        print('fold list:$list');
        emit(
          state.copyWith(
            status: Status.success,
            communities: list,
          ),
        );
      },
    );
  }

  /// it is no longer required
  // Future<void> updateNearBy(bool newValue) async {
  //   await getAllCommunities(true, newValue);
  // }

  /// it is no longer required
  // Future<void> updateIsSummary(
  //   bool isSummary,
  //   bool isNearBy,
  // ) async {
  //   await getAllCommunities(
  //     isSummary,
  //     isNearBy,
  //   );
  // }
}
