import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authService = AuthService();
  String _username = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final username = await _authService.getSavedUsername();
    final imagePath = await _authService.getProfileImagePath();
    setState(() {
      _username = username;
      _profileImagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: Center(
        child: Text(
          "Benvenuto nella Home!",
          style: TextStyle(color: textColor, fontSize: 18),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return AppBar(
      leadingWidth: 70,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Center(
          child: CircleAvatar(
            radius: 22,
            backgroundColor: Colors.blueAccent.withOpacity(0.2),
            backgroundImage:
                _profileImagePath != null && _profileImagePath!.isNotEmpty
                ? FileImage(File(_profileImagePath!))
                : null,
            child: _profileImagePath == null || _profileImagePath!.isEmpty
                ? Text(
                    _username.isNotEmpty ? _username[0].toUpperCase() : '?',
                    style: const TextStyle(
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : null,
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
            _username,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 15),
          child: Icon(
            Icons.notifications_none_outlined,
            size: 28,
            color: textColor,
          ),
        ),
      ],
    );
  }
}
