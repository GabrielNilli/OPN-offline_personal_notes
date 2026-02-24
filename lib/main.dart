import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/pin_login_page.dart';
import 'services/auth_service.dart';
import 'theme_notifier.dart';
import 'app_themes.dart';

// Istanza globale accessibile da tutta l'app
final themeNotifier = ThemeNotifier();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await themeNotifier.load(); // carica il tema salvato prima di partire
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemes.light,
          darkTheme: AppThemes.dark,
          themeMode: themeNotifier.themeMode,
          home: const AuthGate(),
        );
      },
    );
  }
}

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
        if (!snapshot.hasData) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            ),
          );
        }
        final isRegistered = snapshot.data!;
        return isRegistered ? const PinLoginPage() : const LoginPage();
      },
    );
  }
}
