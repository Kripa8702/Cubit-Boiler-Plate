import 'package:cubit_boiler_plate/constants/assets_constants.dart';
import 'package:cubit_boiler_plate/features/auth/cubit/auth_cubit.dart';
import 'package:cubit_boiler_plate/features/splash/cubit/splash_cubit.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_image_view.dart';
import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:cubit_boiler_plate/services/navigator_service.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SplashCubit>().init(context);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            Future.delayed(
              const Duration(seconds: 2),
              () {
                NavigatorService.go(
                  state.authenticationStatus == AuthStatus.success
                      ? AppRouting.homePath
                      : AppRouting.authPath,
                );
              },
            );
          },
        ),
        BlocListener<SplashCubit, SplashState>(
          listener: (context, state) {
            if (state.status == SplashStatus.updateNotRequired) {
              context.read<AuthCubit>().initAuth();
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomImageView(
                imagePath: appLogo,
                height: 100.h,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
