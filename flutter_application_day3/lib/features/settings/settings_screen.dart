import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: isDark,
            onChanged: (_) =>
                ref.read(themeModeProvider.notifier).toggleTheme(),
          ),
          const SizedBox(height: 16),
          Text(
            'Font Size',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            value: fontScale,
            min: 0.8,
            max: 3.0,
            divisions: 7,
            label: "${(fontScale * 100).round()}%",
            onChanged: (newScale) {
              ref.read(fontScaleProvider.notifier).setFontScale(newScale);
            },
          ),
          Text(
            'Preview text (size ${(fontScale * 100).round()}%)',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
