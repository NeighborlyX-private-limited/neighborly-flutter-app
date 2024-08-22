import 'package:equatable/equatable.dart';

class UserSimpleEntity extends Equatable {
  final String id;
  final String name;
  final String avatarUrl; 
  final bool? isAdmin;
  final num? karma;

  const UserSimpleEntity({
    required this.id,
    required this.name,
    required this.avatarUrl, 
    this.isAdmin, 
    this.karma, 
  });

  @override
  List<Object?> get props => [
        id,
        name, 
      ];



}
