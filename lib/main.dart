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
      "icon": Icons.album,
    },
    {
      "title": "Ringtone Cutter",
      "color": Colors.purple,
      "icon": Icons.content_cut,
    },
    {
      "title": "Audio Mixer",
      "color": Colors.orange,
      "icon": Icons.equalizer,
    },
    {
      "title": "Sound Merger",
      "color": Colors.yellow,
      "icon": Icons.headphones,
    },
    {
      "title": "My Library",
      "color": Colors.pink,
      "icon": Icons.library_music,
    },
    {
      "title": "Setting",
      "color": Colors.green,
      "icon": Icons.settings,
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
          Positioned.fill(
            child: Image.asset(
              'assets/images/backgroundpic.jpg',
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.65),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildTitle(),
                  const SizedBox(height: 20),
                  buildMainCard(context),
                  const SizedBox(height: 20),
                  buildGrid(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

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
            color: Colors.amber.withOpacity(0.2),
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

 Widget buildMainCard(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => const DJMixerScreen(),
        ),
      );
    },
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: Colors.cyanAccent, width: 2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "DJ Mixer",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Mix your music with advanced tools.",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.music_note,
            color: Colors.cyanAccent,
            size: 50,
          ),
        ],
      ),
    ),
  );
}

  Widget buildGrid(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: menuItems.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.1,
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
                MaterialPageRoute(
                  builder: (_) => const SettingScreen(),
                ),
              );
            }
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.25),
              border: Border.all(color: item["color"], width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item["icon"],
                  color: item["color"],
                  size: 36,
                ),
                const SizedBox(height: 10),
                Text(
                  item["title"],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
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