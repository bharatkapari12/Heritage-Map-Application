import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  Future<User?> login({required String email, required String password}) async {
    var user = await auth.signInWithEmailAndPassword(email: email, password: password);

    return user.user;
  }

  Future<User> register({required String email, required String password}) async {
    var user = await auth.createUserWithEmailAndPassword(email: email, password: password);
    return user.user!;
  }

  Future logout() async {
    await auth.signOut();
  }

 

  Future changePassword({required String email, required String password, required String newPassword}) async {
    final cred = EmailAuthProvider.credential(email: email, password: password);
    await auth.currentUser!.reauthenticateWithCredential(cred).then((value) {
      auth.currentUser!.updatePassword(newPassword);
    }).catchError((error) {
      log(error.toString());
    });
  }

  Future forgetpassword({required String email}) async {
    await auth.sendPasswordResetEmail(email: email);

  }

  Future<bool> isSignin() async {
    var user = auth.currentUser;
    return user != null;
  }

  Future getuser() async {
    var user = auth.currentUser;
    return user;
  }
}
