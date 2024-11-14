import 'package:equatable/equatable.dart';

class CacheException extends Equatable implements Exception {
  final String message;

  const CacheException({this.message = 'Cache Exception'});

  @override
  List<Object> get props => [message];
  @override
  String toString() => message;
}

class ServerException extends Equatable implements Exception {
  final String message;

  const ServerException({required this.message});

  @override
  List<Object> get props => [message];
  @override
  String toString() => message;
}

class NetworkException extends Equatable implements Exception {
  final String message;

  const NetworkException({this.message = 'Network Exception'});

  @override
  List<Object> get props => [message];
  @override
  String toString() => message;
}
