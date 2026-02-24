import 'package:flutter/material.dart';

class CreateNotePage extends StatefulWidget {
  const CreateNotePage({super.key});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla', style: TextStyle(color: Colors.grey)),
        ),
        leadingWidth: 90,
        title: const Text('Nuova Nota'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: salva la nota
              Navigator.pop(context);
            },
            child: const Text(
              'Fatto',
              style: TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: _titleController,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Titolo della nota',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                size: 14,
                color: Colors.grey[500],
              ),
              const SizedBox(width: 6),
              Text(
                '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}  ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
              const SizedBox(width: 16),
              Icon(Icons.label_outline, size: 14, color: Colors.grey[500]),
              const SizedBox(width: 6),
              Text(
                'Personale',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ],
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bodyController,
            style: TextStyle(color: textColor, fontSize: 16, height: 1.6),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: 'Scrivi qualcosa...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 16),
              border: InputBorder.none,
            ),
          ),
        ],
      ),
    );
  }
}
