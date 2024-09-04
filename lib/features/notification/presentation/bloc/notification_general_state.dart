part of 'notification_general_cubit.dart';

class NotificationGeneralState extends Equatable {
  final Status status;
  final Failure? failure;
  final String? errorMessage; 
  final String? currentFCMtoken; 

  const NotificationGeneralState({
    this.status = Status.initial,
    this.failure,
    this.errorMessage = '',
    this.currentFCMtoken = '', 
   
  });

  @override
  List<Object?> get props => [
        status,
        failure,
        errorMessage,
        currentFCMtoken, 
      ];

  NotificationGeneralState copyWith({
    Status? status,
    Failure? failure,
    String? errorMessage, 
    String? currentFCMtoken, 
  }) {
    return NotificationGeneralState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      errorMessage: errorMessage ?? this.errorMessage, 
      currentFCMtoken: currentFCMtoken ?? this.currentFCMtoken, 
    );
  }
}
