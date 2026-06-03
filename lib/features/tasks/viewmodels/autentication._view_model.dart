import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart' as cloud_firestore;
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';
import 'package:geo_tasks/features/tasks/models/user.dart';
import 'package:geo_tasks/features/tasks/repositories/user_repository.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationViewModel({
    firebase_auth.FirebaseAuth? auth,
    UserRepository? userRepository,
  }) : _auth = auth ?? firebase_auth.FirebaseAuth.instance,
       _userRepository = userRepository ?? UserRepository() {
    _user = _auth.currentUser;
    _currentUserData = _mapFirebaseUserToAppUser(_user);
    _listenToUserDocument(_user);
    _auth.authStateChanges().listen((user) {
      _user = user;
      _currentUserData = _mapFirebaseUserToAppUser(user);
      _listenToUserDocument(user);
      notifyListeners();
    });
  }

  final firebase_auth.FirebaseAuth _auth;
  final UserRepository _userRepository;
  StreamSubscription<cloud_firestore.DocumentSnapshot<Map<String, dynamic>>>?
  _userDocSubscription;

  firebase_auth.User? _user;
  User? _currentUserData;
  bool _isLoading = false;
  String? _errorMessage;

  firebase_auth.User? get user => _user;
  User? get currentUserData => _currentUserData;
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
      _syncCurrentUserData();
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
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
      await _ensureUserDocument(credential.user);
      _syncCurrentUserData();

      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
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

  Future<bool> updateProfileAvatar(String avatarBase64) async {
    final user = _auth.currentUser;
    if (user == null) return false;

    _setLoading(true);
    _clearError();

    try {
      await _userRepository.updateProfileAvatar(
        userId: user.uid,
        avatarBase64: avatarBase64,
      );
      _currentUserData = (_currentUserData ?? _mapFirebaseUserToAppUser(user))
          ?.copyWith(avatarBase64: avatarBase64);
      notifyListeners();
      return true;
    } on cloud_firestore.FirebaseException catch (e) {
      _errorMessage = e.message ?? 'Nao foi possivel salvar a foto.';
      notifyListeners();
      return false;
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

  void _syncCurrentUserData() {
    _user = _auth.currentUser;
    _currentUserData = _mapFirebaseUserToAppUser(_user);
    notifyListeners();
  }

  User? _mapFirebaseUserToAppUser(firebase_auth.User? firebaseUser) {
    if (firebaseUser == null) return null;

    return User.fromAuth(
      id: firebaseUser.uid,
      name: firebaseUser.displayName,
      email: firebaseUser.email,
      avatarBase64: _currentUserData?.avatarBase64,
    );
  }

  Future<void> _ensureUserDocument(firebase_auth.User? user) async {
    if (user == null) return;

    await _userRepository.ensureUserDocument(
      userId: user.uid,
      name: user.displayName ?? '',
      email: user.email ?? '',
    );
  }

  void _listenToUserDocument(firebase_auth.User? user) {
    _userDocSubscription?.cancel();
    _userDocSubscription = null;

    if (user == null) {
      _currentUserData = null;
      notifyListeners();
      return;
    }

    _userDocSubscription = _userRepository.watchUser(user.uid).listen((
      snapshot,
    ) {
      final data = snapshot.data();
      _currentUserData = User.fromFirestore(
        id: user.uid,
        data: data,
        fallbackName: user.displayName,
        fallbackEmail: user.email,
      );
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _userDocSubscription?.cancel();
    super.dispose();
  }
}
