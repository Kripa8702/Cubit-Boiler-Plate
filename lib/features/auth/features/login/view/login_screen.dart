import 'package:cubit_boiler_plate/constants/form_values.dart';
import 'package:cubit_boiler_plate/features/auth/cubit/auth_cubit.dart';
import 'package:cubit_boiler_plate/features/auth/widget/auth_base_screen.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_button.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_text_form_field.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController =
      TextEditingController(text: FormValues.username);
  final TextEditingController _passwordController =
      TextEditingController(text: FormValues.password);
  final _formKey = GlobalKey<FormState>();

  void Function() submitForm(BuildContext context) {
    return () {
      FocusScope.of(context).unfocus();
      if (_formKey.currentState!.validate()) {
        context.read<AuthCubit>().signIn(
              email: _emailController.text.trim(),
              password: _passwordController.text.trim(),
            );
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return AuthBaseScreen(
          title: 'Welcome back!',
          body: Form(
            key: _formKey,
            child: Column(
              children: [
                const Spacer(),
                CustomTextFormField(
                  controller: _emailController,
                  labelText: 'Username',
                  hintText: 'Enter username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Username is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 25.h),
                CustomTextFormField(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter password',
                  obscureText: true,
                  textInputAction: TextInputAction.done,
                  textInputType: TextInputType.visiblePassword,
                  onSubmitted: (_) {
                    submitForm(context)();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "* Password is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // TODO: Implement Forgot Password Functionality
                    },
                    child: Text(
                      'Forgot Password?',
                      style: Styles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                          decoration: TextDecoration.underline,
                          decorationColor: primaryColor),
                    ),
                  ),
                ),
                const Spacer(),
                CustomButton(
                  text: 'Login',
                  isLoading: state.loginStatus == AuthStatus.loading,
                  onPressed: submitForm(context),
                ),
                SizedBox(height: 14.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Don’t have an account?',
                      style:
                          Styles.bodyMedium.copyWith(color: tertiaryTextColor),
                    ),
                    TextButton(
                      onPressed: () {
                        //TODO: Implement Create Account/SignUp Functionality
                      },
                      child: Text(
                        'Create account',
                        style: Styles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
