import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanber_flutter_mini_project_3/model/cart.dart';

import 'package:http/http.dart' as http;

class CartRepository {

  final FirebaseFirestore _firestore;

  CartRepository({FirebaseFirestore? firebaseFirestore}) : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  String collectionName = 'carts';

  Stream<List<Cart>> get() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Cart.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> exportToFirestore() async {
    List<Cart> carts = await getAllFromAPI();
        for (var e in carts) {
           await _firestore.collection(collectionName).add(e.toMap());
        }
   
  }

  Future<void> resetFirestore() async {
  final snapshot = await _firestore.collection(collectionName).get();
  for (var doc in snapshot.docs) {
    await _firestore.collection(collectionName).doc(doc.id).delete();
  }
}


  // API

  static const String _baseUrl = 'https://fakestoreapi.com';
  static const Map<String, String> _headers = {
    "Content-Type": "application/json",
  };
  final _urlCarts = Uri.parse('$_baseUrl/carts');

  Future<List<Cart>> getAllFromAPI() async {
    
    final http.Response response = await http.get(_urlCarts, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Cart.fromMap(e, e['id'])).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

}
