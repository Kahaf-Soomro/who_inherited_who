import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A minimal top bar with optional back button, title, and trailing actions.
///
/// Matches the app's premium, clean aesthetic — no strong shadows, subtle
/// bottom border, generous spacing.
class AppTopBar extends StatelessWidget {
  final String title;
  final Widget? subtitle;
  final Widget? leading;
  final List<Widget>? actions;
  final bool showBack;
  final VoidCallback? onBackPressed;
  final EdgeInsetsGeometry padding;

  const AppTopBar({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.actions,
    this.showBack = true,
    this.onBackPressed,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBackPressed ?? () => Navigator.of(context).maybePop(),
              icon: const Icon(Icons.arrow_back_rounded, size: 20),
              color: AppColors.textSecondary,
              tooltip: 'Back',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.secondary.withValues(alpha: 0.4),
                padding: const EdgeInsets.all(10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                ),
              ),
            ),
          if (showBack) const SizedBox(width: AppSpacing.sm),
          if (leading != null) ...[
            leading!,
            const SizedBox(width: AppSpacing.sm),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  subtitle!,
                ],
              ],
            ),
          ),
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}

/// A compact circular icon action button for the top bar.
class TopBarAction extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;
  final Color color;
  final bool active;

  const TopBarAction({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.color = AppColors.textSecondary,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.xs),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        color: active ? AppColors.accentBlue : color,
        tooltip: tooltip,
        style: IconButton.styleFrom(
          backgroundColor: active
              ? AppColors.accentBlue.withValues(alpha: 0.12)
              : AppColors.secondary.withValues(alpha: 0.4),
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            side: active
                ? const BorderSide(color: AppColors.accentBlue, width: 0.8)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
