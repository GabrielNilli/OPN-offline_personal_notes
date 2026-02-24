import 'package:flutter/material.dart';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  State<DataPage> createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: AppBar(title: const Text("Grafici")),
      body: Center(
        child: Text(
          "Pagina Dati",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
    );
  }
}
