// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // Importe para checar a plataforma

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- ALTERAÇÃO AQUI ---
  // Vamos inicializar o GoogleSignIn com o Client ID específico para a web.
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    // A variável kIsWeb garante que o clientId só será usado na plataforma web.
    clientId: kIsWeb
        ? "903104501156-apso3r8m228o9e95k2hhatea56uh190g.apps.googleusercontent.com"
        : null,
  );

  // Stream para ouvir o estado da autenticação
  Stream<User?> get user => _auth.authStateChanges();

  // O resto do arquivo continua o mesmo...
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // O usuário cancelou o login
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Erro durante o login com Google: $e"); // Imprime o erro no console
      return null;
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}