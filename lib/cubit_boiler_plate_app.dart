import 'package:cubit_boiler_plate/features/auth/cubit/auth_cubit.dart';
import 'package:cubit_boiler_plate/features/auth/repository/auth_repository.dart';
import 'package:cubit_boiler_plate/features/splash/cubit/splash_cubit.dart';
import 'package:cubit_boiler_plate/routing/app_routing.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/utils/initialization_repository.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CubitBoilerPlateCode extends StatelessWidget {
  const CubitBoilerPlateCode({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MultiRepositoryProvider(
          providers: [
            RepositoryProvider<InitializationRepository>(
              lazy: true,
              create: (context) => InitializationRepository()..init(),
            ),
            RepositoryProvider<AuthRepository>(
              create: (context) => AuthRepository(
                dioClient: context.read<InitializationRepository>().dioClient,
              ),
            ),
          ],
          child: GestureDetector(
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onVerticalDragDown: (_){
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
                SystemUiOverlay.top,
              ]);
            },
            child: MultiBlocProvider(
              providers: [
                BlocProvider<SplashCubit>(
                  create: (context) => SplashCubit(),
                ),
                BlocProvider<AuthCubit>(
                  create: (context) => AuthCubit(
                    authRepository: context.read<AuthRepository>(),
                  ),
                  child: Container(),
                )
              ],
              child: MaterialApp.router(
                routerConfig: AppRouting.router,
                title: 'Cubit Boiler Plate',
                debugShowCheckedModeBanner: false,
                locale: const Locale('en', ''),
                theme: ThemeData(
                  scaffoldBackgroundColor: backgroundColor,
                  dividerColor: borderColor,
                  primaryColor: primaryColor,
                  fontFamily: 'Open Sans',
                  useMaterial3: true,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
