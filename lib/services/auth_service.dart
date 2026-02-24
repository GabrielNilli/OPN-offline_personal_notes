import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyUsername = 'auth_username';
  static const _keyPasswordHash = 'auth_password_hash';
  static const _keyPin = 'auth_pin';
  static const _keyIsRegistered = 'auth_is_registered';
  static const _keyProfileImagePath = 'auth_profile_image_path';

  final LocalAuthentication _localAuth = LocalAuthentication();

  Future<bool> isRegistered() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsRegistered) ?? false;
  }

  Future<void> register(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUsername, username);
    await prefs.setString(_keyPasswordHash, _hashPassword(password));
    await prefs.setBool(_keyIsRegistered, true);
  }

  Future<void> savePin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyPin, _hashPassword(pin));
  }

  Future<bool> loginWithPassword(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final savedUsername = prefs.getString(_keyUsername);
    final savedHash = prefs.getString(_keyPasswordHash);
    return savedUsername == username && savedHash == _hashPassword(password);
  }

  Future<bool> loginWithPin(String pin) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_keyPin);
    return savedHash == _hashPassword(pin);
  }

  Future<bool> isBiometricAvailable() async {
    final isAvailable = await _localAuth.canCheckBiometrics;
    final isDeviceSupported = await _localAuth.isDeviceSupported();
    return isAvailable && isDeviceSupported;
  }

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

  Future<String> getSavedUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUsername) ?? '';
  }

  // ── Foto profilo ─────────────────────────────────────────────────

  Future<void> saveProfileImagePath(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyProfileImagePath, path);
  }

  Future<String?> getProfileImagePath() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyProfileImagePath);
  }

  // ── Modifica credenziali ─────────────────────────────────────────

  // Aggiorna username (richiede la password attuale per conferma)
  Future<bool> updateUsername(
    String newUsername,
    String currentPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_keyPasswordHash);
    if (savedHash != _hashPassword(currentPassword)) return false;
    await prefs.setString(_keyUsername, newUsername);
    return true;
  }

  // Aggiorna password (richiede la password attuale)
  Future<bool> updatePassword(
    String currentPassword,
    String newPassword,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final savedHash = prefs.getString(_keyPasswordHash);
    if (savedHash != _hashPassword(currentPassword)) return false;
    await prefs.setString(_keyPasswordHash, _hashPassword(newPassword));
    return true;
  }

  // Aggiorna PIN (non richiede conferma, già autenticati)
  Future<void> updatePin(String newPin) async {
    await savePin(newPin);
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUsername);
    await prefs.remove(_keyPasswordHash);
    await prefs.remove(_keyPin);
    await prefs.remove(_keyIsRegistered);
    await prefs.remove(_keyProfileImagePath);
  }

  String _hashPassword(String input) {
    final bytes = utf8.encode(input);
    return sha256.convert(bytes).toString();
  }
}
