import 'dart:convert';

import 'package:equatable/equatable.dart';

class Product extends Equatable {
  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.stock,
    required this.price,
  });

  final String id;
  final String name;
  final String description;
  final int stock;
  final int price;

  @override
  List<Object?> get props => [id, name, description, stock, price,];

  // we omit the product description in console logs
  @override
  String toString() {
    return ''' 
    Product{
      id : $id,
      name: $name,
      price : $price,
      stock : $stock,
    }
  ''';
  }

  Product copyWith({
    String? id,
    String? name,
    String? description,
    int? stock,
    int? price,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      stock: stock ?? this.stock,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'stock': stock,
      'price': price,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map, String productId) {
    return Product(
      id: productId,
      name: map['name'],
      description: map['description'],
      stock: map['stock'],
      price: map['price'],
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;
}
