import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router.dart';
import 'core/theme.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch both theme mode and font scale
    final isDark = ref.watch(themeModeProvider);
    final fontScale = ref.watch(fontScaleProvider);
    
    // Build theme dynamically based on current settings
    final theme = isDark ? buildDarkTheme(fontScale) : buildLightTheme(fontScale);

    return MaterialApp.router(
      title: 'Notes App',
      theme: theme,
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}