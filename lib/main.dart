import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;
  final tracker = BehaviorTracker.instance;
  await tracker.initialize();
  runApp(MyApp(tracker: tracker));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.tracker});

  final BehaviorTracker tracker;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    widget.tracker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<MoodState>(
      valueListenable: widget.tracker.currentMood,
      builder: (context, mood, _) {
        final moodTheme = getMoodTheme(mood);
        final colorScheme =
            ColorScheme.fromSeed(seedColor: moodTheme.primaryColor).copyWith(
              primary: moodTheme.primaryColor,
              surface: moodTheme.cardColor,
              onPrimary: Colors.white,
              onSurface: moodTheme.textColor,
            );
        final baseTheme = ThemeData(
          useMaterial3: true,
          colorScheme: colorScheme,
          scaffoldBackgroundColor: moodTheme.backgroundColor,
          cardColor: moodTheme.cardColor,
          appBarTheme: AppBarTheme(
            backgroundColor: moodTheme.appBarColor,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: false,
            titleTextStyle: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          textTheme: GoogleFonts.poppinsTextTheme(ThemeData.light().textTheme)
              .apply(
                bodyColor: moodTheme.textColor,
                displayColor: moodTheme.textColor,
              ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: moodTheme.buttonColor,
              foregroundColor: Colors.white,
              textStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: moodTheme.buttonColor,
            foregroundColor: Colors.white,
          ),
          chipTheme: ChipThemeData(
            backgroundColor: moodTheme.cardColor,
            selectedColor: moodTheme.primaryColor,
            labelStyle: GoogleFonts.poppins(
              color: moodTheme.textColor,
              fontWeight: FontWeight.w600,
            ),
            secondaryLabelStyle: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
            side: BorderSide(
              color: moodTheme.primaryColor.withValues(alpha: 0.2),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: moodTheme.cardColor,
            labelStyle: GoogleFonts.poppins(color: moodTheme.textColor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: moodTheme.primaryColor.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: moodTheme.primaryColor, width: 1.5),
            ),
          ),
        );

        return MaterialApp(
          title: 'MindUI - Emotion Adaptive Interface',
          debugShowCheckedModeBanner: false,
          theme: baseTheme,
          home: SplashScreen(
            tracker: widget.tracker,
            splashMood: widget.tracker.lastSavedMood,
          ),
        );
      },
    );
  }
}

enum MoodState { calm, focused, overloaded, anxious, fatigued, calibrating }

class MoodTheme {
  const MoodTheme({
    required this.primaryColor,
    required this.backgroundColor,
    required this.cardColor,
    required this.textColor,
    required this.appBarColor,
    required this.buttonColor,
    required this.emoji,
    required this.description,
  });

  final Color primaryColor;
  final Color backgroundColor;
  final Color cardColor;
  final Color textColor;
  final Color appBarColor;
  final Color buttonColor;
  final String emoji;
  final String description;
}

