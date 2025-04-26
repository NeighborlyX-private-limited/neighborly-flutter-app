part of 'create_dm_bloc.dart';

abstract class CreateDmEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateNewDmEvent extends CreateDmEvent {
  final String userId;

  CreateNewDmEvent({
    required this.userId,
  });

  @override
  List<Object?> get props => [
        userId,
      ];
}
