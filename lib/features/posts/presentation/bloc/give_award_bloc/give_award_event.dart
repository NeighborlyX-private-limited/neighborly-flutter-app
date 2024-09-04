part of 'give_award_bloc.dart';

abstract class GiveAwardEvent extends Equatable {}

class GiveAwardButtonPressedEvent extends GiveAwardEvent {
  final num id;
  final String type;
  final String awardType;

  GiveAwardButtonPressedEvent({
    required this.id,
    required this.type,
    required this.awardType,
  });

  @override
  List<Object?> get props => [id, type, awardType];
}
