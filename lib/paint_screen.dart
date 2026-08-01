import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:who_inherited_who/models/my_painter.dart';
import 'package:who_inherited_who/models/touch_points.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/waiting_room_screen.dart';
import 'package:who_inherited_who/widget/sidebar/sidebar.dart';
import 'package:who_inherited_who/widgets/loading_state.dart';
import 'package:who_inherited_who/widgets/player_avatar.dart';
import 'package:who_inherited_who/widgets/scribble_divider.dart';

class PaintScreen extends StatefulWidget {
  final Map data;
  final String screenFrom;

  const PaintScreen({required this.data, required this.screenFrom});

  @override
  State<PaintScreen> createState() => _PaintScreenState();
}

class _PaintScreenState extends State<PaintScreen> {
  late IO.Socket _socket;
  Map dataaOfRoom = {};
  List<TouchPoints?> points = [];
  StrokeCap strokeType = StrokeCap.round;
  Color selectedColor = AppColors.textPrimary;
  double opacity = 1.0; //opaque color
  double strokewidth = 2.0;
  List<Widget> TextEmptyWidget = [];
  ScrollController _scrollController = ScrollController();
  List<Map> messages = [];
  int roundTime = 60;
  int _timerStart = 60;
  late Timer _timer;
  int guessedUserCtr = 0;
  var mainScaffoldKey = GlobalKey<ScaffoldState>();
  List<Map> scoreBoard = [];
  bool _ChangingturnRailGuard = false;
  bool _timeStarted = false;
  TextEditingController _inputController = TextEditingController();

