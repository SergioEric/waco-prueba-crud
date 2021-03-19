import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;

class CleanException implements Exception {
  final dynamic message;

  CleanException(this.message)
      : assert(message != null || message.toString().isNotEmpty);

  @override
  String toString() {
    return this.message;
  }
}

extension CleanMessage on FirebaseAuthException {

  String get getCleanMessage {
    switch (code) {
      // createUserWithEmailAndPassword
      case 'email-already-in-use':
        return 'Email en uso';
      case 'invalid-email':
        return 'Email invalido';
      case 'weak-password':
        return 'Contraseña muy débil';
      // signInWithCredential
      case 'account-exists-with-different-credential':
        return 'Cuenta ya existente con otro proveedor';
      case 'invalid-credential':
        return 'Credenciales inválida';
      case 'operation-not-allowed':
        return 'Operación no permitida';
      case 'user-disabled':
        return 'Usuario deshabilitado por admin';
      case 'user-not-found':
        return 'Usuario no encontrado';
      case 'wrong-password':
        return 'Contraseña incorrecta';
      case 'invalid-verification-code':
        return 'Code de verificacion inválido';
      case 'invalid-verification-id':
        return 'Identificación inválida';
      default:
        return message ?? 'algo salio mal';
    }
  }
}