MoodTheme getMoodTheme(MoodState mood) {
  switch (mood) {
    case MoodState.calm:
      return const MoodTheme(
        primaryColor: Color(0xFF4CAF50),
        backgroundColor: Color(0xFFE8F5E9),
        cardColor: Color(0xFFC8E6C9),
        textColor: Color(0xFF1B5E20),
        appBarColor: Color(0xFF388E3C),
        buttonColor: Color(0xFF43A047),
        emoji: '😌',
        description: 'You are calm and relaxed. Interface is in default mode.',
      );
    case MoodState.focused:
      return const MoodTheme(
        primaryColor: Color(0xFF1976D2),
        backgroundColor: Color(0xFFE3F2FD),
        cardColor: Color(0xFFBBDEFB),
        textColor: Color(0xFF0D47A1),
        appBarColor: Color(0xFF1565C0),
        buttonColor: Color(0xFF1E88E5),
        emoji: '🎯',
        description: 'You are in deep focus. Advanced options are enabled.',
      );
    case MoodState.overloaded:
      return const MoodTheme(
        primaryColor: Color(0xFFF57C00),
        backgroundColor: Color(0xFFFFF3E0),
        cardColor: Color(0xFFFFE0B2),
        textColor: Color(0xFFE65100),
        appBarColor: Color(0xFFEF6C00),
        buttonColor: Color(0xFFFF8F00),
        emoji: '😵',
        description: 'You seem overloaded. Simplifying the interface.',
      );
    case MoodState.anxious:
      return const MoodTheme(
        primaryColor: Color(0xFF7B1FA2),
        backgroundColor: Color(0xFFF3E5F5),
        cardColor: Color(0xFFE1BEE7),
        textColor: Color(0xFF4A148C),
        appBarColor: Color(0xFF6A1B9A),
        buttonColor: Color(0xFF8E24AA),
        emoji: '😰',
        description: 'You seem anxious. Reducing alerts and softening colors.',
      );
    case MoodState.fatigued:
      return const MoodTheme(
        primaryColor: Color(0xFF455A64),
        backgroundColor: Color(0xFFECEFF1),
        cardColor: Color(0xFFCFD8DC),
        textColor: Color(0xFF263238),
        appBarColor: Color(0xFF37474F),
        buttonColor: Color(0xFF546E7A),
        emoji: '😴',
        description: 'You seem fatigued. Consider taking a short break.',
      );
    case MoodState.calibrating:
      return const MoodTheme(
        primaryColor: Color(0xFF9E9E9E),
        backgroundColor: Color(0xFFF5F5F5),
        cardColor: Color(0xFFEEEEEE),
        textColor: Color(0xFF424242),
        appBarColor: Color(0xFF757575),
        buttonColor: Color(0xFF9E9E9E),
        emoji: '🔄',
        description:
            'Tracking your interactions... Please interact for 30 seconds.',
      );
  }
}

String moodLabel(MoodState mood) {
  switch (mood) {
    case MoodState.calm:
      return 'CALM';
    case MoodState.focused:
      return 'FOCUSED';
    case MoodState.overloaded:
      return 'OVERLOADED';
    case MoodState.anxious:
      return 'ANXIOUS';
    case MoodState.fatigued:
      return 'FATIGUED';
    case MoodState.calibrating:
      return 'CALIBRATING';
  }
}

MoodState moodFromName(String? name) {
  return MoodState.values.firstWhere(
    (mood) => mood.name == name,
    orElse: () => MoodState.calm,
  );
}

String formatHistoryTimestamp(DateTime value) {
  final date =
      '${value.day.toString().padLeft(2, '0')}/'
      '${value.month.toString().padLeft(2, '0')}/${value.year}';
  final hour = value.hour % 12 == 0 ? 12 : value.hour % 12;
  final minute = value.minute.toString().padLeft(2, '0');
  final period = value.hour >= 12 ? 'PM' : 'AM';
  return '$date - $hour:$minute $period';
}

class BehaviorTracker {
  BehaviorTracker._();

  static final BehaviorTracker instance = BehaviorTracker._();

  static const String _moodKey = 'mindui_last_mood';
  static const String _moodTimestampKey = 'mindui_last_mood_time';
  static const String _historyKey = 'mindui_history_entries';

  final ValueNotifier<MoodState> currentMood = ValueNotifier<MoodState>(
    MoodState.calm,
  );
  final ValueNotifier<int> metricsTick = ValueNotifier<int>(0);

  SharedPreferences? _prefs;
  Timer? _inferTimer;
  Timer? _idleTimer;

  final List<DateTime> _tapTimestamps = <DateTime>[];
  final List<DateTime> _keystrokeTimestamps = <DateTime>[];
  final List<DateTime> _backspaceTimestamps = <DateTime>[];
  final List<DateTime> _backNavigationTimestamps = <DateTime>[];
  final List<Map<String, String>> _historyEntries = <Map<String, String>>[];

  MoodState _lastSavedMood = MoodState.calm;
  MoodState? _pendingMood;
  DateTime _lastMoodUpdated = DateTime.now();
  DateTime _sessionStartedAt = DateTime.now();

  Duration? _lastTapInterval;
  double _lastScrollVelocity = 0;
  double _lastTapPressure = 1.0;
  int _idleSeconds = 0;
  int _confirmCount = 0;
  int _scrollEventCount = 0;
  int _totalTapCount = 0;
  bool _initialized = false;

