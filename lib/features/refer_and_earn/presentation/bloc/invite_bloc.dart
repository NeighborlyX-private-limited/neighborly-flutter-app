import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecase/invite_usecase.dart';
// import '../../domain/usecases/invite_usecase.dart';
import 'invite_event.dart';
import 'invite_state.dart';

class InviteBloc extends Bloc<InviteEvent, InviteState> {
  final InviteUseCase useCase;

  InviteBloc(this.useCase) : super(InviteInitial()) {
    on<SubmitInviteEvent>(_onSubmitInvite);
  }

  Future<void> _onSubmitInvite(
      SubmitInviteEvent event, Emitter<InviteState> emit) async {
    emit(InviteLoading());
    try {
      final result = await useCase(event.inviteCode);
      // final RewardRequestHistoryModel data = await useCase();
      // final List<RewardRequestHistoryModel> data = await useCase();
      emit(InviteSuccess());
    } catch (e) {
      emit(InviteError(e.toString()));
    }

    // result.fold(
    //   (failure) => emit(InviteError(failure.message)),
    //   (_) => emit(InviteSuccess()),
    // );
  }
}
