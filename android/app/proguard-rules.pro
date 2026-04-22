# ── Flutter ──────────────────────────────────────────────────
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.embedding.**

# ── Suppress SidecarWindowBackend NoClassDefFoundError ───────
-dontwarn androidx.window.sidecar.**
-dontwarn androidx.window.layout.adapter.sidecar.**
-keep class androidx.window.** { *; }

# ── file_picker ───────────────────────────────────────────────
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# ── Tắt log verbose không cần thiết ──────────────────────────
-assumenosideeffects class android.util.Log {
    public static int v(...);
    public static int d(...);
    public static int i(...);
}