import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pizzacorn_ui/pizzacorn_ui.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

/// Repositorio generico de autenticacion para el flujo LoginCustom.
class LoginCustomAuthRepository {
  final FirebaseAuth firebaseAuth;

  LoginCustomAuthRepository({FirebaseAuth? firebaseAuth})
    : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  Future<UserCredential?> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> registerWithEmail({
    required String email,
    required String password,
  }) async {
    return firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential?> loginWithGoogle(BuildContext context) async {
    if (kIsWeb) {
      return firebaseAuth.signInWithPopup(GoogleAuthProvider());
    }

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      return null;
    }

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return firebaseAuth.signInWithCredential(credential);
  }

  Future<UserCredential?> loginWithApple() async {
    final AuthorizationCredentialAppleID appleCredential =
        await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
        );

    final OAuthCredential credential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return firebaseAuth.signInWithCredential(credential);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> sendVerificationEmail() async {
    final User? user = firebaseAuth.currentUser;
    await user?.sendEmailVerification();
  }

  Future<bool> reloadAndCheckEmailVerified() async {
    final User? user = firebaseAuth.currentUser;
    await user?.reload();
    return firebaseAuth.currentUser?.emailVerified ?? false;
  }

  void showError(BuildContext context, Object error) {
    debugPrint(error.toString());
    openSnackbar(context, text: "No hemos podido completar el acceso");
  }
}
