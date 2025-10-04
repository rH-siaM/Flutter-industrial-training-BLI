import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/notes/presentation/note_list/note_list_screen.dart';
import '../features/notes/presentation/note_detail/note_detail_screen.dart';
import '../features/notes/presentation/note_detail/add_note_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/notes/data/note_model.dart';

final appRouter = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NoteListScreen(),
    ),
    GoRoute(
      path: '/add',
      builder: (context, state) => const AddNoteScreen(),
    ),
    GoRoute(
      path: '/detail',
      builder: (context, state) {
        final note = state.extra as Note?;
        if (note == null) {
          return const Scaffold(
            body: Center(child: Text('Note not found')),
          );
        }
        return NoteDetailScreen(note: note);
      },
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
  ],
);