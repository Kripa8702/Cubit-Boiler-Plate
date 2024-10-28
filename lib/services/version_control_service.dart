import 'dart:io';

import 'package:cubit_boiler_plate/constants/api_path.dart';
import 'package:cubit_boiler_plate/exceptions/api_exception.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_button.dart';
import 'package:cubit_boiler_plate/models/app_update.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:cubit_boiler_plate/utils/dio_client.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class VersionControlService {
  VersionControlService({required this.dioClient});

  static AppDetails? update;
  static String privacyPolicyLink = '';
  static String termsAndConditions = '';

  final DioClient dioClient;

  Future<AppDetails> init() async {
    try {
      final response = await dioClient.get(
        ApiPath.getDetails,
      );

      final appUpdate = AppDetails.fromJson(response);
      privacyPolicyLink = appUpdate.privacyPolicyLink;
      termsAndConditions = appUpdate.termsAndConditionsLink;

      return appUpdate;
    } on ApiException catch (e) {
      ColoredLogs.error(e.message);
      throw ApiException(e.message);
    } catch (e) {
      ColoredLogs.error(e.toString());
      rethrow;
    }
  }

  static void openAppStore(AppDetails details) {
    launchUrlString(Platform.isAndroid ? details.urlAndroid : details.urlIos);
  }

  static Future<void> showUpgradeDialog({
    required BuildContext context,
    required AppDetails details,
    required Function() onPop,
  }) async {
    return showModalBottomSheet(
      context: context,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: containerColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 25.h),
                Text(
                  'NEW UPDATE AVAILABLE',
                  style: Styles.labelMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),
                Text(
                  'Update your application to the latest version',
                  style: Styles.titleLarge,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                Text(
                  'Version: ${details.version}',
                  style: Styles.labelMedium.copyWith(
                    color: primaryColor.withOpacity(0.8),
                  ),
                ),
                SizedBox(height: 30.h),
                Expanded(
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'What\'s New:',
                            style: Styles.bodyMedium
                          ),
                          Text(
                            details.changeLog,
                            style: Styles.bodyMedium,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                const Divider(
                  color: borderColor
                ),
                SizedBox(height: 20.h),
                CustomButton(
                  text: "Update",
                  onPressed: () => openAppStore(details),
                ),
                Center(
                  child: TextButton(
                    onPressed: () {
                      if (details.force) {
                        exit(0);
                      } else {
                        Navigator.pop(context);
                        onPop();
                      }
                    },
                    child: Text(
                      details.force ? 'No Thanks! Close the App' : 'Dismiss',
                      style: Styles.labelSmall.copyWith(
                        color: primaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
