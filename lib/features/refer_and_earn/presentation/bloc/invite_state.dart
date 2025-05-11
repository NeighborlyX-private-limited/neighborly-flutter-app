abstract class InviteState {}

class InviteInitial extends InviteState {}

class InviteLoading extends InviteState {}

class InviteSuccess extends InviteState {}

class InviteError extends InviteState {
  final String message;
  InviteError(this.message);
}
