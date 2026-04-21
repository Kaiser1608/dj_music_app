import 'package:flutter/material.dart';

class DJMixerScreen extends StatelessWidget {
  const DJMixerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF111111),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("DJ Mixer"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          buildTopBar(),
          Expanded(
            child: Row(
              children: [
                Expanded(child: buildDeck(Colors.cyanAccent)),
                buildCenterMixer(),
                Expanded(child: buildDeck(Colors.pinkAccent)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTopBar() {
    return Container(
      height: 60,
      color: Colors.black87,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const [
          Text("Music", style: TextStyle(color: Colors.cyanAccent)),
          Text("00:00", style: TextStyle(color: Colors.cyanAccent)),
          Text("Music", style: TextStyle(color: Colors.pinkAccent)),
          Text("00:00", style: TextStyle(color: Colors.pinkAccent)),
        ],
      ),
    );
  }

  Widget buildDeck(Color accentColor) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          /// Jog wheel
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white54, width: 4),
              gradient: RadialGradient(
                colors: [
                  Colors.grey.shade800,
                  Colors.black,
                ],
              ),
            ),
            child: Center(
              child: Text(
                "0.0\nBPM",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: accentColor,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// Control buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              buildButton("CUE", Colors.orange),
              buildButton("PLAY", Colors.green),
            ],
          ),

          const SizedBox(height: 20),

          /// Pads
          Expanded(
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 6,
              mainAxisSpacing: 6,
              childAspectRatio: 1.8,
              children: List.generate(
                8,
                (index) => Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: accentColor),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "${index + 1}",
                    style: TextStyle(color: accentColor),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCenterMixer() {
    return Container(
      width: 140,
      color: Colors.black87,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildKnob("GAIN"),
          buildSlider(Colors.cyanAccent),
          buildSlider(Colors.pinkAccent),
          buildKnob("VOL"),
          buildCrossFader(),
        ],
      ),
    );
  }

  Widget buildKnob(String label) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.grey.shade800,
            border: Border.all(color: Colors.white24),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget buildSlider(Color color) {
    return SizedBox(
      height: 100,
      child: RotatedBox(
        quarterTurns: 3,
        child: Slider(
          value: 0.5,
          onChanged: (_) {},
          activeColor: color,
          inactiveColor: Colors.white24,
        ),
      ),
    );
  }

  Widget buildCrossFader() {
    return Slider(
      value: 0.5,
      onChanged: (_) {},
      activeColor: Colors.blueAccent,
      inactiveColor: Colors.white24,
    );
  }

  Widget buildButton(String text, Color color) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 3),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}