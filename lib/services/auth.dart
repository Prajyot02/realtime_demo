import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class Auth{
  final FirebaseAuth _firebaseAuth= FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
})
async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
}


  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String fname,
    required String sname,
    // required String firstName,
    // required String lastName,
    // required int gender,
    // required int age,

  })
  async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}