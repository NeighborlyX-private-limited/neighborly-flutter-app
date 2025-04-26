import 'package:equatable/equatable.dart';

class InterestEntity extends Equatable {
  final List<String> availableInterests;
  final List<String> userInterests;

  const InterestEntity({
    required this.availableInterests,
    required this.userInterests,
  });

  @override
  List<Object?> get props => [availableInterests, userInterests];
}
