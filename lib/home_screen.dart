import 'package:flutter/material.dart';
import 'package:who_inherited_who/create_room_screen.dart';
import 'package:who_inherited_who/join_room_screen.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/scribble_divider.dart';
import 'package:who_inherited_who/widgets/sketch_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;
  late final Animation<Offset> _slideUp;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _fadeIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideUp = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: AppSpacing.maxContentWidth),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // ─── Logo mark ───────────────────────────────────
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(color: AppColors.borderStrong, width: 1.4),
                      ),
                        child: Icon(
                          Icons.draw_outlined,
                          size: 32,
                          color: AppColors.accentOrange,
                        ),
                    ),
                    const SizedBox(height: AppSpacing.xl),

                    // ─── Wordmark ─────────────────────────────────────
                    Text(
                      'Who Inherited Who',
                      textAlign: TextAlign.center,
                      style: AppTypography.displayMedium.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),

                    // ─── Tagline ──────────────────────────────────────
                    Text(
                      'A scribbly multiplayer guessing game',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),

                    // ─── Doodle divider ───────────────────────────────
                    const ScribbleDivider(
                      margin: EdgeInsets.symmetric(vertical: 12),
                      showStar: true,
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    // ─── Create / Join buttons ────────────────────────
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Column(
                        children: [
                          SketchButton(
                            label: 'Create a Room',
                            icon: Icons.add,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const CreateRoomScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.md),
                          SketchButton(
                            label: 'Join a Room',
                            icon: Icons.login,
                            outlined: true,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => const JoinRoomScreen(),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ─── Footer hint ──────────────────────────────────
                    Text(
                      'Grab some friends. Draw badly. Laugh a lot.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textFaint,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
