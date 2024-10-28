import 'package:cubit_boiler_plate/config/build_config.dart';
import 'package:cubit_boiler_plate/exceptions/api_exception.dart';
import 'package:cubit_boiler_plate/models/app_update.dart';
import 'package:cubit_boiler_plate/services/version_control_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(const SplashState());

  Future<void> init(BuildContext context) async {
    emit(state.copyWith(status: SplashStatus.loading));
    try {
      /// Add your API call in the repository and call here
      // final appDetails = await repository.getAppDetails();

      /// The format of the response should be like this
      final appDetails = AppDetails(
        buildNumber: 1,
        version: '1.0.0',
        changeLog: 'Change Log',
        urlAndroid: 'https://www.google.com',
        urlIos: 'https://www.google.com',
        force: false,
        privacyPolicyLink: 'https://www.google.com',
        termsAndConditionsLink: 'https://www.google.com',
      );

      emit(state.copyWith(
        privacyPolicyUrl: appDetails.privacyPolicyLink,
        termsAndConditionsUrl: appDetails.termsAndConditionsLink,
      ));

      if (appDetails.buildNumber > BuildConfig.buildNo) {
        Future.delayed(const Duration(seconds: 1), () {
          VersionControlService.showUpgradeDialog(
            context: context,
            details: appDetails,
            onPop: () {
              emit(state.copyWith(
                status: SplashStatus.updateNotRequired,
              ));
            },
          );
        });


        emit(state.copyWith(
          status: SplashStatus.updateRequired,
        ));
      } else {
        Future.delayed(const Duration(seconds: 1), () {
          emit(state.copyWith(
            status: SplashStatus.updateNotRequired,
          ));
        });

      }
    } on ApiException {
      emit(state.copyWith(
        status: SplashStatus.updateNotRequired,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SplashStatus.updateNotRequired,
      ));
    }
  }
}