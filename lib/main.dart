import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'setting_screen.dart';
import 'dj_mixer_screen.dart';

void main() {
  runApp(const DJApp());
}

class DJApp extends StatelessWidget {
  const DJApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {
      "title": "Drum Pad",
      "color": Colors.red,
      "image": "assets/images/drumpad.png",
    },
    {
      "title": "Ringtone Cutter",
      "color": Colors.purple,
      "image": "assets/images/cutter.png",
    },
    {
      "title": "Audio Mixer",
      "color": Colors.orange,
      "image": "assets/images/mixer.png",
    },
    {
      "title": "Sound Merger",
      "color": Colors.yellow,
      "image": "assets/images/merger.png",
    },
    {
      "title": "My Library",
      "color": Colors.pink,
      "image": "assets/images/library.png",
    },
    {
      "title": "Setting",
      "color": Colors.green,
      "image": "assets/images/setting.png",
    },
  ];

  Future<void> pickAudioFile(BuildContext context) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );

    if (result != null) {
      String fileName = result.files.single.name;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selected: $fileName"),
          backgroundColor: Colors.black87,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundpic.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Dark overlay
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildTitle(),
                  const SizedBox(height: 16),
                  buildMainCard(context),
                  const SizedBox(height: 16),
                  buildGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── TITLE ROW ────────────────────────────────────────────
  Widget buildTitle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "DJ Music",
          style: TextStyle(
            fontSize: 26,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.amber.withOpacity(0.3),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.workspace_premium,
            color: Colors.amber,
            size: 26,
          ),
        ),
      ],
    );
  }

  // ─── MAIN DJ MIXER CARD ───────────────────────────────────
 Widget buildMainCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const DJMixerScreen()),
      );
    },
    child: Stack(
      clipBehavior: Clip.none, // cho phép ảnh tràn ra ngoài
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            border: Border.all(color: Colors.cyanAccent, width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Row(
              children: const [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "DJ Mixer",
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      SizedBox(
                        width: 180,
                        child: Text(
                          "Mix your music with advanced tools,\neffects, and sound equalizer.",
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Ảnh DJ tràn ra ngoài box
        Positioned(
          right: -20,   // âm để tràn ra ngoài
          top: -25,  
          height: 200,   // âm để nhô lên trên
          child: Image.asset(
            'assets/images/djpic.png',
            height: 180,
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
  );
}

  // ─── MENU GRID ────────────────────────────────────────────
  Widget buildGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.05,
      ),
      itemBuilder: (context, index) {
        final item = menuItems[index];

        return GestureDetector(
          onTap: () {
            if (item["title"] == "Audio Mixer" ||
                item["title"] == "Sound Merger") {
              pickAudioFile(context);
            }
            if (item["title"] == "Setting") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingScreen()),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              border: Border.all(color: item["color"] as Color, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Image.asset(
                  item["image"] as String,
                  width: 72,
                  height: 72,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    color: item["color"] as Color,
                    size: 50,
                  ),
                ),
                const SizedBox(height: 10),
                // Title
                Text(
                  item["title"] as String,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}