import 'package:flutter/material.dart';

class CreateChartPage extends StatefulWidget {
  const CreateChartPage({super.key});

  @override
  State<CreateChartPage> createState() => _CreateChartPageState();
}

class _CreateChartPageState extends State<CreateChartPage> {
  final _titleController = TextEditingController();
  String _selectedType = 'Barre';
  final List<String> _chartTypes = ['Barre', 'Linee', 'Torta'];

  final List<Map<String, dynamic>> _dataRows = [
    {'label': 'Trimestre 1', 'value': ''},
    {'label': 'Trimestre 2', 'value': ''},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _addRow() {
    setState(() => _dataRows.add({'label': '', 'value': ''}));
  }

  void _removeRow(int index) {
    if (_dataRows.length > 1) setState(() => _dataRows.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annulla', style: TextStyle(color: Colors.grey)),
        ),
        leadingWidth: 90,
        title: const Text('Nuovo Grafico'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {
              // TODO: salva il grafico
              Navigator.pop(context);
            },
            child: const Text(
              'Salva',
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
          // Titolo
          TextField(
            controller: _titleController,
            style: TextStyle(
              color: textColor,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: 'Titolo del grafico',
              hintStyle: TextStyle(
                color: Colors.grey[500],
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              border: InputBorder.none,
            ),
          ),
          Divider(color: Colors.grey.withOpacity(0.2)),
          const SizedBox(height: 16),

          // Tipo grafico
          Text(
            'TIPO GRAFICO',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              children: _chartTypes.map((type) {
                final isSelected = _selectedType == type;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedType = type),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.blueAccent
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        type,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.grey,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Anteprima placeholder
          Text(
            'ANTEPRIMA',
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            height: 160,
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.bar_chart_outlined,
                    color: Colors.grey[600],
                    size: 48,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Anteprima $_selectedType',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Dati
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DATI',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
              TextButton.icon(
                onPressed: _addRow,
                icon: const Icon(Icons.add, color: Colors.blueAccent, size: 16),
                label: const Text(
                  'Aggiungi riga',
                  style: TextStyle(color: Colors.blueAccent, fontSize: 13),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Header tabella
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(14),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'ETICHETTA',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    'VALORE',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(width: 32),
              ],
            ),
          ),

          // Righe dati
          ..._dataRows.asMap().entries.map((entry) {
            final i = entry.key;
            final isLast = i == _dataRows.length - 1;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: cardColor,
                border: Border(
                  top: BorderSide(color: Colors.grey.withOpacity(0.15)),
                ),
                borderRadius: isLast
                    ? const BorderRadius.vertical(bottom: Radius.circular(14))
                    : BorderRadius.zero,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(color: textColor, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: 'Etichetta',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (v) => _dataRows[i]['label'] = v,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: textColor, fontSize: 15),
                      decoration: InputDecoration(
                        hintText: '0',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                      onChanged: (v) => _dataRows[i]['value'] = v,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _removeRow(i),
                    child: Icon(
                      Icons.remove_circle_outline,
                      color: Colors.grey[500],
                      size: 20,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
