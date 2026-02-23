import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyUsername = 'auth_username';
  static const _keyPasswordHash = 'auth_password_hash';
  static const _keyPin = 'auth_pin';
  static const _keyIsRegistered = 'auth_is_registered';

  final LocalAuthentication _localAuth = LocalAuthentication();

  // Restituisce true se l'utente ha già un account sul dispositivo
  Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsRegistered) ?? false;
  }

  // Registra un nuovo utente (primo avvio)
  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPasswordHash, _hashPassword(password));
    await prefs.setBool(_keyIsRegistered, true);
  }

  // Salva il PIN scelto dall'utente
  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPin, _hashPassword(pin));
  }

  // Verifica username + password
  Future<bool> loginWithPassword(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_keyUsername);
    final savedHash = prefs.getString(_keyPasswordHash);
    return savedUsername == username && savedHash == _hashPassword(password);
  }

  // Verifica il PIN
  Future<bool> loginWithPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_keyPin);
    return savedHash == _hashPassword(pin);
  }

  // Controlla se il dispositivo supporta il biometrico
  Future<bool> isBiometricAvailable() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

  // Avvia l'autenticazione biometrica
  Future<bool> loginWithBiometric() async {
    try {
      return await _localAuth.authenticate(
        localizedReason: 'Accedi con la tua impronta o Face ID',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Recupera lo username salvato
  Future<String> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '';
  }

  // Cancella tutti i dati (logout)
  Future<void> logout() async {}

  // Hash SHA-256 della stringa
  String _hashPassword(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
