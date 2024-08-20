import 'package:flutter/cupertino.dart';
import 'package:flutter_shopping_cart/db_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart_model.dart';

class CartProvider with ChangeNotifier{

  DbHelper dbHelper=DbHelper();

  int _counter=0;
  int get counter => _counter;

  double _totalPrice=0.0;
  double get totalPrice=> _totalPrice;


  late Future<List<CartModel>> _cartList;
  Future<List<CartModel>> get cartList=>_cartList;

  Future<List<CartModel>> getData() async{
    _cartList= dbHelper.getData();
    return _cartList;
  }


  void setPrefItems() async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    pref.setInt('cart_item', _counter);
    pref.setDouble('total_price', _totalPrice);
    notifyListeners();
  }

  void getPrefItems() async{
    SharedPreferences pref= await SharedPreferences.getInstance();
    _counter=pref.getInt('cart_item') ?? 0;
    _totalPrice=pref.getDouble('total_price') ?? 0.0;
    notifyListeners();
  }

  void addTotalPrice(double productPrice) {
    _totalPrice+=productPrice;
    setPrefItems();
  }

  void removeTotalPrice(double productPrice) {
    _totalPrice-=productPrice;
    setPrefItems();
  }

  double getTotalPrice() {
    getPrefItems();
    return _totalPrice;
  }

  void addCounter() {
    _counter++;
    setPrefItems();
  }
  void removeCounter() {
    _counter--;
    setPrefItems();
  }

  int getCounter() {
    getPrefItems();
    return _counter;
  }


}