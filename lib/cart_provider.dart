
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_cart/db_helper.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{
DBHelper dbHelper = DBHelper();
  int _counter = 0;
      int get counter => _counter;

  double _totalPrice = 0.0;
  double get totalPrice => _totalPrice;

  late Future<List<Cart>>  _cart;
  Future<List<Cart>> get cart =>  _cart;

  Future<List<Cart>> getData() async {
    _cart = dbHelper.getCartList();
    return _cart;
  }

  void _setPrefItem() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('cart_item', _counter);
    preferences.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void _getPrefItem() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   _counter = preferences.getInt('cart_item')!;
   _totalPrice=  preferences.getDouble('total_price')!;
    notifyListeners();
  }

  void addTotalPrice(double productPrice){
_totalPrice = _totalPrice + productPrice;
    _setPrefItem();
    notifyListeners();
  }

  void removeTotalPrice(double productPrice){
    _totalPrice = _totalPrice - productPrice;
    _setPrefItem();
    notifyListeners();
  }

  double getTotalPrice(){
    _getPrefItem();
    return _totalPrice;
  }




  void addCounter(){
    _counter++;
    _setPrefItem();
    notifyListeners();
  }

  void removeCounter(){
    _counter--;
    _setPrefItem();
    notifyListeners();
  }

  int getCounter(){
    _getPrefItem();
    return _counter;
  }

}