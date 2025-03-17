// lib/widgets/settings_screen.dart (Riverpod 사용 버전)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Riverpod을 통해 현재 테마 상태를 읽습니다.
    final currentTheme = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(title: Text('테마 설정')),
      body: Column(
        children: [
          RadioListTile<ThemeMode>(
            title: Text('Light Mode'),
            value: ThemeMode.light,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setTheme(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('Dark Mode'),
            value: ThemeMode.dark,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setTheme(value);
              }
            },
          ),
          RadioListTile<ThemeMode>(
            title: Text('System Default'),
            value: ThemeMode.system,
            groupValue: currentTheme,
            onChanged: (ThemeMode? value) {
              if (value != null) {
                ref.read(themeModeProvider.notifier).setTheme(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
