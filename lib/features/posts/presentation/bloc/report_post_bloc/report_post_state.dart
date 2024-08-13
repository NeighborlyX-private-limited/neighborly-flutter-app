part of 'report_post_bloc.dart';

abstract class ReportPostState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReportPostInitialState extends ReportPostState {
  ReportPostInitialState();
}

class ReportPostLoadingState extends ReportPostState {
  ReportPostLoadingState();
}

class ReportPostSuccessState extends ReportPostState {
  ReportPostSuccessState();
}

class ReportPostFailureState extends ReportPostState {
  final String error;
  ReportPostFailureState({required this.error});
}
