import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

abstract class AuthService extends GetxService {
  Stream<User?> get user;
  Future<void> signIn(String email, String password);
  Future<void> signUp(String email, String password);
  Future<void> signOut();
}

class User {
  final String id;
  final String email;
  final String? displayName;

  User({required this.id, required this.email, this.displayName});
}

class MockAuthService extends AuthService {
  final _user = Rxn<User>();

  @override
  Stream<User?> get user => _user.stream;

  @override
  Future<void> signIn(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _user.value = User(id: '1', email: email, displayName: 'Mock User');
  }

  @override
  Future<void> signUp(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    _user.value = User(id: '1', email: email, displayName: 'Mock User');
  }

  @override
  Future<void> signOut() async {
    _user.value = null;
  }
}

class FirebaseAuthService extends AuthService {
  final firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;

  @override
  Stream<User?> get user => _auth.authStateChanges().map((u) => u != null ? User(id: u.uid, email: u.email ?? '') : null);

  @override
  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(email: email, password: password);
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