  MoodState get lastSavedMood => _lastSavedMood;
  DateTime get lastMoodUpdated => _lastMoodUpdated;
  int get idleSeconds => _idleSeconds;
  int get totalTapCount => _totalTapCount;
  int get scrollEventCount => _scrollEventCount;
  int get keystrokeCount {
    _pruneKeystrokes();
    return _keystrokeTimestamps.length;
  }

  double get lastScrollVelocity => _lastScrollVelocity;
  double get tapPressure => _lastTapPressure;
  int get backNavigationCount {
    _pruneBackNavigation();
    return _backNavigationTimestamps.length;
  }

  double get tapsPerMinute {
    if (_tapTimestamps.length < 2) {
      return 0;
    }
    final firstTap = _tapTimestamps.first;
    final lastTap = _tapTimestamps.last;
    final minutes = lastTap.difference(firstTap).inMilliseconds / 60000;
    if (minutes <= 0) {
      return 0;
    }
    return (_tapTimestamps.length - 1) / minutes;
  }

  List<Map<String, String>> get moodHistory =>
      List<Map<String, String>>.unmodifiable(_historyEntries.reversed);

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    _loadSavedState();
    _startTimers();
    _initialized = true;
    _notifyMetrics();
  }

  void recordTap() {
    final now = DateTime.now();
    if (_tapTimestamps.isNotEmpty) {
      _lastTapInterval = now.difference(_tapTimestamps.last);
    }
    _tapTimestamps.add(now);
    if (_tapTimestamps.length > 10) {
      _tapTimestamps.removeAt(0);
    }
    _totalTapCount++;
    _resetIdle();
    _notifyMetrics();
  }

  void recordTapPressure(double pressure) {
    if (pressure <= 0) {
      return;
    }
    _lastTapPressure = pressure;
    _notifyMetrics();
  }

  void recordScroll(double velocity) {
    _lastScrollVelocity = velocity.abs();
    _scrollEventCount++;
    _resetIdle();
    _notifyMetrics();
  }

  void recordKeystroke({int count = 1, bool isBackspace = false}) {
    final now = DateTime.now();
    for (var index = 0; index < count; index++) {
      _keystrokeTimestamps.add(now);
      if (isBackspace) {
        _backspaceTimestamps.add(now);
      }
    }
    _pruneKeystrokes();
    _resetIdle();
    _notifyMetrics();
  }

  void recordBackNavigation() {
    _backNavigationTimestamps.add(DateTime.now());
    _pruneBackNavigation();
    _resetIdle();
    _notifyMetrics();
  }

  void resetMetrics() {
    _tapTimestamps.clear();
    _keystrokeTimestamps.clear();
    _backspaceTimestamps.clear();
    _backNavigationTimestamps.clear();
    _lastTapInterval = null;
    _lastScrollVelocity = 0;
    _lastTapPressure = 1.0;
    _idleSeconds = 0;
    _scrollEventCount = 0;
    _totalTapCount = 0;
    _confirmCount = 0;
    _pendingMood = null;
    _sessionStartedAt = DateTime.now();
    _setMood(MoodState.calibrating, persist: false);
    _notifyMetrics();
  }

  void setManualMood(MoodState mood) {
    _pendingMood = null;
    _confirmCount = 0;
    _setMood(mood);
  }

  Future<void> clearHistory() async {
    _historyEntries.clear();
    await _prefs?.remove(_historyKey);
    _notifyMetrics();
  }

  MoodState inferMood() {
    _pruneKeystrokes();
    _pruneBackNavigation();

    final sessionSeconds = DateTime.now()
        .difference(_sessionStartedAt)
        .inSeconds;
    if (_totalTapCount < 5 && sessionSeconds < 30) {
      _setMood(MoodState.calibrating, persist: false);
      return MoodState.calibrating;
    }

    if (_idleSeconds > 90) {
      _pendingMood = MoodState.fatigued;
      _confirmCount = 0;
      _setMood(MoodState.fatigued);
      return MoodState.fatigued;
    }

    final scores = <MoodState, double>{
      MoodState.calm: 0,
      MoodState.focused: 0,
      MoodState.overloaded: 0,
      MoodState.anxious: 0,
      MoodState.fatigued: 0,
    };

    final intervalMs = _lastTapInterval?.inMilliseconds;
    if (intervalMs != null) {
      if (intervalMs > 5000) {
        scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 25;
      } else if (intervalMs >= 2000) {
        scores[MoodState.calm] = scores[MoodState.calm]! + 25;
      } else if (intervalMs >= 800) {
        scores[MoodState.focused] = scores[MoodState.focused]! + 25;
      } else if (intervalMs >= 300) {
        scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 25;
      } else {
        scores[MoodState.anxious] = scores[MoodState.anxious]! + 25;
      }
    }

    final tpm = tapsPerMinute;
    if (tpm > 0) {
      if (tpm <= 5) {
        scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 25;
      } else if (tpm <= 12) {
        scores[MoodState.calm] = scores[MoodState.calm]! + 25;
      } else if (tpm <= 25) {
        scores[MoodState.focused] = scores[MoodState.focused]! + 25;
      } else if (tpm <= 40) {
        scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 25;
      } else {
        scores[MoodState.anxious] = scores[MoodState.anxious]! + 25;
      }
    }

    if (_lastScrollVelocity <= 80) {
      scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 20;
    } else if (_lastScrollVelocity <= 200) {
      scores[MoodState.calm] = scores[MoodState.calm]! + 20;
    } else if (_lastScrollVelocity <= 500) {
      scores[MoodState.focused] = scores[MoodState.focused]! + 20;
    } else if (_lastScrollVelocity <= 900) {
      scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 20;
    } else {
      scores[MoodState.anxious] = scores[MoodState.anxious]! + 20;
    }

    final typingCount = _keystrokeTimestamps.length;
    if (typingCount <= 5) {
      scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 15;
    } else if (typingCount <= 15) {
      scores[MoodState.calm] = scores[MoodState.calm]! + 15;
    } else if (typingCount <= 35) {
      scores[MoodState.focused] = scores[MoodState.focused]! + 15;
    } else if (typingCount <= 55) {
      scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 15;
    } else {
      scores[MoodState.anxious] = scores[MoodState.anxious]! + 15;
    }

    if (typingCount >= 10) {
      final ratio = _backspaceTimestamps.length / typingCount * 100;
      if (ratio <= 5) {
        final preferredMood =
            scores[MoodState.focused]! > scores[MoodState.calm]!
            ? MoodState.focused
            : MoodState.calm;
        scores[preferredMood] = scores[preferredMood]! + 10;
      } else if (ratio <= 15) {
        scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 10;
      } else if (ratio <= 25) {
        scores[MoodState.anxious] = scores[MoodState.anxious]! + 10;
      } else {
        scores[MoodState.anxious] = scores[MoodState.anxious]! + 10;
        scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 5;
      }
    }

    if (_idleSeconds <= 8) {
      scores[MoodState.focused] = scores[MoodState.focused]! + 5;
    } else if (_idleSeconds <= 45) {
      scores[MoodState.calm] = scores[MoodState.calm]! + 5;
    } else if (_idleSeconds <= 90) {
      scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 5;
    } else {
      scores[MoodState.fatigued] = scores[MoodState.fatigued]! + 10;
    }

    final backCount = _backNavigationTimestamps.length;
    if (backCount <= 1) {
      final preferredMood = scores[MoodState.focused]! > scores[MoodState.calm]!
          ? MoodState.focused
          : MoodState.calm;
      scores[preferredMood] = scores[preferredMood]! + 5;
    } else if (backCount <= 3) {
      scores[MoodState.overloaded] = scores[MoodState.overloaded]! + 5;
    } else if (backCount <= 5) {
      scores[MoodState.anxious] = scores[MoodState.anxious]! + 5;
    } else {
      scores[MoodState.anxious] = scores[MoodState.anxious]! + 10;
    }

    if (scores[MoodState.anxious]! >= 45) {
      _pendingMood = MoodState.anxious;
      _confirmCount = 0;
      _setMood(MoodState.anxious);
      return MoodState.anxious;
    }

    final winner = scores.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    if (winner == _pendingMood) {
      _confirmCount++;
    } else {
      _pendingMood = winner;
      _confirmCount = 1;
    }

    if (winner == MoodState.anxious && _confirmCount >= 2) {
      _commitMood(winner);
      return winner;
    }

    if (_confirmCount >= 3) {
      _commitMood(winner);
      return winner;
    }

    return currentMood.value;
  }

  void dispose() {
    _inferTimer?.cancel();
    _idleTimer?.cancel();
    _inferTimer = null;
    _idleTimer = null;
    _initialized = false;
  }

  void _commitMood(MoodState mood) {
    _setMood(mood);
    _confirmCount = 0;
    _pendingMood = mood;
  }

  void _loadSavedState() {
    final savedMood = _prefs?.getString(_moodKey);
    _lastSavedMood = moodFromName(savedMood);
    currentMood.value = _lastSavedMood;

    final lastUpdatedString = _prefs?.getString(_moodTimestampKey);
    _lastMoodUpdated = lastUpdatedString == null
        ? DateTime.now()
        : DateTime.tryParse(lastUpdatedString) ?? DateTime.now();

    final rawEntries = _prefs?.getStringList(_historyKey) ?? <String>[];
    _historyEntries
      ..clear()
      ..addAll(
        rawEntries.map((entry) {
          final decoded = jsonDecode(entry) as Map<String, dynamic>;
          return decoded.map((key, value) => MapEntry(key, value.toString()));
        }),
      );
  }

  void _startTimers() {
    _inferTimer?.cancel();
    _idleTimer?.cancel();

    _inferTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => inferMood(),
    );
    _idleTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      _idleSeconds++;
      _notifyMetrics();
      if (_idleSeconds > 90) {
        inferMood();
      }
    });
  }

  void _resetIdle() {
    _idleSeconds = 0;
  }

  void _setMood(MoodState mood, {bool persist = true}) {
    final changed = currentMood.value != mood;
    if (changed) {
      currentMood.value = mood;
    }

    _lastMoodUpdated = DateTime.now();

    if (persist && mood != MoodState.calibrating) {
      _lastSavedMood = mood;
      unawaited(_prefs?.setString(_moodKey, mood.name));
      unawaited(
        _prefs?.setString(
          _moodTimestampKey,
          _lastMoodUpdated.toIso8601String(),
        ),
      );
      if (changed) {
        _historyEntries.add(<String, String>{
          'mood': mood.name,
          'timestamp': _lastMoodUpdated.toIso8601String(),
        });
        unawaited(
          _prefs?.setStringList(
            _historyKey,
            _historyEntries.map((entry) => jsonEncode(entry)).toList(),
          ),
        );
      }
    }

    _notifyMetrics();
  }

  void _pruneKeystrokes() {
    final cutoff = DateTime.now().subtract(const Duration(seconds: 10));
    _keystrokeTimestamps.removeWhere((timestamp) => timestamp.isBefore(cutoff));
    _backspaceTimestamps.removeWhere((timestamp) => timestamp.isBefore(cutoff));
  }

  void _pruneBackNavigation() {
    final cutoff = DateTime.now().subtract(const Duration(seconds: 60));
    _backNavigationTimestamps.removeWhere(
      (timestamp) => timestamp.isBefore(cutoff),
    );
  }

  void _notifyMetrics() {
    if (!_initialized) {
      return;
    }
    metricsTick.value++;
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
    required this.tracker,
    required this.splashMood,
  });

  final BehaviorTracker tracker;
  final MoodState splashMood;

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    _navigationTimer = Timer(const Duration(milliseconds: 2500), () {
      if (!mounted) {
        return;
      }
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => HomeScreen(tracker: widget.tracker),
        ),
      );
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = getMoodTheme(widget.splashMood);
    return Scaffold(
      body: SafeArea(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 600),
          color: theme.backgroundColor,
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.psychology_alt_rounded,
                    size: 96,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'MindUI',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.textColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your interface adapts to you',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: theme.textColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.tracker});

  final BehaviorTracker tracker;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin<HomeScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.psychology_alt_rounded),
            const SizedBox(width: 10),
            const Text('MindUI Dashboard'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => MoodHistoryScreen(tracker: widget.tracker),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.tracker.resetMetrics,
        child: const Icon(Icons.refresh),
      ),
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: widget.tracker.metricsTick,
          builder: (context, _, child) {
            final currentMood = widget.tracker.currentMood.value;
            final moodTheme = getMoodTheme(currentMood);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              color: moodTheme.backgroundColor,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    MoodStatusCard(
                      mood: currentMood,
                      updatedAt: widget.tracker.lastMoodUpdated,
                      description: currentMood == MoodState.calibrating
                          ? 'Calibrating...'
                          : moodTheme.description,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final mood in <MoodState>[
                          MoodState.calm,
                          MoodState.focused,
                          MoodState.overloaded,
                          MoodState.anxious,
                          MoodState.fatigued,
                        ])
                          MoodChip(
                            label: moodLabel(mood),
                            mood: mood,
                            isSelected: currentMood == mood,
                            onTap: () {
                              widget.tracker.recordTap();
                              widget.tracker.setManualMood(mood);
                            },
                            onPointerDown: widget.tracker.recordTapPressure,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Behavior Tracking Live',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    MetricTile(
                      label: 'Tap Speed',
                      value:
                          '${widget.tracker.tapsPerMinute.toStringAsFixed(1)} taps/min',
                      progress: (widget.tracker.tapsPerMinute / 50).clamp(0, 1),
                    ),
                    MetricTile(
                      label: 'Tap Pressure',
                      value: _pressureLabel(widget.tracker.tapPressure),
                      progress: _pressureProgress(widget.tracker.tapPressure),
                    ),
                    MetricTile(
                      label: 'Scroll Velocity',
                      value:
                          '${_scrollLabel(widget.tracker.lastScrollVelocity)} - ${widget.tracker.lastScrollVelocity.toStringAsFixed(0)} px/s',
                      progress: (widget.tracker.lastScrollVelocity / 1000)
                          .clamp(0, 1),
                    ),
                    MetricTile(
                      label: 'Navigation Backtrack Count',
                      value: '${widget.tracker.backNavigationCount}',
                      progress: (widget.tracker.backNavigationCount / 6).clamp(
                        0,
                        1,
                      ),
                    ),
                    MetricTile(
                      label: 'Idle Time',
                      value: '${widget.tracker.idleSeconds} seconds',
                      progress: (widget.tracker.idleSeconds / 90).clamp(0, 1),
                    ),
                    const SizedBox(height: 20),
                    Listener(
                      onPointerDown: (event) =>
                          widget.tracker.recordTapPressure(event.pressure),
                      child: ElevatedButton(
                        onPressed: () {
                          widget.tracker.recordTap();
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  TaskScreen(tracker: widget.tracker),
                            ),
                          );
                        },
                        child: const Text('Start Tracking Session'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _pressureLabel(double pressure) {
    if (pressure < 0.85) {
      return 'light';
    }
    if (pressure <= 1.2) {
      return 'medium';
    }
    return 'hard';
  }

  double _pressureProgress(double pressure) {
    if (pressure < 0.85) {
      return 0.33;
    }
    if (pressure <= 1.2) {
      return 0.66;
    }
    return 1;
  }

  String _scrollLabel(double velocity) {
    if (velocity < 300) {
      return 'slow';
    }
    if (velocity <= 800) {
      return 'normal';
    }
    return 'fast';
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key, required this.tracker});

  final BehaviorTracker tracker;

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen>
    with AutomaticKeepAliveClientMixin<TaskScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  double _lastOffset = 0;
  DateTime? _lastScrollUpdateAt;
  String _previousTextValue = '';

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    _textController.dispose();
    super.dispose();
  }

  Future<bool> _handleBackNavigation() async {
    widget.tracker.recordBackNavigation();
    if (mounted) {
      Navigator.of(context).pop();
    }
    return false;
  }

  void _handleTextChanged(String value) {
    final difference = value.length - _previousTextValue.length;
    if (difference > 0) {
      widget.tracker.recordKeystroke(count: difference);
    } else if (difference < 0) {
      widget.tracker.recordKeystroke(
        count: difference.abs(),
        isBackspace: true,
      );
    }
    _previousTextValue = value;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _handleBackNavigation();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              _handleBackNavigation();
            },
            icon: const Icon(Icons.arrow_back),
          ),
          title: const Text('Active Session'),
        ),
        body: SafeArea(
          child: ValueListenableBuilder<int>(
            valueListenable: widget.tracker.metricsTick,
            builder: (context, _, child) {
              final mood = widget.tracker.currentMood.value;
              final moodTheme = getMoodTheme(mood);
              return AnimatedContainer(
                duration: const Duration(milliseconds: 600),
                color: moodTheme.backgroundColor,
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 600),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: moodTheme.cardColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Scroll to simulate reading behavior',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 180,
                              child: NotificationListener<ScrollNotification>(
                                onNotification: (notification) {
                                  if (notification
                                      is ScrollUpdateNotification) {
                                    final now = DateTime.now();
                                    final lastTime = _lastScrollUpdateAt;
                                    if (lastTime != null) {
                                      final elapsed =
                                          now
                                              .difference(lastTime)
                                              .inMilliseconds /
                                          1000;
                                      if (elapsed > 0) {
                                        final offset =
                                            notification.metrics.pixels;
                                        final velocity =
                                            (offset - _lastOffset).abs() /
                                            elapsed;
                                        widget.tracker.recordScroll(velocity);
                                        _lastOffset = offset;
                                      }
                                    } else {
                                      _lastOffset = notification.metrics.pixels;
                                    }
                                    _lastScrollUpdateAt = now;
                                  }
                                  return false;
                                },
                                child: SingleChildScrollView(
                                  controller: _scrollController,
                                  child: Text(
                                    'MindUI explores how interfaces can respond '
                                    'to subtle signals from the people using '
                                    'them. A calm session can keep the layout '
                                    'light and reassuring, while an intense '
                                    'session can surface stronger guidance and '
                                    'clearer calls to action. This prototype '
                                    'tracks taps, scrolling, typing, and idle '
                                    'time to estimate mood patterns locally on '
                                    'the device. Because everything stays '
                                    'offline, the app is designed to feel '
                                    'private, immediate, and always available.',
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(height: 1.6),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        childAspectRatio: 1.7,
                        children: [
                          _taskButton('Read Article', Icons.article_outlined),
                          _taskButton('Take Quiz', Icons.quiz_outlined),
                          _taskButton('View Chart', Icons.bar_chart_rounded),
                          _taskButton('Open Settings', Icons.settings_outlined),
                          _taskButton(
                            'Go Back',
                            Icons.arrow_back_rounded,
                            isBackAction: true,
                          ),
                          _taskButton('Help', Icons.help_outline_rounded),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _textController,
                        onChanged: (value) {
                          _handleTextChanged(value);
                        },
                        maxLines: 4,
                        decoration: const InputDecoration(
                          labelText: 'Type your thoughts here',
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      MoodIndicator(mood: mood),
                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _statChip('Taps', widget.tracker.totalTapCount),
                          _statChip(
                            'Scroll Events',
                            widget.tracker.scrollEventCount,
                          ),
                          _statChip(
                            'Keystrokes',
                            widget.tracker.keystrokeCount,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _taskButton(String label, IconData icon, {bool isBackAction = false}) {
    return Listener(
      onPointerDown: (event) =>
          widget.tracker.recordTapPressure(event.pressure),
      child: ElevatedButton.icon(
        onPressed: () {
          widget.tracker.recordTap();
          if (isBackAction) {
            _handleBackNavigation();
            return;
          }
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$label tapped')));
        },
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }

  Widget _statChip(String label, int value) {
    final moodTheme = getMoodTheme(widget.tracker.currentMood.value);
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: moodTheme.primaryColor,
        foregroundColor: Colors.white,
        child: Text(value.toString()),
      ),
      label: Text(label),
    );
  }
}

class MoodHistoryScreen extends StatefulWidget {
  const MoodHistoryScreen({super.key, required this.tracker});

  final BehaviorTracker tracker;

  @override
  State<MoodHistoryScreen> createState() => _MoodHistoryScreenState();
}

class _MoodHistoryScreenState extends State<MoodHistoryScreen>
    with AutomaticKeepAliveClientMixin<MoodHistoryScreen> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Mood History')),
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: widget.tracker.metricsTick,
          builder: (context, _, child) {
            final history = widget.tracker.moodHistory;
            final currentTheme = getMoodTheme(widget.tracker.currentMood.value);
            return AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              color: currentTheme.backgroundColor,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: history.isEmpty
                        ? Center(
                            child: Text(
                              'No mood history yet',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          )
                        : ListView.separated(
                            itemCount: history.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final entry = history[index];
                              final mood = moodFromName(entry['mood']);
                              final moodTheme = getMoodTheme(mood);
                              final timestamp =
                                  DateTime.tryParse(entry['timestamp'] ?? '') ??
                                  DateTime.now();
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 600),
                                decoration: BoxDecoration(
                                  color: moodTheme.cardColor,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border(
                                    left: BorderSide(
                                      color: moodTheme.primaryColor,
                                      width: 6,
                                    ),
                                  ),
                                ),
                                child: ListTile(
                                  title: Text(
                                    '${moodTheme.emoji} ${moodLabel(mood)}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                  subtitle: Text(
                                    formatHistoryTimestamp(timestamp),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: history.isEmpty
                        ? null
                        : () async {
                            final messenger = ScaffoldMessenger.of(context);
                            await widget.tracker.clearHistory();
                            if (!mounted) {
                              return;
                            }
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Mood history cleared'),
                              ),
                            );
                          },
                    child: const Text('Clear History'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class MoodStatusCard extends StatefulWidget {
  const MoodStatusCard({
    super.key,
    required this.mood,
    required this.updatedAt,
    required this.description,
  });

  final MoodState mood;
  final DateTime updatedAt;
  final String description;

  @override
  State<MoodStatusCard> createState() => _MoodStatusCardState();
}

class _MoodStatusCardState extends State<MoodStatusCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _blinkController;
  late final Animation<double> _blinkAnimation;

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _blinkAnimation = CurvedAnimation(
      parent: _blinkController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moodTheme = getMoodTheme(widget.mood);
    final timeOfDay = TimeOfDay.fromDateTime(widget.updatedAt).format(context);
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: moodTheme.cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        moodTheme.emoji,
                        style: const TextStyle(fontSize: 34),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.mood == MoodState.calibrating
                                  ? 'Calibrating...'
                                  : moodLabel(widget.mood),
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Last updated $timeOfDay',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: moodTheme.textColor.withValues(
                                      alpha: 0.75,
                                    ),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.description,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: moodTheme.appBarColor,
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FadeTransition(
                      opacity: _blinkAnimation,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'LIVE TRACKING',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
  });

  final String label;
  final String value;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final theme = getMoodTheme(BehaviorTracker.instance.currentMood.value);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  value,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 10,
                backgroundColor: theme.primaryColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(theme.primaryColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MoodChip extends StatelessWidget {
  const MoodChip({
    super.key,
    required this.label,
    required this.mood,
    required this.isSelected,
    required this.onTap,
    required this.onPointerDown,
  });

  final String label;
  final MoodState mood;
  final bool isSelected;
  final VoidCallback onTap;
  final ValueChanged<double> onPointerDown;

  @override
  Widget build(BuildContext context) {
    final moodTheme = getMoodTheme(mood);
    return Listener(
      onPointerDown: (event) => onPointerDown(event.pressure),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onTap(),
        selectedColor: moodTheme.primaryColor,
        backgroundColor: moodTheme.cardColor,
        labelStyle: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: isSelected ? Colors.white : moodTheme.textColor,
          fontWeight: FontWeight.w700,
        ),
        side: BorderSide(color: moodTheme.primaryColor.withValues(alpha: 0.35)),
      ),
    );
  }
}

class MoodIndicator extends StatelessWidget {
  const MoodIndicator({super.key, required this.mood});

  final MoodState mood;

  @override
  Widget build(BuildContext context) {
    final moodTheme = getMoodTheme(mood);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 600),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: moodTheme.cardColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: moodTheme.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(moodTheme.emoji, style: const TextStyle(fontSize: 28)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current inferred mood',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  mood == MoodState.calibrating
                      ? 'Calibrating...'
                      : moodLabel(mood),
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  moodTheme.description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
