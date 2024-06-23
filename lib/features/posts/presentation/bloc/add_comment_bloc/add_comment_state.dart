part of 'add_comment_bloc.dart';

abstract class AddCommentState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AddCommentInitialState extends AddCommentState {
  AddCommentInitialState();
}

class AddCommentLoadingState extends AddCommentState {
  AddCommentLoadingState();
}

class AddCommentSuccessState extends AddCommentState {
  AddCommentSuccessState();
}

class AddCommentFailureState extends AddCommentState {
  final String error;
  AddCommentFailureState({required this.error});
}
