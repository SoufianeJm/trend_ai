import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

enum ButtonSize { small, normal, large }

enum ButtonVariant { primary, secondary, tertiary, disabled }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonSize size;
  final ButtonVariant variant;
  final TextStyle? textStyle;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.size = ButtonSize.normal,
    this.variant = ButtonVariant.primary,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Determine paddings by size
    final EdgeInsets padding;
    final TextStyle defaultTextStyle;

    switch (size) {
      case ButtonSize.small:
        padding = const EdgeInsets.symmetric(vertical: 4, horizontal: 16);
        defaultTextStyle = AppTypography.bodyRegular12;
        break;
      case ButtonSize.normal:
        padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 16);
        defaultTextStyle = AppTypography.bodyRegular14;
        break;
      case ButtonSize.large:
        padding = const EdgeInsets.symmetric(vertical: 16, horizontal: 16);
        defaultTextStyle = AppTypography.bodyRegular14;
        break;
    }

    // 2. Define style based on variant
    final Color backgroundColor;
    final Color textColor;
    final BorderSide? border;

    switch (variant) {
      case ButtonVariant.primary:
        backgroundColor = Palette.primary;
        textColor = Palette.white;
        border = null;
        break;
      case ButtonVariant.secondary:
        backgroundColor = Colors.transparent;
        textColor = Palette.primary;
        border = BorderSide(color: Palette.primary, width: 1);
        break;
      case ButtonVariant.tertiary:
        backgroundColor = Colors.transparent;
        textColor = Palette.primary;
        border = null;
        break;
      case ButtonVariant.disabled:
        backgroundColor = Palette.gray100;
        textColor = Palette.gray400;
        border = null;
        break;
    }

    final TextStyle effectiveTextStyle =
        (textStyle ?? defaultTextStyle).copyWith(color: textColor);

    return Opacity(
      opacity: variant == ButtonVariant.disabled ? 0.7 : 1,
      child: TextButton(
        onPressed: variant == ButtonVariant.disabled ? null : onPressed,
        style: TextButton.styleFrom(
          padding: padding,
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: border ?? BorderSide.none,
          ),
        ),
        child: Text(text, style: effectiveTextStyle),
      ),
    );
  }
}
