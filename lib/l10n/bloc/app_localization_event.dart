part of 'app_localization_bloc.dart';

sealed class AppLocalizationEvent extends Equatable {
  const AppLocalizationEvent();

  @override
  List<Object> get props => [];
}

class ChangeAppLocalization extends AppLocalizationEvent {
  final Locale selectedLocale;
  const ChangeAppLocalization({required this.selectedLocale});
  @override
  List<Object> get props => [selectedLocale];
}

class GetLocale extends AppLocalizationEvent {}
