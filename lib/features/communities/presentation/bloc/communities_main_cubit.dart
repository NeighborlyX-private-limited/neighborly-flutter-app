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
    await getAllCommunities(true, false);
  }

  Future getAllCommunities(bool isSummary, bool isNearBy) async {
    emit(state.copyWith(status: Status.loading));
    final result = await getAllCommunitiesUseCase(
      isSummary: isSummary,
      isNearBy: isNearBy,
    );

    print('result :$result');
    result.fold(
      (failure) {
        print('fold error:${failure.message}');
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

  Future<void> updateNearBy(bool newValue) async {
    await getAllCommunities(true, newValue);
  }

  Future<void> updateIsSummary(
    bool isSummary,
    bool isNearBy,
  ) async {
    print('...BLOC isSummary=$isSummary isNearBy=$isNearBy');
    await getAllCommunities(isSummary, isNearBy);
  }
}
