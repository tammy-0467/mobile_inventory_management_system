import 'package:firebase_auth/firebase_auth.dart';

//instance of firebase authentication
class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  //authenticates the current user
  User? get currentUser => _firebaseAuth.currentUser;

  //notifies the firebaseAuth fn about the current users state (logged in or out)
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  //define an async fn that waits for the user's email and pass to be provided in order to sign in
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password
  }) async{
    await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
  }

  //define an async fn that waits for the user's email and pass to be provided in order to create a new user
  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password
  }) async{
    await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
  }

  //signs out the current user
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}