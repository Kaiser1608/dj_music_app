import 'package:flutter/material.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool recordCompleted = false;
  bool notificationBar = true;
  bool englishLanguage = false;
  bool hideUpdateReminder = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF050518),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              buildHeader(),
              const SizedBox(height: 20),

              buildSectionTitle("General"),
              buildTile(icon: Icons.qr_code_scanner, title: "Scan Library"),

              const SizedBox(height: 20),
              buildSectionTitle("Record"),

              buildSwitchTile(
                icon: Icons.radio_button_checked,
                title: "View the Recording after it's completed",
                value: recordCompleted,
                onChanged: (v) => setState(() => recordCompleted = v),
              ),

              buildTile(icon: Icons.videocam, title: "Record Format", trailingText: "MP3"),
              buildTile(icon: Icons.mic, title: "Record Type", trailingText: "Internal Audio"),
              buildTile(icon: Icons.folder, title: "Record Path", trailingText: "/storage/..."),

              const SizedBox(height: 20),
              buildSectionTitle("Audio"),

              buildSwitchTile(
                icon: Icons.music_note,
                title: "Use Notification Bar to Play Music",
                value: notificationBar,
                onChanged: (v) => setState(() => notificationBar = v),
              ),

              const SizedBox(height: 20),
              buildSectionTitle("Others"),

              buildSwitchTile(
                icon: Icons.language,
                title: "Use English Language",
                value: englishLanguage,
                onChanged: (v) => setState(() => englishLanguage = v),
              ),

              buildSwitchTile(
                icon: Icons.notifications_off,
                title: "Hide Update Reminder",
                value: hideUpdateReminder,
                onChanged: (v) => setState(() => hideUpdateReminder = v),
              ),

              buildTile(icon: Icons.settings, title: "Check for Update"),
              buildTile(icon: Icons.feedback, title: "Feedback"),
              buildTile(icon: Icons.star, title: "Rate Us"),
              buildTile(icon: Icons.share, title: "Share App"),
              buildTile(icon: Icons.description, title: "Terms of Service"),
              buildTile(icon: Icons.security, title: "Privacy Policy"),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Setting",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
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
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    String? trailingText,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF141422),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black26,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          if (trailingText != null)
            Text(
              trailingText,
              style: const TextStyle(color: Colors.white54, fontSize: 12),
            ),
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }

  Widget buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF141422),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.black26,
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(title, style: const TextStyle(color: Colors.white)),
          ),
          Switch(
            value: value,
            activeColor: Colors.blue,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}