import 'package:bookify/src/features/profile/bloc/profile_bloc.dart';
import 'package:bookify/src/features/profile/views/widgets/profile_loaded_state_widget.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:bookify/src/shared/widgets/item_state_widget/info_item_state_widget/info_item_state_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final ProfileBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<ProfileBloc>()
      ..add(
        GotUserProfileEvent(),
      );
  }

  Widget _getWidgetOnProfileState(BuildContext context, ProfileState state) {
    return switch (state) {
      ProfileLoadingState() => const CenterCircularProgressIndicator(),
      ProfileLoadedState(:final userModel) => ProfileLoadedStateWidget(
          userModel: userModel,
        ),
      ProfileErrorState(:final errorMessage) =>
        InfoItemStateWidget.withErrorState(
          message: errorMessage,
          onPressed: _refreshPage,
        ),
    };
  }

  void _refreshPage() {
    _bloc.add(
      GotUserProfileEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileBloc, ProfileState>(
        bloc: _bloc,
        builder: _getWidgetOnProfileState,
      ),
    );
  }
}
