import 'package:flutter/material.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({super.key});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final _emailController = TextEditingController();
  String _role = 'notesOnly';
  String? _code;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invite Co-Parent')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _role,
              items: const [
                DropdownMenuItem(value: 'full', child: Text('Full access')),
                DropdownMenuItem(value: 'notesOnly', child: Text('Notes-only')),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'notesOnly'),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _createInvite, child: const Text('Generate Invite Code')),
            if (_code != null) ...[
              const SizedBox(height: 16),
              SelectableText('Share this code: ${_code!}'),
            ],
          ],
        ),
      ),
    );
  }

  void _createInvite() {
    setState(() {
      _code = DateTime.now().millisecondsSinceEpoch.toRadixString(36).toUpperCase();
    });
  }
}
