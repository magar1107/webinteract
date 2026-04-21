Here is your complete Flutter app prompt — copy this entire prompt and paste it into Claude or any AI coding tool:

---

**PROMPT:**

Build a complete Flutter Android app (supports Android 9 to Android 16, minSdkVersion 28, targetSdkVersion 35) for an Emotion-Adaptive Interface System. The app must run fully offline with no backend. Use only Flutter and Dart with no external packages except `shared_preferences` and `google_fonts`. Here are the exact requirements:

---

**APP NAME:** MindUI — Emotion Adaptive Interface

---

**SCREEN 1 — Splash Screen**
- Full screen with app logo (brain icon using Flutter Icons)
- App name "MindUI" in large bold text center
- Tagline: "Your interface adapts to you"
- Animated fade-in on load, auto-navigate to Home after 2.5 seconds
- Background color adapts based on last saved mood state from shared_preferences

---

**SCREEN 2 — Home Dashboard Screen**
- AppBar with title "MindUI Dashboard", brain icon on left, settings icon button on top right
- Below AppBar show a Mood Status Card (full width, rounded corners radius 16, elevation 4) showing: current detected mood label (CALM / FOCUSED / OVERLOADED / ANXIOUS / FATIGUED), mood emoji, last updated time, and a subtitle description of what the mood means
- Below that show a row of 5 MoodChip buttons (small rounded chips): Calm, Focused, Overloaded, Anxious, Fatigued — tapping any chip manually sets the mood for testing
- Below that show a section title "Behavior Tracking Live"
- Show 5 MetricTile cards in a vertical list, each showing label + current value + a LinearProgressIndicator bar:
  1. Tap Speed (taps per minute)
  2. Tap Pressure (light / medium / hard)
  3. Scroll Velocity (slow / normal / fast)
  4. Navigation Backtrack Count (number)
  5. Idle Time (seconds since last action)
- At bottom a large ElevatedButton "Start Tracking Session" that navigates to Screen 3
- FloatingActionButton with refresh icon that resets all metrics
- All colors, text styles, AppBar color, card color, chip colors, button colors must change dynamically based on current detected mood using the mood theme system described below

---

**SCREEN 3 — Interactive Task Screen (Behavior Tracking Active)**
- AppBar title "Active Session", back button
- This screen actively tracks user behavior while they interact
- Show a paragraph of dummy text (3–4 sentences about any topic) in a scrollable SingleChildScrollView — user scrolling this text is tracked for scroll velocity
- Below the text show 6 action buttons in a GridView 2-column layout:
  Button 1: "Read Article" (icon: article)
  Button 2: "Take Quiz" (icon: quiz)
  Button 3: "View Chart" (icon: bar_chart)
  Button 4: "Open Settings" (icon: settings)
  Button 5: "Go Back" (icon: arrow_back)
  Button 6: "Help" (icon: help)
- Each button tap is recorded with timestamp for tap speed calculation
- Below the grid show a TextField with label "Type your thoughts here" — typing speed is measured by counting characters typed per second using onChanged
- Below that show a real-time Mood Indicator widget: a large rounded container showing current inferred mood with icon, label, and animated color transition using AnimatedContainer with duration 600ms
- Show a row of 3 stat chips at bottom: Taps, Scroll Events, Keystrokes — updating live
- All colors adapt to current mood theme

---

**SCREEN 4 — Mood History Screen**
- Accessible from Settings icon on Home
- AppBar title "Mood History"
- Show a ListView of mood log entries saved in shared_preferences
- Each entry shows: mood label, emoji, timestamp, and a colored left border strip matching mood color
- Show a "Clear History" button at bottom
- If no history exists show centered text "No mood history yet"

---

**BEHAVIOR TRACKING ENGINE — implement as a singleton service class called BehaviorTracker**

Track these signals:

