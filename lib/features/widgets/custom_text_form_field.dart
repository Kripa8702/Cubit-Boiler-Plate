import 'package:cubit_boiler_plate/constants/assets_constants.dart';
import 'package:cubit_boiler_plate/features/widgets/custom_image_view.dart';
import 'package:cubit_boiler_plate/theme/colors.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.alignment,
    this.width,
    this.scrollPadding,
    this.controller,
    this.focusNode,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.hintText,
    this.labelText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = false,
    this.validator,
    this.onChanged,
    this.onSubmitted,
  });

  final Alignment? alignment;

  final double? width;

  final TextEditingController? scrollPadding;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final String? labelText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final Function(String)? onChanged;

  final Function(String)? onSubmitted;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    return widget.alignment != null
        ? Align(
            alignment: widget.alignment ?? Alignment.center,
            child: textFormFieldWidget(context),
          )
        : textFormFieldWidget(context);
  }

  Widget textFormFieldWidget(BuildContext context) => SizedBox(
        width: widget.width ?? double.maxFinite,
        child: Column(
          children: [
            if (widget.labelText != null)
              Padding(
                padding: EdgeInsets.only(
                  bottom: 14.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(widget.labelText!, style: Styles.bodyMedium),
                ),
              ),
            TextFormField(
              inputFormatters: [
                LengthLimitingTextInputFormatter(
                  widget.textInputType == TextInputType.phone ? 10 : null,
                ),
              ],
              scrollPadding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              controller: widget.controller,
              cursorColor: primaryColor,
              autofocus: widget.autofocus!,
              style: widget.textStyle ?? Styles.bodyMedium.copyWith(
                color: primaryTextColor,
              ),
              obscureText:
                  (widget.obscureText ?? false) ? !passwordVisible : false,
              textInputAction: widget.textInputAction,
              keyboardType: widget.textInputType,
              textCapitalization: widget.textInputType == TextInputType.name
                  ? TextCapitalization.words
                  : TextCapitalization.none,
              maxLines: widget.maxLines ?? 1,
              decoration: decoration,
              validator: widget.validator,
              onChanged: widget.onChanged,
              onFieldSubmitted: widget.onSubmitted,
            ),
          ],
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: widget.hintText ?? "",
        hintStyle: widget.hintStyle ??
            Styles.bodyMedium.copyWith(color: tertiaryTextColor),
        prefixIcon: widget.prefix,
        prefixIconConstraints: widget.prefixConstraints,
        suffixIcon: (widget.obscureText ?? false)
            ? Padding(
                padding: EdgeInsets.only(
                  right: 8.w,
                ),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                  icon: CustomImageView(
                    imagePath:
                        passwordVisible ? passwordHideIcon : passwordShowIcon,
                    height: 20.h,
                    color: tertiaryTextColor,
                  ),
                ),
              )
            : (widget.suffix),
        suffixIconConstraints: widget.suffixConstraints,
        isDense: true,
        contentPadding: widget.contentPadding ??
            EdgeInsets.symmetric(
              vertical: 16.h,
              horizontal: 22.w,
            ),
        fillColor: widget.fillColor,
        filled: widget.filled,
        errorStyle: Styles.bodySmall.copyWith(
          color: errorColor,
        ),
        errorBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.h),
              borderSide: const BorderSide(
                color: errorColor,
                width: 1,
              ),
            ),
        border: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.h),
              borderSide: const BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
        enabledBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.h),
              borderSide: const BorderSide(
                color: borderColor,
                width: 1,
              ),
            ),
        focusedBorder: widget.borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(50.h),
              borderSide: const BorderSide(
                color: primaryColor,
                width: 1,
              ),
            ),
      );
}
