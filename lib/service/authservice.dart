import 'package:alchat/helper/helperfunc.dart';
import 'package:alchat/service/dbservice.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authservice {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //login
  Future signinUserWithEmailandPassword(String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      // ignore: unused_local_variable
      User user = result.user!;
      //update db
      return 'true';
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //register
  Future registerUserWithEmailandPassword(
      String name, String email, String password) async {
    try {
      UserCredential result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      await dbservice(uid: user.uid).savingUserData(name, email);
      //update db
      return 'true';
    } on FirebaseAuthException catch (e) {
      print(e);
      return e.message;
    }
  }

  //signout
  Future signout() async {
    try {
      await helperfunc.saveUserLoggedInStatus(false);
      await helperfunc.saveUserEmailsf("");
      await helperfunc.saveUserNamesf("");
      await firebaseAuth.signOut();
    } catch (e) {
      return null;
    }
  }
}
