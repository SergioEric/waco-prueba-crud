import 'dart:async';
import 'package:crud_productos/models/product.dart';
import 'package:crud_productos/services/api.path.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

import 'firestore.services.dart';

abstract class Database {
  //CREATE
  Future<void> createProduct(Product product);

  //DELETE
  Future<void> deletedProduct(Product product);

  //READ-ALL
  Stream<List<Product>> productsStream();

  //READ-SINGLE
  Stream<Product> productStream({required String productId});

  //UPDATE
  Future<void> updatedProduct(Product product);
}

String documentIdFromCurrentDate() => DateTime.now().toIso8601String();

class FirestoreDatabase implements Database {
  FirestoreDatabase({required this.uid});

  //user unique id
  final String uid;

  final _service = FirestoreService.instance;

  @override
  Future<void> createProduct(Product product) => _service.setData(
        path: APIPath.product(uid),
        data: product.toMap(),
      );

  @override
  Future<void> deletedProduct(Product product) => _service.deleteData(
        path: APIPath.productWithId(uid, product.id),
      );

  @override
  Stream<Product> productStream({required String productId}) =>
      _service.documentStream(
        path: APIPath.productWithId(uid, productId),
        builder: (data, documentId) => Product.fromMap(data!, documentId),
      );

  @override
  Stream<List<Product>> productsStream() => _service.collectionStream(
        path: APIPath.product(uid),
        builder: (data, documentId) => Product.fromMap(data!,documentId),
      );

  @override
  Future<void> updatedProduct(Product product) => _service.updateData(
        path: APIPath.productWithId(uid, product.id),
        data: product.toMap(),
      );
}
