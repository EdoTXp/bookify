import 'package:bookify/src/features/profile/views/widgets/user_information_row/bloc/user_information_bloc.dart';
import 'package:bookify/src/features/profile/views/widgets/user_information_row/item_status_column.dart';
import 'package:bookify/src/shared/widgets/center_circular_progress_indicator/center_circular_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:localization/localization.dart';

class UserInformationRow extends StatefulWidget {
  const UserInformationRow({
    super.key,
  });

  @override
  State<UserInformationRow> createState() => _UserInformationRowState();
}

class _UserInformationRowState extends State<UserInformationRow> {
  late final UserInformationBloc _bloc;

  @override
  void initState() {
    _bloc = context.read<UserInformationBloc>()
      ..add(
        GotUserInformationEvent(),
      );
    super.initState();
  }

  Widget _getWidgetOnUserInformationState(
    BuildContext context,
    UserInformationState state,
  ) {
    return switch (state) {
      UserInformationLoadingState() => const CenterCircularProgressIndicator(),
      UserInformationLoadedState(
        :final bookCount,
        :final bookcasesCount,
        :final loansCount,
        :final readingsCount,
      ) =>
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          textBaseline: TextBaseline.alphabetic,
          children: [
            ItemStatusColumn(
              quantity: bookcasesCount,
              label: bookcasesCount == 1
                  ? 'bookcase-label'.i18n()
                  : 'bookcases-label'.i18n(),
            ),
            const SizedBox(
              width: 5,
            ),
            ItemStatusColumn(
              quantity: bookCount,
              label:
                  bookCount == 1 ? 'book-label'.i18n() : 'books-label'.i18n(),
            ),
            const SizedBox(
              width: 5,
            ),
            ItemStatusColumn(
              quantity: loansCount,
              label:
                  loansCount == 1 ? 'loan-label'.i18n() : 'loans-label'.i18n(),
            ),
            const SizedBox(
              width: 5,
            ),
            ItemStatusColumn(
              quantity: readingsCount,
              label: readingsCount == 1
                  ? 'reading-label'.i18n()
                  : 'readings-label'.i18n(),
            ),
          ],
        ),
      UserInformationErrorState() => Center(
          child: Text(
            'error-on-loading-data'.i18n(),
            style: TextStyle(
              fontSize: 10,
            ),
          ),
        ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserInformationBloc, UserInformationState>(
      bloc: _bloc,
      builder: _getWidgetOnUserInformationState,
    );
  }
}
