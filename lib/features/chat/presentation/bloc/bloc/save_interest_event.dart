import 'package:equatable/equatable.dart';

sealed class SaveInterestEvent extends Equatable {
  const SaveInterestEvent();

  @override
  List<Object> get props => [];
}

class SaveUserInterestEvent extends SaveInterestEvent {
  final List<String> userInterests;

  const SaveUserInterestEvent({required this.userInterests});

  @override
  List<Object> get props => [userInterests];
}