1. `recordTap()` — called on every button tap. Stores tap timestamps in a list. Calculates taps per minute from last 10 taps. If taps per minute > 30 = ANXIOUS signal. If 15–30 = FOCUSED. If < 10 = CALM or FATIGUED.

2. `recordScroll(double velocity)` — called on scroll. If velocity > 800 = OVERLOADED signal. If 300–800 = FOCUSED. If < 300 = CALM.

3. `recordKeystroke()` — called on every character typed. Tracks keystrokes per 10 seconds. If > 40 = FOCUSED. If < 10 = FATIGUED.

4. `recordBackNavigation()` — called when user navigates back. If back count > 3 in 60 seconds = ANXIOUS or OVERLOADED.

5. `updateIdleTime()` — runs on a Timer.periodic every second. Counts seconds since last action. If idle > 30 seconds = FATIGUED signal.

6. `inferMood()` — combines all signals using a weighted scoring system:
   - Collect the last signal from each tracker
   - Score each mood: CALM, FOCUSED, OVERLOADED, ANXIOUS, FATIGUED
   - Return the mood with the highest score
   - Call this every 5 seconds using a Timer.periodic and update the current mood using a ValueNotifier<MoodState>

---

**MOOD STATE ENUM — MoodState**
```
enum MoodState { calm, focused, overloaded, anxious, fatigued }
```

---

**MOOD THEME SYSTEM — implement a getMoodTheme(MoodState mood) function that returns a MoodTheme object containing:**

For CALM:
- primaryColor: Color(0xFF4CAF50) green
- backgroundColor: Color(0xFFE8F5E9) light green
- cardColor: Color(0xFFC8E6C9)
- textColor: Color(0xFF1B5E20) dark green
- appBarColor: Color(0xFF388E3C)
- buttonColor: Color(0xFF43A047)
- emoji: "😌"
- description: "You are calm and relaxed. Interface is in default mode."

For FOCUSED:
- primaryColor: Color(0xFF1976D2) blue
- backgroundColor: Color(0xFFE3F2FD) light blue
- cardColor: Color(0xFFBBDEFB)
- textColor: Color(0xFF0D47A1) dark blue
- appBarColor: Color(0xFF1565C0)
- buttonColor: Color(0xFF1E88E5)
- emoji: "🎯"
- description: "You are in deep focus. Advanced options are enabled."

For OVERLOADED:
- primaryColor: Color(0xFFF57C00) orange
- backgroundColor: Color(0xFFFFF3E0) light orange
- cardColor: Color(0xFFFFE0B2)
- textColor: Color(0xFFE65100) dark orange
- appBarColor: Color(0xFFEF6C00)
- buttonColor: Color(0xFFFF8F00)
- emoji: "😵"
- description: "You seem overloaded. Simplifying the interface."

For ANXIOUS:
- primaryColor: Color(0xFF7B1FA2) purple
- backgroundColor: Color(0xFFF3E5F5) light purple
- cardColor: Color(0xFFE1BEE7)
- textColor: Color(0xFF4A148C) dark purple
- appBarColor: Color(0xFF6A1B9A)
- buttonColor: Color(0xFF8E24AA)
- emoji: "😰"
- description: "You seem anxious. Reducing alerts and softening colors."

For FATIGUED:
- primaryColor: Color(0xFF455A64) blue grey
- backgroundColor: Color(0xFFECEFF1) light grey
- cardColor: Color(0xFFCFD8DC)
- textColor: Color(0xFF263238) dark grey
- appBarColor: Color(0xFF37474F)
- buttonColor: Color(0xFF546E7A)
- emoji: "😴"
- description: "You seem fatigued. Consider taking a short break."

---

**STATE MANAGEMENT**
- Use a single ValueNotifier<MoodState> called `currentMood` in BehaviorTracker
- Wrap entire MaterialApp in ValueListenableBuilder listening to currentMood
- On mood change, rebuild entire app theme using ThemeData generated from getMoodTheme()
- Use AnimatedContainer with 600ms duration for smooth color transitions on all cards and containers

