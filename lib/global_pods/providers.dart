import 'package:crud_productos/services/auth.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

// auth provider isn't dispose in the app life cicle
final authProvider = Provider((ref)=> Auth(read: ref.read));

// final authStateChange = StreamProvider<Stream<User?>>((ref) async* {
//   yield ref.watch(authProvider).authStateChanges();
// });