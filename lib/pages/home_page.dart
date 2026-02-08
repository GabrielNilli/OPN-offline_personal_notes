// import 'dart:developer';

import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String get user => "Gabriel";

  @override
  Widget build(BuildContext context) {
    return homeScaffold();
  }

  Scaffold homeScaffold() {
  return Scaffold(
    appBar: homeAppbar(),
    backgroundColor: const Color(0xFF0D1117), // Sfondo scuro per coerenza
    
    // Il bottone centrale "+"
    floatingActionButton: FloatingActionButton(
      onPressed: () {},
      backgroundColor: Colors.blueAccent,
      shape: const CircleBorder(), // Per farlo perfettamente tondo
      child: const Icon(Icons.add, color: Colors.white, size: 30),
    ),
    
    // Posiziona il FAB al centro della barra
    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    
    bottomNavigationBar: BottomAppBar(
      color: const Color(0xFF161B22), // Un grigio leggermente più chiaro del fondo
      shape: const CircularNotchedRectangle(), // Crea l'invito per il FAB
      notchMargin: 8.0, // Spazio tra il bottone e la barra
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Icona Home
          _buildNavItem(Icons.home_outlined, "Home", true),
          // Icona Note
          _buildNavItem(Icons.description_outlined, "Note", false),
          
          // Spazio vuoto centrale per il FAB
          const SizedBox(width: 40),
          
          // Icona Dati
          _buildNavItem(Icons.bar_chart_outlined, "Dati", false),
          // Icona Set
          _buildNavItem(Icons.settings_outlined, "Set", false),
        ],
      ),
    ),
  );
}

// Widget helper per creare le icone della barra
Widget _buildNavItem(IconData icon, String label, bool isActive) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Icon(
        icon,
        color: isActive ? Colors.blueAccent : Colors.grey,
      ),
      Text(
        label,
        style: TextStyle(
          color: isActive ? Colors.blueAccent : Colors.grey,
          fontSize: 12,
        ),
      ),
    ],
  );
}

  AppBar homeAppbar() {
  return AppBar(
    backgroundColor: const Color(0xFF0D1117), // Colore scuro come nell'immagine
    elevation: 0,
    leadingWidth: 70, // Diamo un po' più di spazio al leading
    leading: Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Center(
        child: Stack(
          children: [
            // Immagine del profilo circolare
            const CircleAvatar(
              radius: 22,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'), 
            ),
          ],
        ),
      ),
    ),
    title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "BENTORNATO",
          style: TextStyle(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.bold),
        ),
        Text(
          user,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ],
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 15),
        child: Center(
          child: Stack(
            children: [
              const Icon(Icons.notifications_none_outlined, size: 28, color: Colors.white),
              // Badge notifica (pallino rosso)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0D1117), width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
}
