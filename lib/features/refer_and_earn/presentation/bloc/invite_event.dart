abstract class InviteEvent {}

class SubmitInviteEvent extends InviteEvent {
  final String inviteCode;
  SubmitInviteEvent(this.inviteCode);
}
