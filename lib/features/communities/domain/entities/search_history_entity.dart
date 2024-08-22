 

import 'package:equatable/equatable.dart';

class SearchHistoryEntity extends Equatable{
  final String term;
  
  SearchHistoryEntity({
    required this.term,
  });

  
  @override 
  List<Object?> get props => [term];
}
