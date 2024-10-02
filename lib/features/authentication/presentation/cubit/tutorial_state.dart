import 'package:flutter/material.dart';

@immutable
abstract class TutorialState {}

class TutorialInitial extends TutorialState {}

class TutorialUpdateLoading extends TutorialState {}

class TutorialUpdateSuccess extends TutorialState {}

class TutorialUpdateFailure extends TutorialState {
  final String error;
  TutorialUpdateFailure(this.error);
}
