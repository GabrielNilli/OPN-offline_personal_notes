import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/pin_login_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
    );
  }
}

// Decide quale pagina mostrare all'avvio
class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  final _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _authService.isRegistered(),
      builder: (context, snapshot) {
        // Mostra uno schermo vuoto mentre controlla
        if (!snapshot.hasData) {
          return const Scaffold(
            backgroundColor: Color(0xFF0D1117),
            body: Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }
        final isRegistered = snapshot.data!;
        // Se già registrato → schermata PIN, altrimenti → registrazione
        return isRegistered ? const PinLoginPage() : const LoginPage();
      },
    );
  }
}
