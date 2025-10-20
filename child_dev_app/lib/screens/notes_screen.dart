import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/note.dart';
import '../providers/state_providers.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  final _controller = TextEditingController();
  String _mood = '🙂';

  @override
  Widget build(BuildContext context) {
    final notes = ref.watch(notesStateProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Parent Notes')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(hintText: 'Add a quick note...'),
                  ),
                ),
                const SizedBox(width: 8),
                DropdownButton<String>(
                  value: _mood,
                  items: const [
                    '😀',
                    '🙂',
                    '😐',
                    '😕',
                    '😴',
                  ].map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                  onChanged: (v) => setState(() => _mood = v ?? '🙂'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: _addNote, child: const Text('Add')),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return ListTile(
                  leading: Text(note.mood ?? '🙂', style: const TextStyle(fontSize: 22)),
                  title: Text(note.text),
                  subtitle: Text(note.createdAt.toLocal().toString()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    ref
        .read(notesStateProvider.notifier)
        .add(
          NoteEntry(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            text: text,
            mood: _mood,
            authorUid: 'local',
            createdAt: DateTime.now(),
          ),
        );
    _controller.clear();
  }
}