---

**NAVIGATION**
- Use Navigator.push for all screen transitions
- Pass BehaviorTracker instance via constructor injection to all screens
- Back button on Screen 3 calls recordBackNavigation() before popping

---

**FILE STRUCTURE — single file approach, put everything in main.dart**
Order of classes in main.dart:
1. main() and MyApp
2. MoodState enum
3. MoodTheme class
4. getMoodTheme() function
5. BehaviorTracker singleton class
6. SplashScreen
7. HomeScreen
8. TaskScreen
9. MoodHistoryScreen
10. Reusable widgets: MoodStatusCard, MetricTile, MoodChip, MoodIndicator

---

**ADDITIONAL REQUIREMENTS**
- minSdkVersion 28 in android/app/build.gradle
- targetSdkVersion 35
- No internet permission needed
- App must handle screen rotation without losing state using AutomaticKeepAliveClientMixin where needed
- Use SafeArea on all screens
- All text must use Google Fonts — use `Poppins` font family throughout
- Add a banner/ribbon on MoodStatusCard saying "LIVE TRACKING" with a blinking red dot animation using AnimationController repeat
- Timer must be properly cancelled in dispose() on all stateful widgets

---

Generate the complete working main.dart file with all classes, all screens, full behavior tracking logic, mood inference engine, full theme switching, and all UI components. Make sure it compiles and runs without errors on Flutter 3.x targeting Android 9 to Android 16.

Looking at your Claude Code output — this is the implementation plan. Here's exactly what you need to do:Here is the precise scoring formula your `BehaviorTracker` Dart code must use, with exact numbers for every signal and weight. Give this directly to Claude Code as your next prompt:

---

**PASTE THIS EXACT PROMPT INTO CLAUDE CODE:**

