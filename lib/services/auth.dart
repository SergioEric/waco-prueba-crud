import 'package:crud_productos/helpers/clean.exception.dart';
import 'package:crud_productos/app/login/login.page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod/riverpod.dart';

abstract class AuthBase {
  User? get currentUser;

  Stream<User?> authStateChanges();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<User> signInWithGoogle();

  Future<void> signOut();
}

class Auth implements AuthBase {
  Auth({required this.read});

  final _firebaseAuth = FirebaseAuth.instance;
  final Reader read;

  @override
  Stream<User?> authStateChanges() => _firebaseAuth.authStateChanges();

  @override
  User? get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user!;
  }

  @override
  Future<User> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      read(userActionFormStateProvider).changeFormState =
          FormState.loginInProgess;

      final userCredential = await _firebaseAuth.signInWithCredential(
        EmailAuthProvider.credential(email: email, password: password),
      );
      read(userActionFormStateProvider).changeFormState = FormState.success;
      return userCredential.user!;
    } on FirebaseAuthException catch (e, _) {
      read(userActionFormStateProvider).changeFormState = FormState.failure;
      throw CleanException(e.getCleanMessage);
    }
  }

  @override
  Future<User> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      read(userActionFormStateProvider).changeFormState =
          FormState.loginInProgess;
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      read(userActionFormStateProvider).changeFormState = FormState.success;
      return userCredential.user!;
    } on FirebaseAuthException catch (e, _) {
      read(userActionFormStateProvider).changeFormState = FormState.failure;
      throw CleanException(e.getCleanMessage);
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    read(userActionFormStateProvider).changeFormState =
        FormState.loginInProgess;
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;
      if (googleAuth.idToken != null) {
        try {
          final userCredential = await _firebaseAuth
              .signInWithCredential(GoogleAuthProvider.credential(
            idToken: googleAuth.idToken,
            accessToken: googleAuth.accessToken,
          ));
          read(userActionFormStateProvider).changeFormState = FormState.success;
          return userCredential.user!;
        } on FirebaseAuthException catch (e) {
          // in this case we just make sure that user has not been blocked by admin
          // and if is the case, as the user gets login with google credentials
          // we destroy the session
          if (e.code == 'user-disabled') {
            await signOut();
            read(userActionFormStateProvider).changeFormState =
                FormState.failure;
            throw CleanException(
              'Usuario deshabilitado por admins',
            );
          }
          read(userActionFormStateProvider).changeFormState = FormState.failure;
          throw CleanException(e.getCleanMessage);
        }
      } else {
        read(userActionFormStateProvider).changeFormState = FormState.failure;
        throw CleanException(
          'Missing Google ID Token',
        );
      }
    } else {
      read(userActionFormStateProvider).changeFormState = FormState.failure;
      throw CleanException(
        'Login cancelado por el Usuario',
      );
    }
  }

  @override
  Future<void> signOut() async {
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
