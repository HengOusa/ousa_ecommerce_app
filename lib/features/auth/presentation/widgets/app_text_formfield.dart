import 'package:flutter/material.dart';

class AppTextFormfield extends StatelessWidget {
  final TextEditingController controller;
  final String lable;
  final String hint;
  final IconData prefixIcon;
  final IconData? suffixIcon;
  final Color? prefixIconColor;
  final Color? suffixIconColor;
  final VoidCallback? onPressed;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final String? Function(String?)? validator;

  const AppTextFormfield({
    super.key,
    required this.controller,
    required this.lable,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.prefixIconColor,
    this.suffixIconColor,
    this.onPressed,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: colors.outline),
    );

    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: colors.primary, width: 2),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: colors.error),
    );

    final focusedErrorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(20),
      borderSide: BorderSide(color: colors.error, width: 2),
    );

    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      obscureText: obscureText,
      validator: validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      style: theme.textTheme.bodyLarge?.copyWith(color: colors.onSurface),
      decoration: InputDecoration(
        labelText: lable,
        hintText: hint,

        labelStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),

        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colors.onSurfaceVariant,
        ),

        prefixIcon: Icon(prefixIcon, color: prefixIconColor ?? colors.primary),

        suffixIcon: suffixIcon == null
            ? null
            : IconButton(
                onPressed: onPressed,
                icon: Icon(
                  suffixIcon,
                  color: suffixIconColor ?? colors.primary,
                ),
              ),

        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorBorder: errorBorder,
        focusedErrorBorder: focusedErrorBorder,

        errorStyle: theme.textTheme.bodySmall?.copyWith(color: colors.error),

        filled: true,
        fillColor: colors.surface,
      ),
    );
  }
}
