import 'package:flutter/material.dart';
import 'package:who_inherited_who/paint_screen.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/app_card.dart';
import 'package:who_inherited_who/widgets/app_dropdown.dart';
import 'package:who_inherited_who/widgets/app_text_field.dart';
import 'package:who_inherited_who/widgets/app_top_bar.dart';
import 'package:who_inherited_who/widgets/sketch_button.dart';

class CreateRoomScreen extends StatefulWidget {
  const CreateRoomScreen({super.key});

  @override
  State<CreateRoomScreen> createState() => _CreateRoomScreenState();
}

class _CreateRoomScreenState extends State<CreateRoomScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roomNameController = TextEditingController();
  String? _maxRoundsValue;
  String? _maxPlayers;

  void createRoom() {
    if (_nameController.text.isNotEmpty &&
        _roomNameController.text.isNotEmpty &&
        _maxPlayers != null &&
        _maxRoundsValue != null) {
      Map data = {
        "nickname": _nameController.text,
        "name": _roomNameController.text,
        "maxRounds": _maxRoundsValue,
        "occupancy": _maxPlayers,
      };
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PaintScreen(data: data, screenFrom: "CreateRoom"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields to create a room'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _roomNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const AppTopBar(title: 'Create Room'),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Start a new game',
                        style: AppTypography.displaySmall.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Set up the room and invite your friends to scribble.',
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),

                      // ─── Form card ────────────────────────────────
                      AppCard(
                        padding: const EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AppTextField(
                              controller: _nameController,
                              hintText: 'Your nickname',
                              leadingIcon: Icons.person_outline,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppTextField(
                              controller: _roomNameController,
                              hintText: 'Room name',
                              leadingIcon: Icons.tag,
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppDropdown<String>(
                              value: _maxRoundsValue,
                              hintText: 'Select max rounds',
                              labelText: 'Rounds',
                              leadingIcon: Icons.repeat,
                              items: AppDropdownItem.stringItems(
                                const ["2", "3", "5", "10", "15"],
                              ),
                              onChanged: (value) =>
                                  setState(() => _maxRoundsValue = value),
                            ),
                            const SizedBox(height: AppSpacing.md),
                            AppDropdown<String>(
                              value: _maxPlayers,
                              hintText: 'Select room size',
                              labelText: 'Players',
                              leadingIcon: Icons.group_outlined,
                              items: AppDropdownItem.stringItems(
                                const ["2", "3", "4", "5", "6", "7"],
                              ),
                              onChanged: (value) =>
                                  setState(() => _maxPlayers = value),
                            ),
                            const SizedBox(height: AppSpacing.xl),
                            SketchButton(
                              label: 'Create Room',
                              icon: Icons.add,
                              onPressed: createRoom,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
