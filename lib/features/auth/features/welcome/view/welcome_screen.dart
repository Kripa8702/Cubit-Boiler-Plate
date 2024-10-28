import 'package:cubit_boiler_plate/features/auth/cubit/auth_cubit.dart';
import 'package:cubit_boiler_plate/features/widgets/base_screen.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_button.dart';
import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:cubit_boiler_plate/services/navigator_service.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      verticalPadding: 40,

      /// For any custom background (like image background), use the below code
      // background: SizedBox(
      //   height: double.maxFinite,
      //   width: double.maxFinite,
      //   child: Stack(
      //     children: [
      //       CustomImageView(
      //         imagePath: welcomeBg,
      //         // height: double.maxFinite,
      //         width: double.maxFinite,
      //       ),
      //       Container(
      //         height: double.maxFinite,
      //         width: double.maxFinite,
      //         decoration: BoxDecoration(
      //           gradient: LinearGradient(
      //             begin: Alignment.bottomCenter,
      //             end: Alignment.topCenter,
      //             colors: const [
      //               backgroundColor,
      //               Colors.transparent,
      //             ],
      //             stops: [0.22.h, 1.0],
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // ),

      /// Auth Cubit added due to possibility of social login
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          return Column(
            children: [
              _buildPageHeader(context),
              SizedBox(height: 150.h),
              Text(
                "Get in through",
                style:
                Styles.titleMedium.copyWith(color: primaryColor),
              ),
              SizedBox(height: 33.h),
              CustomButton(
                text: "Sign Up",
                onPressed: () {
                  // NavigatorService.pushNamed(
                  //   AppRoutes.signupScreen,
                  // );
                },
              ),
              SizedBox(height: 14.h),
              CustomButton(
                text: "Login",
                onPressed: () {
                  NavigatorService.push(
                    AppRouting.loginPath,
                  );
                },
              ),
              SizedBox(height: 5.h)
            ],
          );
        },
      ),
    );
  }

  /// Section Widget
  Widget _buildPageHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Welcome to our community",
          overflow: TextOverflow.ellipsis,
          style: Styles.titleLarge,
        ),
        SizedBox(height: 10.h),
        Text(
          "Our community is ready to help you to join our best platform",
          style: Styles.bodyLarge,
        )
      ],
    );
  }
}
