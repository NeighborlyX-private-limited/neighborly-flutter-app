part of 'get_gender_and_DOB_bloc.dart';

abstract class GetGenderAndDOBState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetGenderAndDOBInitialState extends GetGenderAndDOBState {
  GetGenderAndDOBInitialState();
}

class GetGenderAndDOBLoadingState extends GetGenderAndDOBState {
  GetGenderAndDOBLoadingState();
}

class GetGenderAndDOBSuccessState extends GetGenderAndDOBState {
  GetGenderAndDOBSuccessState();
}

class GetGenderAndDOBFailureState extends GetGenderAndDOBState {
  final String error;
  GetGenderAndDOBFailureState({required this.error});
}
