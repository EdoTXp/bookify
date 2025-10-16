part of 'about_bloc.dart';

sealed class AboutState {}

final class AboutLoadingState extends AboutState {}

final class AboutLoadedState extends AboutState {
  final AppVersionModel appVersionModel;

  AboutLoadedState({
    required this.appVersionModel,
  });
}

final class AboutErrorState extends AboutState {
  final String errorMessage;

  AboutErrorState({
    required this.errorMessage,
  });
}
