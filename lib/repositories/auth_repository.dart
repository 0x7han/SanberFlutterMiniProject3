import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  AuthRepository(
      {FirebaseAuth? firebaseAuth,
      FirebaseFirestore? firestore,
      FirebaseStorage? storage})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<User?> signInWithEmailPassword(
      String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .signInWithEmailAndPassword(email: email, password: password);
    User? user = userCredential.user;


    return user;
  }

  Future<User?> signUpWithEmailPassword(
      String email, String password, String fullname, File? photo) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    String? photoUrl;
    if (photo != null) {
      photoUrl = await _uploadPhoto(userCredential.user!.uid, photo);
    }

    await _firestore.collection('users').doc(userCredential.user!.uid).set({
      'fullname': fullname,
      'email': email,
      'password' : password,
      'photoUrl': photoUrl,
    });

    return userCredential.user;
  }

  Future<String?> _uploadPhoto(String userId, File photo) async {
    TaskSnapshot snapshot =
        await _storage.ref('user_photos/$userId').putFile(photo);
    return await snapshot.ref.getDownloadURL();
  }

  Future<Map<String, dynamic>?> getUserInfo(
      String uid) async {

    DocumentSnapshot<Map<String, dynamic>> userInfoSnapshot =
        await _firestore.collection('users').doc(uid).get();

    Map<String, dynamic>? userInfo = userInfoSnapshot.data();

    return {
      'uid': uid,
      'fullname': userInfo!['fullname'],
      'email': userInfo['email'],
      'password': userInfo['password'],
      'photoUrl': userInfo['photoUrl'],
    };
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }


   Stream<User?> get user => _firebaseAuth.authStateChanges();
}
