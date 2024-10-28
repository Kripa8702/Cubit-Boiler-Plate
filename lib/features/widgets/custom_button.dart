import 'package:cubit_boiler_plate/features/widgets/custom_image_view.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.buttonTextStyle,
    this.height,
    this.width,
    this.isLoading,
    this.leadingIcon,
    this.buttonBackgroundColor,
    this.buttonBorderColor,
  });

  final String text;
  final VoidCallback? onPressed;
  final TextStyle? buttonTextStyle;
  final double? height;
  final double? width;
  final bool? isLoading;
  final String? leadingIcon;
  final Color? buttonBackgroundColor;
  final Color? buttonBorderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 50.h,
      width: width ?? double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonBackgroundColor ?? primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.h),
            side: BorderSide(
              color: buttonBorderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
        ),
        child: isLoading ?? false
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: backgroundColor,
                  strokeWidth: 2,
                ),
              )
            : leadingIcon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomImageView(
                        imagePath: leadingIcon,
                        height: 24.h,
                      ),
                      SizedBox(width: 14.w),
                      Text(
                        text,
                        style: buttonTextStyle ??
                            Styles.labelLarge.copyWith(color: backgroundColor),
                      ),
                    ],
                  )
                : Text(
                    text,
                    style: buttonTextStyle ??
                        Styles.labelLarge.copyWith(color: backgroundColor),
                  ),
      ),
    );
  }
}
