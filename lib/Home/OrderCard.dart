import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:tc_restaurant/Home/OrderPage.dart';
import 'package:tc_restaurant/Model/order.dart';

class OrderCard extends StatelessWidget {

  final Order order;
  final bool isNew;

  OrderCard({ required this.order, required this.isNew });

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.fromMillisecondsSinceEpoch(
        order.orderDetails.createdAt!);
    String phone =
        '(${order.orderContact.phone.substring(0, 3)})-${order.orderContact.phone.substring(3, 6)}-${order.orderContact.phone.substring(6)}';

    TextStyle orderText = TextStyle(
      fontSize: 15,
      color: Colors.black54,
    );

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: ListTile(
            onTap: () {
              FlutterRingtonePlayer.stop();
              Get.to(() => OrderPage(order: order, isNew: isNew));
            },
            contentPadding: EdgeInsets.all(25),
            title: Text(
              order.orderDetails.isDelivery!
                  ? 'DELIVERY'
                  : 'PICK UP',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Date: ${date.month}/${date.day} '
                      '${date.hour.isGreaterThan(10) ? date.hour : '0${date.hour}'}'
                      ':${date.minute.isGreaterThan(10) ? date.minute : '0${date.minute}'}',
                  style: orderText,
                ),
                Text('Name: ${order.orderContact.name}',
                    style: orderText),
                Text('Phone: $phone', style: orderText),
              ],
            ),
            leading: FaIcon(
              order.orderDetails.isDelivery!
                  ? FontAwesomeIcons.car
                  : FontAwesomeIcons.shoppingBag,
              size: 35,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    'Item Count: ${order.orderDetails.totalItemCount}'),
                Text(
                    'Total: \$${order.orderDetails.total!.toStringAsFixed(2)}'),
              ],
            )),
      ),
    );
  }
}
