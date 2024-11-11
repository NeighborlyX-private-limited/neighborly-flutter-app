import 'package:equatable/equatable.dart';

class SearchHistoryEntity extends Equatable {
  final String term;

  const SearchHistoryEntity({
    required this.term,
  });

  @override
  List<Object?> get props => [term];
}
