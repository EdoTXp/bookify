import 'package:bookify/src/features/about/bloc/about_bloc.dart';
import 'package:bookify/src/features/about/views/widgets/about_loaded_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class AboutPage extends StatefulWidget {
  /// The Route Name = '/about'
  static const routeName = '/about';

  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  late final AboutBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<AboutBloc>()..add(GotAppVersionEvent());
  }

  Widget _getWidgetOnAboutState(BuildContext context, AboutState state) {
    return switch (state) {
      AboutLoadingState() => const CenterCircularProgressIndicator(),
      AboutLoadedState(appVersionModel: final appVersion) =>
        AboutLoadedStateWidget(appVersionModel: appVersion),
      AboutErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(GotAppVersionEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'about-label'.i18n(),
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: BlocBuilder<AboutBloc, AboutState>(
        bloc: _bloc,
        builder: _getWidgetOnAboutState,
      ),
    );
  }
}
