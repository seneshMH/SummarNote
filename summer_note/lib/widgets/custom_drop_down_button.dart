import 'package:flutter/material.dart';
import 'package:summer_note/core/app_export.dart';

class CustomDropDownButton extends StatelessWidget {
  CustomDropDownButton({
    Key? key,
    this.alignment,
    this.width,
    this.focusNode,
    this.icon,
    this.autofocus = true,
    this.textStyle,
    this.items,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.onTap,
  }) : super(
          key: key,
        );

  final Alignment? alignment;
  final double? width;
  final FocusNode? focusNode;
  final Widget? icon;
  final bool? autofocus;
  final TextStyle? textStyle;
  final List<String>? items;
  final String? hintText;
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
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buttonWidget,
          )
        : buttonWidget;
  }

  Widget get buttonWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            backgroundColor: fillColor ?? theme.colorScheme.secondaryContainer,
            padding: contentPadding ??
                EdgeInsets.only(
                  top: 5.v,
                  right: 5.h,
                  bottom: 5.v,
                ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.h),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (prefix != null) ...[
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: prefix!,
                ),
              ],
              Expanded(
                child: Text(
                  hintText ?? "",
                  overflow: TextOverflow.ellipsis,
                  style: hintStyle ?? CustomTextStyles.titleLargeInterSemiBold,
                ),
              ),
              if (suffix != null) ...[
                Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: suffix!,
                ),
              ],
            ],
          ),
        ),
      );
}
