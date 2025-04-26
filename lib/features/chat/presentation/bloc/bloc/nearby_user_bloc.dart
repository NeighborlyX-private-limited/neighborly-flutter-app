import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/model/nearby_user_model.dart';
import '../../../domain/entities/interest_entity.dart';
import '../../../domain/entities/nearby_user_entity.dart';
import '../../../domain/usecases/get_all_interests_usecase.dart';
import '../../../domain/usecases/get_nearby_user_usecase.dart';

part 'nearby_user_event.dart';
part 'nearby_user_state.dart';

class NearbyUserBloc extends Bloc<NearbyUserEvent, NearbyUserState> {
  final GetNearByUserUsecase _getNearByUserUsecase;
  NearbyUserBloc({
    required GetNearByUserUsecase getNearByUserUsecase,
  })  : _getNearByUserUsecase = getNearByUserUsecase,
        super(NearbyUserInitialState()) {
    on<FeatchNearbyUserEvent>(
      (FeatchNearbyUserEvent event, Emitter<NearbyUserState> emit) async {
        emit(NearbyUserLoadingState());

        final result = await _getNearByUserUsecase.call();

        result.fold(
          (error) {
            emit(NearbyUserFailureState(error: error.toString()));
          },
          (nearbyUser) {
            emit(NearbyUserSuccessState(nearbyUser: nearbyUser));
          },
        );
      },
    );
  }
}
