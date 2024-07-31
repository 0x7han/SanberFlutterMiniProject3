import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sanber_flutter_mini_project_3/model/product.dart';

import 'package:http/http.dart' as http;

class ProductRepository {

  final FirebaseFirestore _firestore;

  ProductRepository({FirebaseFirestore? firebaseFirestore}) : _firestore = firebaseFirestore ?? FirebaseFirestore.instance;

  String collectionName = 'products';

  Stream<List<Product>> get() {
    return _firestore.collection(collectionName).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    });
  }

  Future<void> exportToFirestore() async {
    List<Product> products = await getAllFromAPI();
        for (var e in products) {
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
  final _urlProducts = Uri.parse('$_baseUrl/products');

  Future<List<Product>> getAllFromAPI() async {
    
    final http.Response response = await http.get(_urlProducts, headers: _headers);

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((e) => Product.fromMap(e, e['id'])).toList();
    } else {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<Product> getByIdFromAPI(int id) async {
    var url = Uri.parse('$_baseUrl/products/$id');

    final http.Response response = await http.get(url, headers: _headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> body = jsonDecode(response.body);
      return Product.fromMap(body, body['id']);
    } else {
      throw Exception(response.reasonPhrase);
    }
  }
}
