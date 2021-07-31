import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tc_restaurant/Home/OrderCard.dart';
import 'package:tc_restaurant/Model/order.dart';
import 'package:tc_restaurant/RestaurantBloc.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  ConnectivityResult connectivityResult = ConnectivityResult.none;

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    print(result);
    setState((){
      connectivityResult = result;
    });

    if(result == ConnectivityResult.none){
      Get.defaultDialog(title: 'Network Issue  网络异常', content: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text('There\'s seems to be no internet connection. 没网络请重连'),
      ),
          confirm: TextButton(onPressed: (){
            FlutterRingtonePlayer.stop();
            Get.close(1);
          }, child: Text('Okay'),), );
      FlutterRingtonePlayer.playNotification(looping: true);
    }


  }

  @override
  void initState() {
    super.initState();

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

// Make sure to cancel subscription after you are done
  @override
  dispose() {
    super.dispose();

    _connectivitySubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    RestaurantBloc restaurantBloc = Provider.of<RestaurantBloc>(context);
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text('Taipei Cuisine'),
            ),
            ListTile(
              title: Text('New Order'),
              onTap: () {
                Navigator.pushNamed(context, 'new');
              },
            ),
            ListTile(
              title: Text('All Order'),
              onTap: () {
                Navigator.pushNamed(context, 'all');
              },
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.red),
              ),
              onPressed: (){
              restaurantBloc.logout();
              FirebaseAuth.instance.signOut();
              Navigator.pushNamed(context, 'login');
              }, child: Text('Logout')),
          ],
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "New Order",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.music_off_outlined),
          onPressed: (){
        FlutterRingtonePlayer.stop();
      }),
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('newOrder').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> ds = snapshot.data!.docs;

            ds.sort((a, b) {
              return b['order']['createdAt'].compareTo(a['order']['createdAt']);
            });

            // loop to make sure there is no duplicated order
            for (var data in ds) {
              if(!restaurantBloc.orderIdList.contains(data['order']['orderId'])){
                restaurantBloc.getOrder(Order(
                    orderDetails: OrderDetails.fromMap(data['order']),
                    orderStatus: OrderStatus(
                        cancel: data['orderStatus']['cancel'] ?? false,
                        refund: data['orderStatus']['refund'] ?? false,
                        refundAmount:
                        data['orderStatus']['refundAmount'].toDouble() ??
                            0.00),
                    orderSquare: OrderSquare(
                      brand: data['square']['brand'] ?? '',
                      lastFourDigit: data['square']['lastFourDigit'] ?? '',
                      orderId: data['square']['orderId'] ?? '',
                      paymentId: data['square']['paymentId'] ?? '',
                    ),
                    orderContact: OrderContact(
                        phone: data['contact']['phone'],
                        name: data['contact']['name'],
                        email: data['contact']['email'],
                        userId: data['contact']['userId'])), data['order']['orderId']);
                FlutterRingtonePlayer.playAlarm(looping: true);
              }
            }

            return ListView.builder(
                itemCount: restaurantBloc.newOrder.length,
                itemBuilder: (context, index) {
                  return OrderCard(order: restaurantBloc.newOrder[index], isNew: true,);
                });
          } else {
            return Text(
              'No Data...',
            );
          }
        },
      ),
    );
  }
}

