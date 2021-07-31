
import 'package:flutter/material.dart';
import 'package:tc_restaurant/Model/order.dart';

class RestaurantBloc with ChangeNotifier{
  String _userId = '';
  List<Order> _newOrder = [];
  List<String> _orderIdList = [];

  String get userId => _userId;
  List<Order> get newOrder => _newOrder;
  List<String> get orderIdList => _orderIdList;


  // grab the user id at login
  void setUserId (String uid){
    _userId = uid;
    notifyListeners();
  }

  // grab the order and order id and push it into the lists
  void getOrder(Order order, String orderId){
    _newOrder.insert(0, order);
    _orderIdList.add(orderId);
    notifyListeners();
  }

  Future<String> removeOrder(String orderId){
    _newOrder.removeWhere((element) => element.orderDetails.orderId == orderId);
    _orderIdList.remove(orderId);
    notifyListeners();

    return Future.value('Success');
  }

  void logout(){
    _userId = '';
    _newOrder = [];
    _orderIdList = [];
    notifyListeners();
  }

}