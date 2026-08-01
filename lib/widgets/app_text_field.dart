import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A dark, premium text field matching the design system.
///
/// Features an optional leading icon, clear label, and consistent border
/// states (idle, focused, disabled, error).
class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? labelText;
  final IconData? leadingIcon;
  final IconData? trailingIcon;
  final VoidCallback? onTrailingTap;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool readOnly;
  final bool autocorrect;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;
  final String? helperText;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.labelText,
    this.leadingIcon,
    this.trailingIcon,
    this.onTrailingTap,
    this.textInputAction,
    this.keyboardType,
    this.obscureText = false,
    this.readOnly = false,
    this.autocorrect = true,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
    this.helperText,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: TextField(
        controller: widget.controller,
        obscureText: widget.obscureText,
        readOnly: widget.readOnly,
        autocorrect: widget.autocorrect,
        enableSuggestions: widget.autocorrect,
        textInputAction: widget.textInputAction ?? TextInputAction.done,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        style: AppTypography.bodyLarge.copyWith(
          color: widget.readOnly ? AppColors.textMuted : AppColors.textPrimary,
        ),
        cursorColor: AppColors.accentBlue,
        cursorWidth: 2,
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          helperText: widget.helperText,
          errorText: widget.errorText,
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: _focused ? AppColors.accentBlue : AppColors.textMuted,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
          helperStyle: AppTypography.bodySmall.copyWith(color: AppColors.textFaint),
          errorStyle: AppTypography.bodySmall.copyWith(color: AppColors.error),
          prefixIcon: widget.leadingIcon != null
              ? Icon(
                  widget.leadingIcon,
                  size: 18,
                  color: _focused ? AppColors.accentBlue : AppColors.textMuted,
                )
              : null,
          prefixIconConstraints: const BoxConstraints(minWidth: 46),
          suffixIcon: widget.trailingIcon != null
              ? IconButton(
                  onPressed: widget.onTrailingTap,
                  icon: Icon(
                    widget.trailingIcon,
                    size: 18,
                    color: AppColors.textMuted,
                  ),
                  tooltip: 'Toggle',
                )
              : null,
          filled: true,
          fillColor: widget.readOnly
              ? AppColors.secondary.withValues(alpha: 0.5)
              : AppColors.secondary,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm + 2,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.accentBlue, width: 1.4),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.error),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            borderSide: const BorderSide(color: AppColors.error, width: 1.4),
          ),
        ),
      ),
    );
  }
}
