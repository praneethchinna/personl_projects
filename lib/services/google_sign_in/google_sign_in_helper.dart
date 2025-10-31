
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  debugPrint('signInWithGoogle: start');

  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Ensure the user is signed out to force the account selection
  await googleSignIn.signOut();
  debugPrint('signInWithGoogle: signOut');

  // Trigger Google Sign-In flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) {
    debugPrint('signInWithGoogle: canceled');
    return null; // User canceled sign-in
  }
  debugPrint('signInWithGoogle: signIn ok');

  // Obtain authentication details
  final GoogleSignInAuthentication googleAuth =
      await googleUser.authentication;
  debugPrint('signInWithGoogle: authentication ok');

  // Create a credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );
  debugPrint('signInWithGoogle: credential ok');

  // Sign in with Firebase
  try {
    final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    debugPrint('signInWithGoogle: signInWithCredential ok');
    return userCredential;
  } catch (e, stackTrace) {
    debugPrint('signInWithGoogle: signInWithCredential failed: $e',
        );
    return null;
  }
}

Future<void> signOut() async {
  debugPrint('signOut: start');

  await GoogleSignIn().signOut();
  debugPrint('signOut: GoogleSignIn.signOut ok');

  await FirebaseAuth.instance.signOut();
  debugPrint('signOut: FirebaseAuth.instance.signOut ok');
  debugPrint('signOut: success');
}