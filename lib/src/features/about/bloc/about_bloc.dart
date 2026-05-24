import 'package:bookify/src/core/errors/platform_exception/platform_exception.dart';
import 'package:bookify/src/core/models/app_version_model.dart';
import 'package:bookify/src/core/services/app_services/app_version_service/app_version_service.dart';
import 'package:bookify/src/shared/enums/platform_error_code.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'about_event.dart';
part 'about_state.dart';

class AboutBloc extends Bloc<AboutEvent, AboutState> {
  final AppVersionService _appVersionService;

  AboutBloc(this._appVersionService) : super(AboutLoadingState()) {
    on<GotAppVersionEvent>(_getAppVersionEvent);
  }

  Future<void> _getAppVersionEvent(
    GotAppVersionEvent event,
    Emitter<AboutState> emit,
  ) async {
    try {
      emit(AboutLoadingState());
      final appVersion = await _appVersionService.getAppVersion();
      emit(AboutLoadedState(appVersionModel: appVersion));
    } on PlatformException catch (e) {
      emit(
        AboutErrorState(
          errorCode: e.code,
          errorDescriptionMessage: e.descriptionMessage,
        ),
      );
    } on Exception catch (e) {
      emit(
        AboutErrorState(
          errorCode: PlatformErrorCode.unknown,
          errorDescriptionMessage: e.toString(),
        ),
      );
    }
  }
}
