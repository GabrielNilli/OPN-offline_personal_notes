import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'main_page.dart';

class PinSetupPage extends StatefulWidget {
  const PinSetupPage({super.key});

  @override
  State<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends State<PinSetupPage> {
  final _authService = AuthService();

  String _pin = '';
  String _confirmPin = '';
  bool _isConfirming = false;
  String? _errorMessage;

  void _onKeyPress(String value) {
    setState(() {
      _errorMessage = null;
      if (!_isConfirming) {
        if (_pin.length < 4) _pin += value;
        if (_pin.length == 4) _isConfirming = true;
      } else {
        if (_confirmPin.length < 4) _confirmPin += value;
        if (_confirmPin.length == 4)
          _confirmPin == _pin ? _savePin() : _pinMismatch();
      }
    });
  }

  void _onDelete() {
    setState(() {
      _errorMessage = null;
      if (_isConfirming) {
        if (_confirmPin.isNotEmpty) {
          _confirmPin = _confirmPin.substring(0, _confirmPin.length - 1);
        }
      } else {
        if (_pin.isNotEmpty) {
          _pin = _pin.substring(0, _pin.length - 1);
        }
      }
    });
  }

  void _pinMismatch() {
    setState(() {
      _confirmPin = '';
      _errorMessage = 'I PIN non coincidono, riprova';
    });
  }

  Future<void> _savePin() async {
    await _authService.savePin(_pin);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentPin = _isConfirming ? _confirmPin : _pin;
    final title = _isConfirming ? 'Conferma il PIN' : 'Scegli un PIN';
    final subtitle = _isConfirming
        ? 'Reinserisci il PIN per confermare'
        : 'Scegli 4 cifre da usare per accedere';

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),

            // Pallini PIN
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (i) {
                final filled = i < currentPin.length;
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
            const SizedBox(height: 32),
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
