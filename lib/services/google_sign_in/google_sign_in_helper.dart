import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';

Future<UserCredential?> signInWithGoogle() async {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  // Ensure the user is signed out to force the account selection
  await googleSignIn.signOut();

  // Trigger Google Sign-In flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
  if (googleUser == null) return null; // User canceled sign-in

  // Obtain authentication details
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Create a credential
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Sign in with Firebase
  final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);

  // Return the user's email
  return userCredential;
}

Future<void> signOut() async {
  await GoogleSignIn().signOut();
  await FirebaseAuth.instance.signOut();
  log("sign out success");
}
