import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DJMixerScreen extends StatefulWidget {
  const DJMixerScreen({super.key});

  @override
  State<DJMixerScreen> createState() => _DJMixerScreenState();
}

class _DJMixerScreenState extends State<DJMixerScreen> {
  @override
  void initState() {
    super.initState();
    // Force landscape when entering this screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    // Restore portrait when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  // --- State for active pad mode tabs ---
  int _leftPadMode = 0; // 0=HOT CUES, 1=LOOP, 2=SAMPLER1, 3=SAMPLER2
  int _rightPadMode = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Row(
                children: [
                  // LEFT DECK
                  Expanded(child: _buildDeck(isLeft: true)),
                  // CENTER MIXER
                  _buildCenterMixer(),
                  // RIGHT DECK
                  Expanded(child: _buildDeck(isLeft: false)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ───────────────────────────────────────────────
  Widget _buildAppBar() {
  return Container(
    height: 38,
    color: Colors.black,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    child: Row(
      children: [
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 20,
          ),
        ),
      ],
    ),
  );
}

  // ─── DECK ──────────────────────────────────────────────────
  Widget _buildDeck({required bool isLeft}) {
    final accent = isLeft ? const Color(0xFF00E5FF) : const Color(0xFFFF1493);
    final padMode = isLeft ? _leftPadMode : _rightPadMode;

    // Right deck pad labels differ
    final List<List<String>> padLabels = isLeft
        ? [
            ['1', '2', '3', '4'],
            ['5', '6', '7', '8'],
          ]
        : [
            ['1/8', '1/4', '1/2', '1'],
            ['2', '4', '8', '16'],
          ];

    final List<Color> padColors = isLeft
        ? [
            Colors.cyan,
            Colors.green,
            Colors.orange,
            Colors.purple,
            Colors.red,
            Colors.blue,
            Colors.yellow,
            Colors.pink,
          ]
        : [
            Colors.cyan,
            Colors.green,
            Colors.orange,
            Colors.green,
            Colors.blue,
            Colors.purple,
            Colors.red,
            Colors.yellow,
          ];

    return Container(
      color: const Color(0xFF1C1C1C),
      child: Column(
        children: [
          // Top bar: Music label + time
          _buildDeckTopBar(accent, isLeft),
          // Main content
          Expanded(
            child: Row(
              children: [
                // Left side buttons + jog wheel
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      _buildInOutReloopRow(accent, isLeft),
                      const SizedBox(height: 4),
                      Expanded(child: _buildJogWheel(accent)),
                      const SizedBox(height: 4),
                      _buildModeAndTrackRow(accent),
                    ],
                  ),
                ),
                // Pitch fader
                _buildPitchFader(isLeft),
              ],
            ),
          ),
          // Bottom section: CUE, pad mode tabs, pads, FX/RESET
          _buildBottomSection(
            accent: accent,
            isLeft: isLeft,
            padMode: padMode,
            padLabels: padLabels,
            padColors: padColors,
          ),
        ],
      ),
    );
  }

  Widget _buildDeckTopBar(Color accent, bool isLeft) {
    return Container(
      height: 28,
      color: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Music',
              style: TextStyle(
                  color: accent, fontWeight: FontWeight.bold, fontSize: 13)),
          Text('00:00',
              style: TextStyle(color: accent, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildInOutReloopRow(Color accent, bool isLeft) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
    child: Row(
      children: [
        _smallButton('IN', Colors.orange),
        const SizedBox(width: 2),
        _smallButton('OUT', Colors.orange),
        const SizedBox(width: 2),
        _smallButton('RELOOP', Colors.green, wide: true),

        const SizedBox(width: 4),

        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text(
                'PITCH',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 8,
                ),
              ),
              const SizedBox(width: 2),
              _iconButton(Icons.remove, size: 10),
              const SizedBox(width: 2),
              _iconButton(Icons.add, size: 10),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _buildModeAndTrackRow(Color accent) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('MODE',
                  style: TextStyle(color: Colors.white54, fontSize: 9)),
              Row(children: [
                _modeButton(Icons.repeat),
                const SizedBox(width: 4),
                _modeButton(Icons.shuffle),
              ]),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text('TRACK',
                  style: TextStyle(color: Colors.white54, fontSize: 9)),
              Row(children: [
                _modeButton(Icons.skip_previous),
                const SizedBox(width: 4),
                _modeButton(Icons.skip_next),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildJogWheel(Color accent) {
    return Center(
      child: Container(
        width: 130,
        height: 130,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              Colors.grey.shade700,
              Colors.grey.shade900,
              Colors.black,
            ],
            stops: const [0.0, 0.6, 1.0],
          ),
          border: Border.all(color: Colors.white24, width: 3),
          boxShadow: [
            BoxShadow(
              color: accent.withOpacity(0.15),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Outer ring details
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white12, width: 1),
              ),
            ),
            // Inner circle
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.shade800,
                border: Border.all(color: Colors.white24, width: 1.5),
              ),
              child: Center(
                child: Text(
                  '0.0\nBPM',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPitchFader(bool isLeft) {
    return SizedBox(
      width: 36,
      child: Container(
        color: const Color(0xFF141414),
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // SYNC / PITCH buttons - constrained width
            Column(
              children: [
                _syncPitchButton('SYNC'),
                const SizedBox(height: 3),
                _syncPitchButton('PITCH'),
              ],
            ),
            // Pitch fader track
            Expanded(
              child: Center(
                child: Container(
                  width: 6,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 12,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade600,
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white38),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _syncPitchButton(String text) {
    return Container(
      width: 32,
      padding: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white70, fontSize: 6),
      ),
    );
  }

  Widget _buildBottomSection({
    required Color accent,
    required bool isLeft,
    required int padMode,
    required List<List<String>> padLabels,
    required List<Color> padColors,
  }) {
    final tabs = ['HOT CUES', 'LOOP', 'SAMPLER1', 'SAMPLER2'];
    final tabColors = [Colors.cyan, Colors.orange, Colors.green, Colors.purple];

    return Container(
      color: const Color(0xFF141414),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          // CUE button
          _bigCircleButton('CUE', Colors.orange),
          const SizedBox(width: 6),
          // Pad mode tabs + pads
          Expanded(
            child: Column(
              children: [
                // Tab row
                Row(
                  children: List.generate(tabs.length, (i) {
                    final active = i == padMode;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() {
                          if (isLeft) _leftPadMode = i;
                          else _rightPadMode = i;
                        }),
                        child: Container(
                          margin: const EdgeInsets.only(right: 2),
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          decoration: BoxDecoration(
                            color: active ? tabColors[i] : Colors.transparent,
                            border: Border.all(
                              color: active ? tabColors[i] : Colors.white24,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Text(
                            tabs[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: active ? Colors.black : Colors.white60,
                              fontSize: 7,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 3),
                // Pad rows
                ...List.generate(2, (row) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Row(
                      children: List.generate(4, (col) {
                        final idx = row * 4 + col;
                        final c = padColors[idx % padColors.length];
                        return Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 2),
                            height: 22,
                            decoration: BoxDecoration(
                              border: Border.all(color: c, width: 1.5),
                              borderRadius: BorderRadius.circular(3),
                              color: Colors.black,
                            ),
                            child: Center(
                              child: Text(
                                padLabels[row][col],
                                style: TextStyle(
                                    color: c,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(width: 6),
          // RESET / FX column
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _smallLabelButton('RESET', Colors.white54),
              const SizedBox(height: 4),
              _smallLabelButton('FX', accent),
            ],
          ),
        ],
      ),
    );
  }

  // ─── CENTER MIXER ──────────────────────────────────────────
  Widget _buildCenterMixer() {
    return Container(
      width: 160,
      color: const Color(0xFF111111),
      child: Column(
        children: [
          // Top knobs row: FILTER, GAIN, GAIN, FILTER
          _buildTopKnobsRow(),
          // EQ + Volume faders
          Expanded(child: _buildMixerFaders()),
          // Waveform icon + REC + loop
          _buildMixerActionRow(),
          // Crossfader
          _buildCrossfader(),
        ],
      ),
    );
  }

  Widget _buildTopKnobsRow() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _knobWithLabel('FILTER', size: 28),
          _knobWithLabel('GAIN', size: 30, highlight: Colors.cyan),
          _knobWithLabel('GAIN', size: 30, highlight: Colors.pink),
          _knobWithLabel('FILTER', size: 28),
        ],
      ),
    );
  }

  Widget _buildMixerFaders() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          // Left EQ (TREBLE, MID, BASS)
          Expanded(child: _buildEQColumn(isCyan: true)),
          // Volume faders
          _buildVolumeFaders(),
          // Right EQ
          Expanded(child: _buildEQColumn(isCyan: false)),
        ],
      ),
    );
  }

  Widget _buildEQColumn({required bool isCyan}) {
    final labels = ['TREBLE', 'MID', 'BASS'];
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: labels
          .map((l) => Column(
                children: [
                  _knobWithLabel(l, size: 22),
                  const SizedBox(height: 2),
                ],
              ))
          .toList(),
    );
  }

  Widget _buildVolumeFaders() {
    return SizedBox(
      width: 60,
      child: Column(
        children: [
          // VU meters (fake bars)
          Expanded(
            flex: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _vuMeter(Colors.cyan),
                const SizedBox(width: 2),
                // VOLUME knob in middle
                _knobOnly(Colors.blue, size: 32),
                const SizedBox(width: 2),
                _vuMeter(Colors.pink),
              ],
            ),
          ),
          // Channel faders
          Expanded(
            flex: 4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _verticalFader(Colors.cyan),
                _verticalFader(Colors.pink),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _vuMeter(Color color) {
    final levels = [0.9, 0.8, 0.6, 0.4, 0.3, 0.2];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: levels.map((h) {
        return Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.only(bottom: 1),
          color: color.withOpacity(h),
        );
      }).toList(),
    );
  }

  Widget _verticalFader(Color color) {
    return SizedBox(
      width: 14,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 3,
            height: double.infinity,
            color: Colors.white12,
          ),
          Container(
            width: 12,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMixerActionRow() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconCircleButton(Icons.music_note, Colors.cyan),
          _iconCircleButton(Icons.music_note, Colors.pink),
        ],
      ),
    );
  }

  Widget _buildCrossfader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        children: [
          // Action buttons row: EQ icon, REC, loop icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _iconButton(Icons.tune, size: 16),
              _recButton(),
              _iconButton(Icons.loop, size: 16),
            ],
          ),
          const SizedBox(height: 6),
          // A ──slider── B
          Row(
            children: [
              const Text('< A',
                  style: TextStyle(color: Colors.cyan, fontSize: 10)),
              Expanded(
                child: Container(
                  height: 10,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      // Fill left side cyan
                      FractionallySizedBox(
                        widthFactor: 0.45,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.cyan.withOpacity(0.6),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(5),
                              bottomLeft: Radius.circular(5),
                            ),
                          ),
                        ),
                      ),
                      // Thumb
                      Positioned(
                        left: MediaQuery.of(context).size.width * 0 + 60,
                        child: Container(
                          width: 12,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Text('B >',
                  style: TextStyle(color: Colors.pink, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }

  // ─── HELPER WIDGETS ────────────────────────────────────────

  Widget _knobWithLabel(String label,
      {double size = 28, Color? highlight}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _knobOnly(highlight ?? Colors.grey.shade600, size: size),
        const SizedBox(height: 2),
        Text(label,
            style: const TextStyle(color: Colors.white54, fontSize: 7)),
      ],
    );
  }

  Widget _knobOnly(Color color, {double size = 28}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            color.withOpacity(0.6),
            Colors.grey.shade900,
            Colors.black,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 4,
          )
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.25,
          height: size * 0.25,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white24,
          ),
        ),
      ),
    );
  }

  Widget _smallButton(String text, Color color, {bool wide = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: wide ? 6 : 5, vertical: 3),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: const TextStyle(
              color: Colors.black, fontSize: 8, fontWeight: FontWeight.bold)),
    );
  }

  Widget _iconButton(IconData icon, {double size = 14}) {
    return Container(
      width: size + 8,
      height: size + 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade800,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white70, size: size),
    );
  }

  Widget _modeButton(IconData icon) {
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade800,
        border: Border.all(color: Colors.white24),
      ),
      child: Icon(icon, color: Colors.white70, size: 14),
    );
  }

  Widget _tinyLabelButton(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(text,
          style: const TextStyle(color: Colors.white70, fontSize: 7)),
    );
  }

  Widget _bigCircleButton(String text, Color color) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 2.5),
        color: Colors.black,
      ),
      child: Center(
        child: Text(text,
            style: TextStyle(
                color: color, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _smallLabelButton(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(text,
          style: TextStyle(
              color: color, fontSize: 9, fontWeight: FontWeight.bold)),
    );
  }

  Widget _iconCircleButton(IconData icon, Color color) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.5),
        color: Colors.black,
      ),
      child: Icon(icon, color: color, size: 14),
    );
  }

  Widget _recButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.red.shade400),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red,
            ),
          ),
          const SizedBox(width: 3),
          const Text('REC',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 9,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}