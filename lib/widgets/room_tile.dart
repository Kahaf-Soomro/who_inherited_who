import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/player_avatar.dart';

/// A single player entry in the waiting room or player list.
///
/// Shows the player avatar, nickname, a "you" badge for the current user,
/// and an optional turn indicator with animated entrance.
class RoomTile extends StatefulWidget {
  final String nickname;
  final bool isYou;
  final bool isDrawing;
  final int index;

  const RoomTile({
    super.key,
    required this.nickname,
    this.isYou = false,
    this.isDrawing = false,
    required this.index,
  });

  @override
  State<RoomTile> createState() => _RoomTileState();
}

class _RoomTileState extends State<RoomTile> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppSpacing.durationSlow,
    );
    final delay = (widget.index * 60).clamp(0, 400);
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Interval(0, 0.6, curve: Curves.easeOut),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 0.7, curve: Curves.easeOutCubic),
      ),
    );
    Future.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 5),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
          decoration: BoxDecoration(
            color: widget.isYou
                ? AppColors.accentBlue.withValues(alpha: 0.05)
                : AppColors.card,
            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
            border: Border.all(
              color: widget.isDrawing
                  ? AppColors.accentOrange.withValues(alpha: 0.4)
                  : widget.isYou
                      ? AppColors.accentBlue.withValues(alpha: 0.2)
                      : AppColors.border,
              width: widget.isDrawing ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              PlayerAvatar(
                name: widget.nickname,
                radius: 17,
                highlighted: widget.isDrawing,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        widget.nickname,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: widget.isYou ? FontWeight.w700 : FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.isYou) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentBlue.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                        ),
                        child: Text(
                          'you',
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.accentBlue,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (widget.isDrawing)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                          color: AppColors.accentOrange,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        'drawing',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accentOrange,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
