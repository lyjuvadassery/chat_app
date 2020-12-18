import 'package:firebase_chat_app/helpers/app_utils.dart';
import 'package:firebase_chat_app/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class AuthService {
  static AuthService _authService = AuthService._internal();

  factory AuthService() {
    return _authService;
  }

  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _facebookLogin = FacebookLogin();

  Stream<User> get currentUser => _auth.authStateChanges();

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      AppUtils.showToast(e.message);
      return null;
    }
  }

  Future signUpWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      AppUtils.showToast(e.message);
      return null;
    }
  }

  Future<dynamic> signInWithCredential(AuthCredential credential) =>
      _auth.signInWithCredential(credential);

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      AppUtils.showToast(e.message);
      return null;
    }
  }

  Future signInWithFacebook(BuildContext context) async {
    print('Starting Facebook Login');

    final res = await _facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (res.status) {
      case FacebookLoginStatus.Success:
        print('Logged in to Facebook');

        //Get token
        final FacebookAccessToken fbToken = res.accessToken;

        //Convert to auth credential
        final AuthCredential credential =
            FacebookAuthProvider.credential(fbToken.token);

        //Pass credential to log in with Firebase
        final result = await signInWithCredential(credential);

        print('${result.user.displayName} is now logged in');

        User user = result.user;

        // return _userFromFirebaseUser(user);
        return user;

        break;
      case FacebookLoginStatus.Cancel:
        print('User canceled login');
        Navigator.pop(context);
        return null;
        break;
      case FacebookLoginStatus.Error:
        print('Error encountered');
        return null;
        break;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      AppUtils.showToast(e.message);
      return null;
    }
  }
}
