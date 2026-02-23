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
    return Scaffold(
      appBar: _buildAppBar(),
      backgroundColor: const Color(0xFF0D1117),
      body: const Center(
        child: Text(
          "Benvenuto nella Home!",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0D1117),
      elevation: 0,
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Center(
          child: Stack(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
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
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[400],
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            user,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Center(
            child: Stack(
              children: [
                const Icon(
                  Icons.notifications_none_outlined,
                  size: 28,
                  color: Colors.white,
                ),
                // Positioned(
                //   right: 0,
                //   top: 0,
                //   child: Container(
                //     width: 10,
                //     height: 10,
                //     decoration: BoxDecoration(
                //       color: Colors.red,
                //       shape: BoxShape.circle,
                //       border: Border.all(
                //         color: const Color(0xFF0D1117),
                //         width: 1.5,
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
