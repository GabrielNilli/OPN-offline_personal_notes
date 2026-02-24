import 'package:flutter/material.dart';

class CreateListPage extends StatefulWidget {
  const CreateListPage({super.key});

  @override
  State<CreateListPage> createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final _titleController = TextEditingController();
  final List<Map<String, dynamic>> _items = [
    {'text': '', 'checked': false},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() => _items.add({'text': '', 'checked': false}));
  }

  void _toggleItem(int index) {
    setState(() => _items[index]['checked'] = !_items[index]['checked']);
  }

  void _removeItem(int index) {
    if (_items.length > 1) setState(() => _items.removeAt(index));
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
        title: const Text('Nuova Lista'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: salva la lista
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
              hintText: 'Titolo della lista',
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

          ..._items.asMap().entries.map((entry) {
            final i = entry.key;
            final item = entry.value;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _toggleItem(i),
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: item['checked']
                              ? Colors.blueAccent
                              : Colors.grey,
                          width: 2,
                        ),
                        color: item['checked']
                            ? Colors.blueAccent
                            : Colors.transparent,
                      ),
                      child: item['checked']
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 14,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: item['checked'] ? Colors.grey : textColor,
                        decoration: item['checked']
                            ? TextDecoration.lineThrough
                            : null,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Elemento ${i + 1}',
                        hintStyle: TextStyle(color: Colors.grey[500]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      onChanged: (v) => _items[i]['text'] = v,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey[500], size: 18),
                    onPressed: () => _removeItem(i),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: _addItem,
            icon: const Icon(Icons.add, color: Colors.blueAccent),
            label: const Text(
              'Aggiungi elemento',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
