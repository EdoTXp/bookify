import 'package:bookify/src/shared/providers/repositories/repositories_providers.dart';
import 'package:bookify/src/shared/providers/services/services.dart';
import 'package:bookify/src/shared/providers/blocs/blocs_providers.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static final List<SingleChildStatelessWidget> providers = [
    ...localDatabaseRepositoriesProviders,
    ...userSettingsStorageProviders,
    ...appServicesProviders,
    ...userSettingsServicesProviders,
    ...servicesProviders,
    ...userThemeBlocProviders,
    ...userInformationBlocProviders,
    ...authBlocProviders,
    ...readingPageTimeCalculatorBlocProviders,
    ...hourTimeCalculatorBlocProviders,
    ...homeBlocProviders,
    ...profileBlocProviders,
    ...aboutBlocProviders,
    ...notificationsBlocProviders,
    ...bookDetailBlocProviders,
    ...bookPagesReadingTimeBlocProviders,
    ...bookcaseBlocProviders,
    ...bookcaseInsertionBlocProviders,
    ...bookcaseDetailBlocProviders,
    ...bookOnBookcaseDetailBlocProviders,
    ...bookcaseBooksInsertionBlocProviders,
    ...loanBlocProviders,
    ...loanDetailBlocProviders,
    ...loanInsertionBlocProviders,
    ...readingsBlocProviders,
    ...readingsInsertionBlocProviders,
    ...readingsDetailBlocProviders,
    ...readingsTimerBlocProviders,
    ...myBooksBlocProviders,
    ...contactsPickerBlocProviders,
    ...booksPickerBlocProviders,
  ];
}
