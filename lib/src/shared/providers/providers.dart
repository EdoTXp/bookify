import 'package:bookify/src/shared/providers/repositories/repositories_providers.dart';
import 'package:bookify/src/shared/providers/services/services.dart';
import 'package:bookify/src/shared/providers/views/views_providers.dart';
import 'package:provider/single_child_widget.dart';

class Providers {
  static final List<SingleChildStatelessWidget> providers = [
    ...localDatabaseRepositoriesProviders,
    ...userSettingsStorageProviders,
    ...appServicesProviders,
    ...userSettingsServicesProviders,
    ...servicesProviders,
    ...userThemeProviders,
    ...authPageProviders,
    ...homePageProviders,
    ...profilePageProviders,
    ...bookDetailPageProviders,
    ...bookcasePageProviders,
    ...bookcaseInsertionPageProviders,
    ...bookcaseDetailPageProviders,
    ...bookOnBookcaseDetailPageProviders,
    ...bookcaseBooksInsertionProviders,
    ...loanPageProviders,
    ...loanDetailPageProviders,
    ...loanInsertionPageProviders,
    ...readingsPageProviders,
    ...readingsInsertionPageProviders,
    ...readingsDetailPageProviders,
    ...myBooksProviders,
    ...contactsPickerProviders,
    ...booksPickerProviders,
  ];
}
