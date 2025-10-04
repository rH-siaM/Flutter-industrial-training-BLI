import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/notes/domain/note_provider.dart';
import 'theme.dart';

// Common providers available globally
final notesProvider = noteProvider;
final appThemeProvider = themeProvider;
