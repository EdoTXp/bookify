import 'package:bookify/src/shared/providers/data_sources/remote_books_data_source_providers.dart';
import 'package:bookify/src/shared/providers/repositories/repositories_providers.dart';
import 'package:bookify/src/shared/providers/rest_client/rest_client_providers.dart';
import 'package:bookify/src/shared/providers/services/services.dart';
import 'package:bookify/src/shared/providers/blocs/blocs_providers.dart';
import 'package:provider/single_child_widget.dart';

abstract class Providers {
  Providers._();

  static final List<SingleChildStatelessWidget> providers = [
    ...localDatabaseRepositoriesProviders,
    ...userSettingsStorageProviders,
    ...appServicesProviders,
    ...userSettingsServicesProviders,
    ...servicesProviders,
    ...userThemeBlocProviders,
    ...userInformationBlocProviders,
    ...authBlocProviders,
    ...readingPageTimerBlocProviders,
    ...programmingReadingBlocProviders,
    ...restClientProvider,
    ...remoteBooksDataSourceProviders,
    ...remoteBooksRepositoryProviders,
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