```
Update the BehaviorTracker class in main.dart with these EXACT precise numbers for 
all behavior signals and the weighted scoring formula. Do not change anything else.

---

SIGNAL 1 — TAP INTERVAL (time between taps in milliseconds)
Use the last recorded interval between consecutive taps.

  intervalScore(ms):
    ms > 5000     → FATIGUED  += 25
    2000–5000     → CALM      += 25
    800–2000      → FOCUSED   += 25
    300–800       → OVERLOADED+= 25
    < 300         → ANXIOUS   += 25

---

SIGNAL 2 — TAP SPEED (taps per minute, calculated from last 10 tap timestamps)
  tpm = (tapCount - 1) / ((lastTapTime - firstTapTime) / 60000)

  tapSpeedScore(tpm):
    tpm == 0 or no taps yet → skip signal
    0–5    → FATIGUED   += 25
    6–12   → CALM       += 25
    13–25  → FOCUSED    += 25
    26–40  → OVERLOADED += 25
    41+    → ANXIOUS    += 25

---

SIGNAL 3 — SCROLL VELOCITY (pixels per second, absolute value)
  scrollScore(px/s):
    0–80    → FATIGUED   += 20
    81–200  → CALM       += 20
    201–500 → FOCUSED    += 20
    501–900 → OVERLOADED += 20
    901+    → ANXIOUS    += 20

---

SIGNAL 4 — TYPING SPEED (keystrokes in last 10 seconds)
  typingScore(count):
    0–5   → FATIGUED   += 15
    6–15  → CALM       += 15
    16–35 → FOCUSED    += 15
    36–55 → OVERLOADED += 15
    56+   → ANXIOUS    += 15

---

SIGNAL 5 — BACKSPACE RATIO (backspaces / total keystrokes × 100)
  Only calculate if totalKeystrokes >= 10, else skip.

  errorScore(ratio %):
    0–5%   → CALM or FOCUSED (whichever already leads) += 10
    6–15%  → OVERLOADED += 10
    16–25% → ANXIOUS    += 10
    26%+   → ANXIOUS    += 10, FATIGUED += 5

---

SIGNAL 6 — IDLE TIME (seconds since last any recorded action)
  idleScore(seconds):
    0–8    → FOCUSED    += 5
    9–45   → CALM       += 5
    46–90  → FATIGUED   += 5
    91+    → FATIGUED   += 10 (double weight, override candidate)

---

SIGNAL 7 — BACK NAVIGATION COUNT (back presses in last 60 seconds)
  backNavScore(count):
    0–1  → CALM or FOCUSED += 5
    2–3  → OVERLOADED      += 5
    4–5  → ANXIOUS         += 5
    6+   → ANXIOUS         += 10

---

FINAL MOOD INFERENCE — inferMood() method:

  Step 1: Create score map:
    Map<MoodState, double> scores = {
      MoodState.calm: 0,
      MoodState.focused: 0,
      MoodState.overloaded: 0,
      MoodState.anxious: 0,
      MoodState.fatigued: 0,
    };

  Step 2: Add all signal scores above to the map.

  Step 3: Apply OVERRIDE RULES before picking winner:
    - If idleTime > 90 seconds → force return MoodState.fatigued immediately
    - If ANXIOUS score >= 45 → confirmationBuffer not needed, switch immediately
    - All other moods require 3 consecutive confirmations (mood lock rule)

  Step 4: Pick winner:
    MoodState winner = scores.entries
      .reduce((a, b) => a.value >= b.value ? a : b).key;

  Step 5: Mood lock logic:
    - Keep a _pendingMood variable and _confirmCount integer
    - If winner == _pendingMood: _confirmCount++
    - Else: _pendingMood = winner, _confirmCount = 1
    - If _confirmCount >= 3: update currentMood.value = winner, reset _confirmCount = 0
    - Exception: if winner == ANXIOUS and _confirmCount >= 2: switch immediately
    - Exception: if idleTime > 90: switch immediately regardless

  Step 6: MINIMUM DATA GATE:
    - Do not run inferMood at all if:
        totalTaps < 5 AND sessionSeconds < 30
    - Instead set currentMood to a special MoodState.calibrating value
    - Show "Calibrating..." text in MoodStatusCard during this period

---

CALIBRATING STATE:
  Add MoodState.calibrating to the enum.
  In getMoodTheme(), handle MoodState.calibrating:
    primaryColor: Color(0xFF9E9E9E) grey
    backgroundColor: Color(0xFFF5F5F5)
    cardColor: Color(0xFFEEEEEE)
    textColor: Color(0xFF424242)
    appBarColor: Color(0xFF757575)
    buttonColor: Color(0xFF9E9E9E)
    emoji: "🔄"
    description: "Tracking your interactions... Please interact for 30 seconds."

---

TIMER SETUP in BehaviorTracker:
  _inferTimer = Timer.periodic(Duration(seconds: 5), (_) => inferMood());
  _idleTimer  = Timer.periodic(Duration(seconds: 1), (_) {
    _idleSeconds++;
    if (_idleSeconds > 90) inferMood(); // immediate override check
  });

  Reset _idleSeconds = 0 inside every recordTap(), recordScroll(), recordKeystroke().

---

TRACKING WINDOW LIMITS (prevent stale data):
  - Keep only the LAST 10 tap timestamps in the list. Remove oldest if list.length > 10.
  - Keep only keystrokes from the LAST 10 seconds. Use a timestamp queue, remove entries 
    older than DateTime.now().subtract(Duration(seconds: 10)).
  - Keep only back navigations from the LAST 60 seconds. Same timestamp queue approach.
  - Keep only the LAST scroll velocity value (single double, not a list).

---

All dispose() methods must cancel both _inferTimer and _idleTimer.
Make sure recordBackNavigation() is called in the WillPopScope or PopScope 
onWillPop callback on TaskScreen before Navigator.pop().
```

---

That is the complete precision scoring system. Paste it word for word into Claude Code and it will update only the `BehaviorTracker` logic without touching your UI or screens.
