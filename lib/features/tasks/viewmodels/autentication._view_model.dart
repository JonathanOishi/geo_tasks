import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationViewModel({FirebaseAuth? auth})
    : _auth = auth ?? FirebaseAuth.instance {
    _user = _auth.currentUser;
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  final FirebaseAuth _auth;

  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _user != null;

  Future<bool> login({required String email, required String password}) async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> register(
    String name,
    String email,
    String password,
    String confirmPassword,
  ) async {
    final trimmedName = name.trim();
    final trimmedEmail = email.trim();
    final trimmedPassword = password.trim();
    final trimmedConfirmPassword = confirmPassword.trim();

    if (trimmedName.isEmpty) {
      _errorMessage = 'Informe seu nome.';
      notifyListeners();
      return false;
    }

    if (trimmedEmail.isEmpty || trimmedPassword.isEmpty) {
      _errorMessage = 'E-mail e senha sao obrigatorios.';
      notifyListeners();
      return false;
    }

    if (trimmedPassword != trimmedConfirmPassword) {
      _errorMessage = 'As senhas nao conferem.';
      notifyListeners();
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: trimmedEmail,
        password: trimmedPassword,
      );

      await credential.user?.updateDisplayName(trimmedName);
      await credential.user?.reload();

      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _mapAuthError(e.code);
      notifyListeners();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      await _auth.signOut();
    } finally {
      _setLoading(false);
    }
  }

  String _mapAuthError(String code) {
    switch (code) {
      case 'invalid-email':
        return 'E-mail invalido.';
      case 'user-not-found':
        return 'Usuario nao encontrado.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'E-mail ou senha incorretos.';
      case 'email-already-in-use':
        return 'Este e-mail ja esta em uso.';
      case 'weak-password':
        return 'Senha fraca. Use pelo menos 6 caracteres.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente em instantes.';
      default:
        return 'Nao foi possivel autenticar. Tente novamente.';
    }
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
  }
}
