import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../services/auth_service.dart';
import 'pin_setup_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _imagePicker = ImagePicker();

  final _usernameController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  String? _profileImagePath;
  String _username = '';
  bool _isLoading = false;
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadProfile() async {
    final username = await _authService.getSavedUsername();
    final imagePath = await _authService.getProfileImagePath();
    setState(() {
      _username = username;
      _usernameController.text = username;
      _profileImagePath = imagePath;
    });
  }

  void _showImageSourceSheet(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).colorScheme.onSurface;

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[400],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(
                Icons.camera_alt_outlined,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Scatta una foto',
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: Colors.blueAccent,
              ),
              title: Text(
                'Scegli dalla galleria',
                style: TextStyle(color: textColor),
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            if (_profileImagePath != null)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text(
                  'Rimuovi foto',
                  style: TextStyle(color: Colors.redAccent),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _removeImage();
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _imagePicker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 85,
    );
    if (picked != null) {
      await _authService.saveProfileImagePath(picked.path);
      setState(() => _profileImagePath = picked.path);
    }
  }

  Future<void> _removeImage() async {
    await _authService.saveProfileImagePath('');
    setState(() => _profileImagePath = null);
  }

  Future<void> _saveUsername() async {
    final newUsername = _usernameController.text.trim();
    final currentPassword = _currentPasswordController.text.trim();
    if (newUsername.isEmpty) {
      _showSnack('Il nome utente non può essere vuoto', isError: true);
      return;
    }
    if (newUsername == _username) {
      _showSnack('Il nome utente è già quello attuale', isError: true);
      return;
    }
    if (currentPassword.isEmpty) {
      _showSnack('Inserisci la password attuale per confermare', isError: true);
      return;
    }

    setState(() => _isLoading = true);
    final success = await _authService.updateUsername(
      newUsername,
      currentPassword,
    );
    setState(() => _isLoading = false);

    if (success) {
      setState(() => _username = newUsername);
      _currentPasswordController.clear();
      _showSnack('Nome utente aggiornato!');
    } else {
      _showSnack('Password errata', isError: true);
    }
  }

  Future<void> _savePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    if (currentPassword.isEmpty || newPassword.isEmpty) {
      _showSnack('Compila entrambi i campi password', isError: true);
      return;
    }
    if (newPassword.length < 6) {
      _showSnack(
        'La nuova password deve avere almeno 6 caratteri',
        isError: true,
      );
      return;
    }

    setState(() => _isLoading = true);
    final success = await _authService.updatePassword(
      currentPassword,
      newPassword,
    );
    setState(() => _isLoading = false);

    if (success) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _showSnack('Password aggiornata!');
    } else {
      _showSnack('Password attuale errata', isError: true);
    }
  }

  void _goToChangePin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PinSetupPage()),
    );
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Modifica Profilo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // ── Avatar ───────────────────────────────────────────────
          Center(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceSheet(context),
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: Colors.blueAccent.withOpacity(0.2),
                    backgroundImage:
                        _profileImagePath != null &&
                            _profileImagePath!.isNotEmpty
                        ? FileImage(File(_profileImagePath!))
                        : null,
                    child:
                        _profileImagePath == null || _profileImagePath!.isEmpty
                        ? Text(
                            _username.isNotEmpty
                                ? _username[0].toUpperCase()
                                : '?',
                            style: const TextStyle(
                              color: Colors.blueAccent,
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.blueAccent,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tocca per cambiare foto',
              style: TextStyle(color: Colors.grey[500], fontSize: 13),
            ),
          ),
          const SizedBox(height: 32),

          // ── Modifica username ────────────────────────────────────
          _buildSectionLabel('NOME UTENTE'),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _usernameController,
            label: 'Nuovo nome utente',
            icon: Icons.person_outline,
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            controller: _currentPasswordController,
            label: 'Password attuale (per confermare)',
            icon: Icons.lock_outline,
            obscure: _obscureCurrent,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrent
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: 'Aggiorna nome utente',
            onTap: _isLoading ? null : _saveUsername,
          ),
          const SizedBox(height: 32),

          // ── Modifica password ────────────────────────────────────
          _buildSectionLabel('PASSWORD'),
          const SizedBox(height: 8),
          _buildTextField(
            context: context,
            controller: _currentPasswordController,
            label: 'Password attuale',
            icon: Icons.lock_outline,
            obscure: _obscureCurrent,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureCurrent
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () =>
                  setState(() => _obscureCurrent = !_obscureCurrent),
            ),
          ),
          const SizedBox(height: 12),
          _buildTextField(
            context: context,
            controller: _newPasswordController,
            label: 'Nuova password',
            icon: Icons.lock_open_outlined,
            obscure: _obscureNew,
            suffixIcon: IconButton(
              icon: Icon(
                _obscureNew
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: Colors.grey,
              ),
              onPressed: () => setState(() => _obscureNew = !_obscureNew),
            ),
          ),
          const SizedBox(height: 12),
          _buildActionButton(
            label: 'Aggiorna password',
            onTap: _isLoading ? null : _savePassword,
          ),
          const SizedBox(height: 32),

          // ── Modifica PIN ─────────────────────────────────────────
          _buildSectionLabel('PIN'),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: _goToChangePin,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(Icons.dialpad, color: Colors.blueAccent),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Cambia PIN',
                      style: TextStyle(color: textColor, fontSize: 15),
                    ),
                  ),
                  const Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
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

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    final textColor = Theme.of(context).colorScheme.onSurface;
    final cardColor = Theme.of(context).cardColor;

    return TextField(
      controller: controller,
      obscureText: obscure,
      style: TextStyle(color: textColor),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: Icon(icon, color: Colors.grey),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: cardColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.blueAccent),
        ),
      ),
    );
  }

  Widget _buildActionButton({required String label, VoidCallback? onTap}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          disabledBackgroundColor: Colors.blueAccent.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }
}
