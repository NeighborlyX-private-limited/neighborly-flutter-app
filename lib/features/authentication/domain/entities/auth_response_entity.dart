import 'package:equatable/equatable.dart';

class AuthResponseEntity extends Equatable {
  final String id;
  final String username;
  final String token;
  

  const AuthResponseEntity({
    required this.id,
    required this.username,
    required this.token,
    
  });

  @override
  List<Object?> get props => [
        id,
        username,
        token,
  ];
}