  /// ─── Game timer ───────────────────────────────────────────────
  /// Game flow: untouched. The timer drives turn changes via the
  /// 'change-turn' socket event exactly as before.
  void startTime() {
    _timeStarted = true;

    const second = Duration(seconds: 1);
    _timer = Timer.periodic(second, (Timer t) {
      if (_timerStart == 0) {
        print('timer Over! changing turns');
        _socket.emit('change-turn', dataaOfRoom['name']);
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _timerStart--;
        });
      }
    });
  }

  /// Hidden word hint rendered for guessers.
  void renderTextHidden(String word) {
    TextEmptyWidget.clear();
    for (int i = 0; i < word.length; i++) {
      if (word[i] == ' ') {
        TextEmptyWidget.add(const SizedBox(width: 18));
      } else {
        TextEmptyWidget.add(
          Container(
            width: 26,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Text(
              '_',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    }
  }

  /// Visible word for the current drawer.
  void renderTextVisible(String word) {
    TextEmptyWidget.clear();

    for (int i = 0; i < word.length; i++) {
      if (word[i] == ' ') {
        TextEmptyWidget.add(const SizedBox(width: 18));
      } else {
        TextEmptyWidget.add(
          Container(
            width: 30,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.accentOrange.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(AppSpacing.radiusXs),
              border: Border.all(
                color: AppColors.accentOrange.withValues(alpha: 0.35),
                width: 1.2,
              ),
            ),
            child: Text(
              word[i].toUpperCase(),
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.accentOrange,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        );
      }
    }
  }

  /// Color picker dialog — visual only; socket payload unchanged.
  void selectColor() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose a color'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: selectedColor,
            onColorChanged: (color) {
              print(color);
              String valueString = color.toARGB32().toRadixString(16);

              print(valueString);

              Map map = {
                'color': valueString,
                'roomName': dataaOfRoom['name'],
              };
              _socket.emit('color-change', map);
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Guess submission — game flow unchanged; payload identical to original.
  void submitGuess(String text) {
    if (text.trim().isNotEmpty) {
      Map msgMap = {
        'username': widget.data['nickname'],
        'msg': text.trim(),
        'word': dataaOfRoom['word'],
        'roomName': widget.data['name'],
        'guessedUserCtr': guessedUserCtr,

        'totalTime': roundTime,
        'timeTaken': 60 - _timerStart,
      };
      print("Sending:");
      print(msgMap);

      _socket.emit('msg-recieve', msgMap);
      _inputController.clear();
    }
  }

  @override
  void initState() {
    connect();
    super.initState();
  }

  /// ─── Socket layer — game logic preserved ─────────────────────
  void connect() {
    _socket = IO.io('http://192.168.1.47:3000', <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false
    });

    print('before connect()');
    _socket.connect();
    print('after connect()');
    print(widget.data);
    if (widget.screenFrom == "CreateRoom") {
      _socket.emit(
        "create-game",
        {
          "nickname": widget.data['nickname'],
          "name": widget.data['name'],
          "maxRounds": widget.data['maxRounds'],
          "occupancy": widget.data['occupancy'],
        },
      );
      print('room created');
    } else if (widget.screenFrom == "JoinRoom") {
      _socket.emit(
        'join-game',
        {"nickname": widget.data['nickname'], "name": widget.data['name']},
      );
    } else {
      //join room feature
      print('Server failed');
    }

    //listen to socket i guess the recieving part

    _socket.onConnect((_) {
      print('Connected');
    });

    _socket.onDisconnect((_) {
      print("SOCKET DISCONNECTED");
    });

    _socket.onConnectError((e) {
      print("CONNECT ERROR: $e");
    });

    _socket.onError((e) {
      print("SOCKET ERROR: $e");
    });

    _socket.on('updateRoom', (roomData) {
      print('word = ' + roomData['word']);
      setState(() {
        renderTextHidden(roomData['word']);
        dataaOfRoom = roomData;
      });
      if (roomData['isJoin'] == false && _timerStart == 60 && !_timeStarted) {
        startTime();
      }
      scoreBoard.clear();
      print('error Happened here: send data to Scoreboard');
      try {
        for (int i = 0; i < roomData['players'].length; i++) {
          setState(() {
            scoreBoard.add({
              'username': roomData['players'][i]['nickname'],
              'points': roomData['players'][i]['points'].toString()
            });
          });
        }
      } catch (e, st) {
        print("Error at scoreboard loop: $e ");
        print(st);
      }
    });

    _socket.on('points', (point) {
      print("POINT RECEIVED");
      print(point);
      if (point['details'] != null) {
        setState(() {
          points.add(
            TouchPoints(
              paint: Paint()
                ..strokeCap = strokeType
                ..isAntiAlias = true
                ..color = selectedColor.withOpacity(opacity)
                ..strokeWidth = strokewidth,
              points: Offset(
                point['details']['dx'].toDouble(),
                point['details']['dy'].toDouble(),
              ),
            ),
          );
          print("POINT EVENT RECEIVED");
          print(point);
        });
      } else {
        points.add(null);
        print("null point addede");
      }
    });

    _socket.onConnectError((e) {
      print('Connect Error: $e');
    });

    _socket.onError((e) {
      print('Error: $e');
    });

    _socket.on('color-change', (colorString) {
      int value = int.parse(colorString, radix: 16);
      Color colorChanged = Color(value);

      setState(() {
        selectedColor = colorChanged;
      });
    });

    _socket.on('change-weight', (strokeVal) {
      print("Stroke Weight changed");

      setState(() {
        strokewidth = (strokeVal as num).toDouble();
      });
    });

    _socket.on('clear-screen', (nullData) {
      setState(() {
        points.clear();
        print('screen cleared');
      });
    });

    _socket.on('msg-recieve', (msgData) {
      print('msg recieved');
      print(msgData);
      setState(() {
        messages.add(Map<String, dynamic>.from(msgData));
        print(msgData);
        print(msgData['guessedUserCtr']);
        print(msgData['guessedUserCtr']?.runtimeType);
        guessedUserCtr = msgData['guessedUserCtr'];

        print('Guessed User Counter: ${guessedUserCtr} ');
      });

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent + 40,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeIn,
          );
        } else {
          print('scroll controller ke paas clients nhi hen');
        }
        print('messages List length: ${messages.length}');
      });
    });

    _socket.on('change-turn', (data) {
      if (_ChangingturnRailGuard) return;
      _ChangingturnRailGuard = true;

      String oldWord = dataaOfRoom['word'];
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          Future.delayed(const Duration(seconds: 3), () {
            if (!mounted) {
              return;
            }
            Navigator.of(context).pop();

            setState(() {
              dataaOfRoom = data;
              renderTextHidden(data['word']);
              guessedUserCtr = 0;

              _timerStart = 60;

              points.clear();
            });

            if (_timer.isActive) {
              _timer.cancel();
            }
            _timerStart = 60;
            startTime();
            _ChangingturnRailGuard = false;
          });
          return _buildTurnDialog(oldWord);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.sizeOf(context).width;
    final _height = MediaQuery.sizeOf(context).height;

    final isInRoom = dataaOfRoom.isNotEmpty;
    final isGameStarted = isInRoom && dataaOfRoom['isJoin'] != true;
    final isDrawerTurn = isGameStarted &&
        dataaOfRoom['turn']?['nickname'] == widget.data['nickname'];

    return Scaffold(
      key: mainScaffoldKey,
      drawer: PlayerScoreBoardDrawer(playerData: scoreBoard),
      backgroundColor: AppColors.background,
      body: isInRoom
          ? (isGameStarted
              ? _buildGameScreen(_width, _height, isDrawerTurn)
              : WaitingRoomScreen(
                  roomName: dataaOfRoom['name'],
                  totalPlayers: dataaOfRoom['players'].length,
                  roomSize: dataaOfRoom['occupancy'],
                  players: dataaOfRoom['players'],
                ))
          : const LoadingState(message: 'Connecting to room…'),
      floatingActionButton: isGameStarted
          ? Container(
              margin: const EdgeInsets.only(bottom: 24),
              child: FloatingActionButton(
                onPressed: () {},
                backgroundColor: AppColors.card,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  side: const BorderSide(color: AppColors.borderStrong),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.timer_outlined,
                      size: 16,
                      color: _timerStart <= 10
                          ? AppColors.error
                          : AppColors.accentBlue,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '$_timerStart',
                      style: AppTypography.mono.copyWith(
                        color: _timerStart <= 10
                            ? AppColors.error
                            : AppColors.accentBlue,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
    );
  }

  /// ─── Game screen visual layer ─────────────────────────────────
  Widget _buildGameScreen(double _width, double _height, bool isDrawerTurn) {
    return SafeArea(
      child: Column(
        children: [
          _buildTopBar(_width, isDrawerTurn),
          Expanded(
            child: Stack(
              children: [
                Column(
                  children: [
                    _buildPaperCanvas(_width, _height),
                    _buildToolbar(),
                    _buildWordArea(isDrawerTurn),
                    Expanded(
                      child: _buildChatList(),
                    ),
                  ],
                ),
                if (!isDrawerTurn) _buildGuessInput(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Top bar with menu, room info, current drawer badge.
  Widget _buildTopBar(double width, bool isDrawerTurn) {
    final drawerName = dataaOfRoom['turn']?['nickname']?.toString() ?? 'nobody';

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.backgroundElevated,
        border: Border(bottom: BorderSide(color: AppColors.borderSubtle)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => mainScaffoldKey.currentState?.openDrawer(),
            icon: Icon(Icons.menu, size: 20),
            color: AppColors.textSecondary,
            tooltip: 'Scoreboard',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
              padding: const EdgeInsets.all(10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                side: const BorderSide(color: AppColors.border),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dataaOfRoom['name']?.toString() ?? 'Room',
                  style: AppTypography.headlineSmall.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  isDrawerTurn
                      ? 'You are drawing'
                      : '$drawerName is drawing',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDrawerTurn
                        ? AppColors.accentOrange
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Round ${(dataaOfRoom['round'] ?? 1)}',
              style: AppTypography.labelSmall.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// The "sheet of paper on a dark desk" canvas.
  Widget _buildPaperCanvas(double _width, double _height) {
    final canvasHeight = _height * 0.5;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xs,
      ),
      child: Container(
        height: canvasHeight,
        decoration: BoxDecoration(
          color: AppColors.backgroundElevated,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.all(AppSpacing.sm + 2),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.paper,
            borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
            border: Border.all(color: AppColors.paperBorder, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: GestureDetector(
            onPanStart: (details) {
              print('Pan Started \n Details:');
              print(details.localPosition.dx);
              _socket.emit('paint', {
                'details': {
                  'dx': details.localPosition.dx,
                  'dy': details.localPosition.dy
                },
                'roomName': widget.data['name'],
              });
            },
            onPanUpdate: (details) {
              print('Pan updated \n Details:');
              print(details.localPosition.dx);
              _socket.emit('paint', {
                'details': {
                  'dx': details.localPosition.dx,
                  'dy': details.localPosition.dy
                },
                'roomName': widget.data['name'],
              });
            },
            onPanEnd: (details) {
              print('Pan Ended');
              print(details.localPosition.dx);
              _socket.emit('paint', {
                'details': null,
                'roomName': widget.data['name'],
              });
            },
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size(_width - AppSpacing.lg * 2, canvasHeight),
                painter: MyPainter(pointslist: points),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Toolbar: color picker, stroke slider, clear button.
  Widget _buildToolbar() {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        bottom: AppSpacing.xs,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Tooltip(
              message: 'Pick a color',
              child: IconButton(
                onPressed: selectColor,
                icon: Icon(Icons.palette_outlined, color: selectedColor, size: 20),
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Slider(
                min: 1.0,
                max: 10,
                label: "Stroke width: $strokewidth",
                value: strokewidth,
                onChanged: (double value) {
                  Map data = {
                    'value': value,
                    'roomName': dataaOfRoom['name']
                  };
                  _socket.emit('change-weight', data);
                },
              ),
            ),
            Tooltip(
              message: 'Clear canvas',
              child: IconButton(
                onPressed: () {
                  _socket.emit('clear-screen', dataaOfRoom['name']);
                },
                icon: Icon(Icons.auto_fix_normal, size: 20),
                color: AppColors.textSecondary,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.secondary.withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Word area: hidden letters for guessers, visible for the drawer.
  Widget _buildWordArea(bool isDrawerTurn) {
    final word = dataaOfRoom['word']?.toString() ?? '';
    // If it's the drawer's turn, render the actual word tiles
    // instead of the blanks shown to guessers.
    if (isDrawerTurn && word.isNotEmpty) {
      renderTextVisible(word);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isDrawerTurn) ...[
            Icon(
              Icons.visibility_off_outlined,
              size: 16,
              color: AppColors.textFaint,
            ),
            const SizedBox(width: 10),
          ],
          Flexible(
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 5,
              runSpacing: 5,
              children: TextEmptyWidget,
            ),
          ),
        ],
      ),
    );
  }

  /// Chat list with styled message rows.
  Widget _buildChatList() {
    return ListView.builder(
      controller: _scrollController,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        var msgMapTemp = messages[index].values;
        final username = msgMapTemp.elementAt(0).toString();
        final message = msgMapTemp.elementAt(1).toString();

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 6,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlayerAvatar(name: username, radius: 14),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      username,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.avatarColorFor(username),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Guess input field pinned at the bottom for guessers.
  Widget _buildGuessInput() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.secondary,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _inputController,
                autocorrect: false,
                style: AppTypography.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                ),
                cursorColor: AppColors.accentBlue,
                decoration: InputDecoration(
                  hintText: 'Your guess…',
                  hintStyle: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textMuted,
                  ),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                    vertical: AppSpacing.sm + 2,
                  ),
                ),
                textInputAction: TextInputAction.done,
                onSubmitted: submitGuess,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: IconButton(
                onPressed: () => submitGuess(_inputController.text),
                icon: Icon(
                  Icons.send,
                  size: 18,
                  color: AppColors.accentBlue,
                ),
                tooltip: 'Send guess',
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.accentBlue.withValues(alpha: 0.12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Turn-change reveal dialog — timing identical; visual only.
  Widget _buildTurnDialog(String oldWord) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          border: Border.all(color: AppColors.borderStrong),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
                border: Border.all(
                  color: AppColors.accentOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Icon(
                Icons.brush_outlined,
                size: 24,
                color: AppColors.accentOrange,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'The word was',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              oldWord.toUpperCase(),
              style: AppTypography.displaySmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            const ScribbleDivider(showStar: true),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'New drawer starting…',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.textFaint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
