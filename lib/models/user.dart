import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String password;
  final String email;
  final bool isLoged;

  AppUser({
    required this.uid,
    required this.password,
    required this.email,
    required this.isLoged,
  });
}

class UserProvider extends StateNotifier<AppUser> {
  UserProvider()
      : super(AppUser(
          uid: "",
          email: "",
          password: "",
          isLoged: false,
        ));
  final _auth = FirebaseAuth.instance;
  final _database = FirebaseFirestore.instance;

  Future<void> loginOrSignUp(
      String email, String password, bool isLogin) async {
    try {
      final userCredential = isLogin
          ? await _auth.signInWithEmailAndPassword(
              email: email, password: password)
          : await _auth.createUserWithEmailAndPassword(
              email: email, password: password);
      final user = AppUser(
        uid: userCredential.user!.uid,
        email: email,
        password: password,
        isLoged: true,
      );
      state = user;
      adduserToDb();
      saveUserData(false, null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception("The password provided is too weak");
      } else if (e.code == 'email-already-in-use') {
        throw Exception("The account already exists for that email");
      } else if (e.code == 'wrong-password') {
        throw Exception("Wrong password provided for that user");
      } else {
        throw Exception(e.code);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> getValidationData() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    var obtainedEmail = preferences.getString("email");
    var obtainedToken = preferences.getString("token");
    var obtainedUid = preferences.getString("uid");
    final valData = [obtainedEmail, obtainedToken];
    if (valData[0] != null || valData[1] != null) {
      final userInfo =
          await _database.collection("users").doc(obtainedUid!).get();
      state = AppUser(
        uid: obtainedUid,
        email: userInfo["email"],
        password: userInfo["password"],
        isLoged: true,
      );
    } else {
      state = AppUser(
        uid: "",
        email: "",
        password: "",
        isLoged: false,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        final token = await userCredential.user?.getIdToken();
        final user = AppUser(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email as String,
          password: '',
          isLoged: true,
        );
        state = user;
        adduserToDb();
        saveUserData(true, token);
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> saveUserData(bool withToken, String? token) async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();

    if (withToken || token != null) {
      await preferences.setString("token", token!);
    } else {
      await preferences.setString("email", state.email);
    }
    await preferences.setString("uid", state.uid);
  }

  Future<void> logOut() async {
    final SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      _auth.signOut();
      await preferences.remove("token");
      await preferences.remove("email");
      await preferences.remove("uid");
    } catch (e) {
      print(e);
    }
    state = AppUser(
      uid: "",
      email: "",
      password: "",
      isLoged: false,
    );
  }

  Future<void> adduserToDb() async {
    final userInfoMap = {
      "email": state.email,
      "password": state.password,
    };
    try {
      await _database
          .collection("users")
          .doc(
            state.uid,
          )
          .set(userInfoMap);
    } catch (e) {
      print(e);
    }
  }
}
