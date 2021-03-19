import 'package:crud_productos/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';

final ProductFormProvider = ChangeNotifierProvider((_)=>ProductFormState());

class ProductFormState extends ChangeNotifier {
  String _id = '';
  String _name = '';
  String _description = '';
  int _stock = 0;
  int _price = 0;

  set id(String id) => this._id = id;

  set name(String name) => this._name = name;

  set description(String description) => this._description = description;

  set stock(int stock) => this._stock = stock;

  set price(int price) => this._price = price;

  String get id => this._id;

  String get name => this._name;

  String get description => this._description;

  int get stock => this._stock;

  int get price => this._price;

  // void changeId(String id){
  //   this._id = id;
  // }

  void onNameChanged(String name){
    if(name != _name){
      _name = name;
      notifyListeners();
    }
  }
  void onDescriptionChanged(String description){
    if(description != _description){
      _description = description;
      notifyListeners();
    }
  }
  void onPriceChanged(String price){
    final int _formated = int.parse(price);
    if(_price != _formated){
      _price = _formated;
      notifyListeners();
    }
  }
  void onStockChanged(String stock){
    final int _formated = int.parse(stock);
    if(_stock != _formated){
      _stock = _formated;
      notifyListeners();
    }
  }

  Product get product {
    return Product(
      id: id,
      name: name,
      description: description,
      stock: stock,
      price: price,
    );
  }

  set product(Product p) {
    id = p.id;
    name = p.name;
    description = p.description;
    stock = p.stock;
    price = p.price;
    notifyListeners();
  }

  bool validatedState() {
    final a = description.isNotEmpty;
    final b = description.length > 5;
    final c = price != 0;

    return a && b && c;
  }

  void clean(){
    this._id = '';
    this._name = '';
    this._description = '';
    this._stock = 0;
    this._price = 0;
  }
}