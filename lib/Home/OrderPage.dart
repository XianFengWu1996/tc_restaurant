import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:tc_restaurant/Function/Loading.dart';
import 'package:tc_restaurant/Model/order.dart';
import 'package:tc_restaurant/RestaurantBloc.dart';

class OrderPage extends StatefulWidget {
  final Order order;
  final bool isNew;
  OrderPage({required this.order, required this.isNew});

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  String _error = '';

  @override
  Widget build(BuildContext context) {
    OrderDetails orderDetails = widget.order.orderDetails;
    OrderContact orderContact = widget.order.orderContact;

    String phone =
        '(${widget.order.orderContact.phone.substring(0, 3)})-${widget.order.orderContact.phone.substring(3, 6)}-${widget.order.orderContact.phone.substring(6)}';
    RestaurantBloc restaurantBloc = Provider.of<RestaurantBloc>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,), onPressed: (){
          Navigator.pop(context);
        },),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 20, bottom: 20),
                child: Text(
                  '${orderDetails.type!.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 35,
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                color: Colors.pink[50],
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderDetails.isDelivery!
                            ? 'Delivery'.toUpperCase()
                            : 'Pick Up'.toUpperCase(),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      orderDetails.isDelivery!
                          ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(orderDetails.address!.address!.replaceFirst(
                              'USA', orderDetails.address!.zipcode!), style: TextStyle(fontSize: 18, letterSpacing: 0.6),),
                          orderDetails.address!.apt!.isNotEmpty
                              ? Text('APT: ${orderDetails.address!.apt}', style: TextStyle(fontSize: 18, letterSpacing: 0.6),)
                              : Container(),
                          orderDetails.address!.business!.isNotEmpty
                              ? Text(
                            'Business: ${orderDetails.address!.business}', style: TextStyle(fontSize: 18, letterSpacing: 0.6),)
                              : Container(),
                          Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 60),
                            child: Divider(),
                          ),
                        ],
                      )
                          : Container(),
                      Text('Order #: ${orderDetails.orderId}',
                          style: TextStyle(fontSize: 18, letterSpacing: 0.6)),
                      Text('Name: ${orderContact.name}',
                          style: TextStyle(fontSize: 18, letterSpacing: 0.6)),
                      Text('Phone: $phone',
                          style: TextStyle(fontSize: 18, letterSpacing: 0.6)),
                      Text(
                          'Number Of Items: ${orderDetails.totalItemCount!.toString()}',
                          style: TextStyle(fontSize: 18, letterSpacing: 0.6)),
                    ],
                  ),
                ),
              ),
              Divider(
                color: Colors.black,
                thickness: 1.2,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderDetails.items.length,
                    itemBuilder: (context, index) {
                      Dish dish = orderDetails.items[index];
                      return Column(
                        children: [
                          ListTile(
                            title:
                            Text('${dish.foodId}. ${dish.foodNameChinese}'),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('${dish.foodName}'),
                                dish.comment.isNotEmpty
                                    ? Text('Special Instruction: ${dish.comment}',
                                    style: TextStyle(color: Colors.red))
                                    : Container(),
                              ],
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                    '\$${dish.price.toStringAsFixed(2)} x ${dish.count}'),
                                Text('Total: \$${dish.total.toStringAsFixed(2)}'),
                              ],
                            ),
                          ),
                          orderDetails.items.length > 1 ? Divider() : Container(),
                        ],
                      );
                    }),
              ),
              Divider(
                color: Colors.black,
                thickness: 1.2,
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    orderDetails.comment!.isNotEmpty
                        ? Text(
                        'Special Instruction: this is a comment ${orderDetails.comment}',
                        style: TextStyle(color: Colors.red))
                        : Container(),
                    SizedBox(
                      height: 10,
                    ),
                    orderDetails.discount! > 0
                        ? SummaryItem(
                        title: 'Discount', amount: (-orderDetails.discount!))
                        : Container(),
                    orderDetails.lunchDiscount! > 0
                        ? SummaryItem(
                        title: 'Lunch Discount',
                        amount: (-orderDetails.lunchDiscount!))
                        : Container(),
                    orderDetails.discount! > 0 || orderDetails.lunchDiscount! > 0
                        ? Divider()
                        : Container(),
                    SummaryItem(
                        title: 'Subtotal', amount: orderDetails.subtotal!),
                    SummaryItem(title: 'Tax', amount: orderDetails.tax!),
                    orderDetails.delivery! > 0
                        ? SummaryItem(
                        title: 'Delivery', amount: orderDetails.delivery!)
                        : Container(),
                    SummaryItem(title: 'Tip', amount: orderDetails.tip!),
                    SummaryItem(title: 'Total', amount: orderDetails.total!),
                  ],
                ),
              ),

              widget.isNew ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 40, right: 40))
                      ),
                      onPressed: () async {
                        setState(() {
                          _error = '';
                        });

                        handleStartLoading();
                        await FirebaseFirestore.instance.collection('newOrder').doc(widget.order.orderDetails.orderId).delete().then((value) {
                          restaurantBloc.removeOrder(widget.order.orderDetails.orderId!);
                          Navigator.pop(context);
                        }).catchError((error) {
                          setState(() {
                            _error = error.message != null ? error.message : 'Failed to delete';
                          });
                        });
                        handleEndLoading();
                      }, child: Text('Done')),
                ],
              ) : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 40, right: 40))
                      ),
                      onPressed: (){}, child: Text('Refund')),
                  SizedBox(width: 40),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.black),
                          padding: MaterialStateProperty.all(EdgeInsets.only(left: 40, right: 40))
                      ),
                      onPressed: (){}, child: Text('Cancel')),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(_error, style: TextStyle(color: Colors.red),),
                ],
              ),
            ],
          ),
        ),
      ),
    );


  }
}

class SummaryItem extends StatelessWidget {
  final String title;
  final double amount;

  SummaryItem({required this.title, required this.amount});

  @override
  Widget build(BuildContext context) {
    TextStyle text = TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('$title: '.toUpperCase(), style: text),
        amount.isNegative
            ? Text('- (\$${amount.abs().toStringAsFixed(2)})', style: text,)
            : Text('\$${amount.toStringAsFixed(2)}', style: text),
      ],
    );
  }
}
