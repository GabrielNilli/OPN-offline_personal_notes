import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_page.dart';
import 'login_page.dart';

class PinLoginPage extends StatefulWidget {
  const PinLoginPage({super.key});

  @override
  State<PinLoginPage> createState() => _PinLoginPageState();
}

class _PinLoginPageState extends State<PinLoginPage> {
  final _authService = AuthService();

  String _pin = '';
  String _username = '';
  bool _biometricAvailable = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final username = await _authService.getSavedUsername();
    final biometric = await _authService.isBiometricAvailable();
    setState(() {
      _username = username;
      _biometricAvailable = biometric;
    });
    // Proponi subito il biometrico all'apertura
    if (biometric) _tryBiometric();
  }

  void _onKeyPress(String value) {
    if (_pin.length >= 4) return;
    setState(() {
      _errorMessage = null;
      _pin += value;
    });
    if (_pin.length == 4) _checkPin();
  }

  void _onDelete() {
    if (_pin.isEmpty) return;
    setState(() {
      _errorMessage = null;
      _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  Future<void> _checkPin() async {
    final success = await _authService.loginWithPin(_pin);
    if (success) {
      _goToMain();
    } else {
      setState(() {
        _pin = '';
        _errorMessage = 'PIN errato, riprova';
      });
    }
  }

  Future<void> _tryBiometric() async {
    final success = await _authService.loginWithBiometric();
    if (success) _goToMain();
  }

  void _goToMain() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainPage()),
    );
  }

  void _goToPasswordRecovery() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),

            // Avatar / Icona utente
            const CircleAvatar(
              radius: 36,
              backgroundColor: Color(0xFF161B22),
              child: Icon(
                Icons.person_outline,
                color: Colors.blueAccent,
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bentornato, $_username',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Inserisci il tuo PIN per accedere',
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 48),

            // Pallini PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: filled ? Colors.blueAccent : Colors.transparent,
                    border: Border.all(
                      color: filled ? Colors.blueAccent : Colors.grey,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),

            if (_errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ],

            const Spacer(),

            // Tastierino numerico
            _buildKeypad(),
            const SizedBox(height: 16),

            // Accesso biometrico
            if (_biometricAvailable)
              TextButton.icon(
                onPressed: _tryBiometric,
                icon: const Icon(
                  Icons.fingerprint,
                  color: Colors.blueAccent,
                  size: 28,
                ),
                label: const Text(
                  'Usa impronta / Face ID',
                  style: TextStyle(color: Colors.blueAccent),
                ),
              ),

            // Recupero con password
            TextButton(
              onPressed: _goToPasswordRecovery,
              child: Text(
                'Ho dimenticato il PIN',
                style: TextStyle(color: Colors.grey[500], fontSize: 13),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypad() {
    const keys = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', '⌫'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        childAspectRatio: 1.4,
        physics: const NeverScrollableScrollPhysics(),
        children: keys.map((key) {
          if (key.isEmpty) return const SizedBox();
          if (key == '⌫') {
            return IconButton(
              onPressed: _onDelete,
              icon: const Icon(
                Icons.backspace_outlined,
                color: Colors.grey,
                size: 26,
              ),
            );
          }
          return TextButton(
            onPressed: () => _onKeyPress(key),
            child: Text(
              key,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
