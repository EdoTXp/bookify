part of 'about_bloc.dart';

sealed class AboutState {}

final class AboutLoadingState extends AboutState {}

final class AboutLoadedState extends AboutState {
  final AppVersion appVersion;

  AboutLoadedState({
    required this.appVersion,
  });
}

final class AboutErrorState extends AboutState {
  final String errorMessage;

  AboutErrorState({
    required this.errorMessage,
  });
}
