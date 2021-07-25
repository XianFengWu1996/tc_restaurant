import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:provider/provider.dart';
import 'package:tc_restaurant/Home/OrderCard.dart';
import 'package:tc_restaurant/Model/order.dart';
import 'package:tc_restaurant/RestaurantBloc.dart';

class AllOrder extends StatefulWidget {
  @override
  _AllOrderState createState() => _AllOrderState();
}

class _AllOrderState extends State<AllOrder> {
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    RestaurantBloc restaurantBloc = Provider.of<RestaurantBloc>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.music_off_outlined),
          onPressed: (){
            FlutterRingtonePlayer.stop();
          }),
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
                onPressed:  () async {
                  await FirebaseAuth.instance.signOut();

                  restaurantBloc.logout();

                  FlutterRingtonePlayer.stop();
                  Navigator.pushNamed(context, 'login');
            }, child: Text('Logout')),
          ],
        ),
      ),

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "All Order",
          style: TextStyle(color: Colors.black, fontSize: 25),
        ),
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
        stream:
        FirebaseFirestore.instance.collection('order/${date.year}/${date.month}').snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            List<DocumentSnapshot> ds = snapshot.data!.docs;

            ds.sort((a, b) {
                return b['order']['createdAt'].compareTo(a['order']['createdAt']);
            });

            return ListView.builder(
                itemCount: ds.length,
                itemBuilder: (context, index) {
                  var data = ds[index];

                  return OrderCard(order: Order(
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
                          userId: data['contact']['userId'])), isNew: false,);
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

