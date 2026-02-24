import 'dart:io';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../theme_notifier.dart' show AppThemeMode;
import '../main.dart' show themeNotifier;
import 'pin_login_page.dart';
import 'profile_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _authService = AuthService();

  bool _notificheAttive = true;
  bool _suoniAttivi = true;
  String _username = '';
  String _email = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final username = await _authService.getSavedUsername();
    final imagePath = await _authService.getProfileImagePath();
    setState(() {
      _username = username;
      _email = '$username@dispositivo.local';
      _profileImagePath = imagePath;
    });
  }

  Future<void> _logout() async {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: cardColor,
        title: Text('Logout', style: TextStyle(color: textColor)),
        content: Text(
          'Sei sicuro di voler uscire? Dovrai rifare il login.',
          style: TextStyle(color: Colors.grey[500]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annulla', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Esci',
              style: TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await _authService.logout();
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const PinLoginPage()),
          (route) => false,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Impostazioni',
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 28,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildProfileCard(context),
          const SizedBox(height: 24),

          _buildSectionLabel('NOTIFICHE'),
          const SizedBox(height: 8),
          _buildCard(context, [
            _buildToggleTile(
              context,
              icon: Icons.notifications_outlined,
              iconColor: Colors.redAccent,
              title: 'Abilita Promemoria',
              value: _notificheAttive,
              onChanged: (v) => setState(() => _notificheAttive = v),
            ),
            _buildDivider(context),
            _buildToggleTile(
              context,
              icon: Icons.volume_up_outlined,
              iconColor: Colors.redAccent,
              title: 'Suoni e Vibrazione',
              value: _suoniAttivi,
              onChanged: (v) => setState(() => _suoniAttivi = v),
            ),
          ]),
          const SizedBox(height: 24),

          _buildSectionLabel('ASPETTO'),
          const SizedBox(height: 8),
          _buildCard(context, [_buildThemeToggleTile(context)]),
          const SizedBox(height: 24),

          _buildSectionLabel('DATI E SICUREZZA'),
          const SizedBox(height: 8),
          _buildCard(context, [
            _buildArrowTile(
              context,
              icon: Icons.cloud_upload_outlined,
              iconColor: Colors.green,
              title: 'Backup e Ripristino',
              onTap: () {},
            ),
            _buildDivider(context),
            _buildArrowTile(
              context,
              icon: Icons.download_outlined,
              iconColor: Colors.green,
              title: 'Esporta Dati',
              onTap: () {},
            ),
            _buildDivider(context),
            _buildArrowTile(
              context,
              icon: Icons.lock_outline,
              iconColor: Colors.green,
              title: 'Privacy e Sicurezza',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 24),

          _buildSectionLabel('INFO'),
          const SizedBox(height: 8),
          _buildCard(context, [
            _buildArrowTile(
              context,
              icon: Icons.description_outlined,
              iconColor: Colors.grey,
              title: 'Termini di Servizio',
              onTap: () {},
            ),
            _buildDivider(context),
            _buildArrowTile(
              context,
              icon: Icons.info_outline,
              iconColor: Colors.grey,
              title: 'Licenze Open Source',
              onTap: () {},
            ),
          ]),
          const SizedBox(height: 12),
          Center(
            child: Text(
              'Versione 1.0.0 (build 1)',
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                'Esci',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildProfileCard(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return GestureDetector(
      onTap: () async {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ProfilePage()),
        );
        _loadUserData();
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
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
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _username,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _email,
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  // Toggle con stato locale per animazione fluida senza lag
  Widget _buildThemeToggleTile(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final scaffoldColor = Theme.of(context).scaffoldBackgroundColor;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildIconBox(Icons.palette_outlined, Colors.blueAccent),
              const SizedBox(width: 12),
              Text('Tema', style: TextStyle(color: textColor, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          AnimatedBuilder(
            animation: themeNotifier,
            builder: (context, _) {
              return Container(
                decoration: BoxDecoration(
                  color: scaffoldColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    _buildThemeOption(
                      context,
                      AppThemeMode.light,
                      Icons.wb_sunny_rounded,
                      'Chiaro',
                      Colors.orange,
                    ),
                    _buildThemeOption(
                      context,
                      AppThemeMode.system,
                      Icons.brightness_auto_outlined,
                      'Auto',
                      Colors.blueAccent,
                    ),
                    _buildThemeOption(
                      context,
                      AppThemeMode.dark,
                      Icons.nightlight_round,
                      'Scuro',
                      Colors.indigo,
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption(
    BuildContext context,
    AppThemeMode mode,
    IconData icon,
    String label,
    Color color,
  ) {
    final isSelected = themeNotifier.mode == mode;
    return Expanded(
      child: GestureDetector(
        onTap: () => themeNotifier.setMode(mode),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? color.withOpacity(0.2) : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: color.withOpacity(0.6), width: 1.5)
                : null,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? color : Colors.grey,
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.grey[500],
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Divider(height: 1, color: Colors.grey.withOpacity(0.15), indent: 56);
  }

  Widget _buildToggleTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      leading: _buildIconBox(icon, iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 15)),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.blueAccent,
      ),
    );
  }

  Widget _buildArrowTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    String? trailing,
    required VoidCallback onTap,
  }) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    return ListTile(
      onTap: onTap,
      leading: _buildIconBox(icon, iconColor),
      title: Text(title, style: TextStyle(color: textColor, fontSize: 15)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null)
            Text(
              trailing,
              style: TextStyle(color: Colors.grey[500], fontSize: 14),
            ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
        ],
      ),
    );
  }

  Widget _buildIconBox(IconData icon, Color color) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }
}
