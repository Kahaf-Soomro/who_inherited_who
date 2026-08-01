import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A dark, premium dropdown selector matching the design system.
///
/// Replaces the default Material dropdown with a consistent bordered card
/// look: secondary fill, thin border, blue focus accent, minimal menu styling.
class AppDropdown<T> extends StatefulWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String hintText;
  final IconData? leadingIcon;
  final String? labelText;
  final bool expanded;

  const AppDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.hintText,
    this.leadingIcon,
    this.labelText,
    this.expanded = true,
  });

  @override
  State<AppDropdown<T>> createState() => _AppDropdownState<T>();
}

class _AppDropdownState<T> extends State<AppDropdown<T>> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final hasValue = widget.value != null;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
          border: Border.all(
            color: _hovered ? AppColors.borderStrong : AppColors.border,
            width: _hovered ? 1.4 : 1,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: widget.value,
            isExpanded: widget.expanded,
            items: widget.items,
            onChanged: widget.onChanged,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            dropdownColor: AppColors.card,
            icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 20, color: AppColors.textMuted),
            iconSize: 20,
            hint: _buildHint(),
            selectedItemBuilder: (context) {
              return widget.items.map((item) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (widget.leadingIcon != null) ...[
                        Icon(
                          widget.leadingIcon,
                          size: 17,
                          color: hasValue ? AppColors.textSecondary : AppColors.textMuted,
                        ),
                        const SizedBox(width: 10),
                      ],
                      Flexible(
                        child: Text(
                          _itemLabel(item.value),
                          style: AppTypography.bodyMedium.copyWith(
                            color: hasValue ? AppColors.textPrimary : AppColors.textMuted,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  String _itemLabel(T? value) {
    final item = widget.items.where((i) => i.value == value).firstOrNull;
    if (item == null) return widget.hintText;
    // Extract label by finding the first Text descendant is complex;
    // use the value's toString for value types (int, String).
    return value.toString();
  }

  Widget _buildHint() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.leadingIcon != null) ...[
          Icon(widget.leadingIcon, size: 17, color: AppColors.textMuted),
          const SizedBox(width: 10),
        ],
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: AppTypography.labelMedium.copyWith(color: AppColors.textMuted),
          ),
          const SizedBox(width: 6),
        ],
        Text(
          widget.hintText,
          style: AppTypography.bodyMedium.copyWith(color: AppColors.textMuted),
        ),
      ],
    );
  }
}

/// Convenience builder for standard string dropdown items.
class AppDropdownItem {
  AppDropdownItem._();

  static List<DropdownMenuItem<String>> stringItems(
    List<String> values, {
    TextStyle? textStyle,
  }) {
    return values
        .map(
          (value) => DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: textStyle ??
                  AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
            ),
          ),
        )
        .toList();
  }
}
