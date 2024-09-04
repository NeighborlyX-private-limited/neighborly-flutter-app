part of 'get_my_groups_bloc.dart';

abstract class GetMyGroupsEvent extends Equatable {}

class GetMyGroupsButtonPressedEvent extends GetMyGroupsEvent {
  final String? userId;
  GetMyGroupsButtonPressedEvent({
    this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
      ];
}
