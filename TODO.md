# Who Inherited Who — UI/UX Restyle Checklist

## Phase 1: Dependencies
- [x] Add `google_fonts` + `lucide_icons` to pubspec.yaml
- [x] Run `flutter pub get`

## Phase 2: Design System Core (`lib/theme/`)
- [x] Create `app_colors.dart` — dark neutral palette + sparse accents
- [x] Create `app_typography.dart` — Inter / Plus Jakarta Sans scale
- [x] Create `app_spacing.dart` — spacing & radius constants
- [x] Create `app_theme.dart` — full `ThemeData` (buttons, inputs, cards, dialogs, snackbars, dropdowns, page transitions)

## Phase 3: Hand-drawn Primitives (`lib/widgets/`)
- [x] Create `hand_drawn_border.dart` — wobbled border CustomPainter
- [x] Create `sketch_button.dart` — human-drawn Excalidraw-style button
- [x] Create `app_button.dart` — primary/secondary/ghost button variants
- [x] Create `app_text_field.dart` — dark themed input
- [x] Create `app_dropdown.dart` — dark dropdown + menu
- [x] Create `app_card.dart` — thin border card component

## Phase 4: App Components (`lib/widgets/`)
- [x] Create `app_badge.dart` — pill tags
- [x] Create `player_avatar.dart` — initial-based avatar
- [x] Create `score_tile.dart` — scoreboard row
- [x] Create `room_tile.dart` — player/room tile
- [x] Create `section_header.dart` — header + doodle support
- [x] Create `scribble_divider.dart` — hand-drawn separator
- [x] Create `sketch_checkmark.dart` — hand-drawn checkmark
- [x] Create `app_top_bar.dart` — minimal top bar
- [x] Create `loading_state.dart` — loading/error/empty states

## Phase 5: Screen Restyles
- [x] `main.dart` — apply dark theme
- [x] `home_screen.dart` — landing redesign
- [x] `create_room_screen.dart` — form card redesign
- [x] `join_room_screen.dart` — form card redesign
- [x] `waiting_room_screen.dart` — room code + player list redesign
- [x] `paint_screen.dart` — game screen visual restyle (logic untouched)
- [x] `widget/sidebar/sidebar.dart` — scoreboard drawer restyle
- [x] Replace `widget/custom_text_field.dart` usage with `AppTextField` (old file removed)

## Phase 6: Verification
- [x] `flutter analyze` — fix all issues
- [ ] Build check (`flutter build windows` or device run) — **deferred at user request**
- [x] Confirm no socket / timer / game-flow logic changed
