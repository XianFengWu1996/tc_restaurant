class Order {
  OrderContact orderContact;
  OrderSquare orderSquare;
  OrderDetails orderDetails;
  OrderStatus orderStatus;

  Order(
      {required this.orderDetails,
      required this.orderStatus,
      required this.orderSquare,
      required this.orderContact});
}

class OrderContact {
  final String phone;
  final String name;
  final String userId;
  final String email;

  OrderContact(
      {required this.phone,
      required this.name,
      required this.email,
      required this.userId});
}

class OrderStatus {
  final bool cancel;
  final bool refund;
  final double refundAmount;

  OrderStatus(
      {required this.cancel, required this.refund, required this.refundAmount});
}

class OrderDetails {
  Address? address;
  String? comment;
  int? createdAt;
  double? delivery;
  double? discount;
  bool? isDelivery;
  List<Dish> items = [];
  double? lunchDiscount;
  String? orderId;
  double? pointEarned;
  double? pointUsed;
  double? subtotal;
  double? tax;
  double? tip;
  double? total;
  int? totalItemCount;
  String? type;



  OrderDetails.fromMap(Map<String, dynamic> order) {
      address = Address(
          address: order['address']['address'] ?? '',
          zipcode: order['address']['zipcode'] ?? '',
          apt: order['address']['apt'] ?? '',
          business: order['address']['business'] ?? '');
      comment = order['comment'];
      createdAt = order['createdAt'];
      delivery = order['delivery'].toDouble();
      discount = order['discount'].toDouble();
      isDelivery = order['isDelivery'];
      lunchDiscount = order['lunchDiscount'].toDouble();

      orderId = order['orderId'];
      pointEarned = order['pointEarned'].toDouble();

      pointUsed = order['pointUsed'].toDouble();

      subtotal = order['subtotal'].toDouble();

      tax = order['tax'].toDouble();

      tip = order['tip'].toDouble();

      total = order['total'].toDouble();

      totalItemCount = order['totalItemCount'];
      type = order['type'];


      for (var item in order['items']) {
        items.add(Dish(
            comment: item['comment'],
            count: item['count'],
            foodId: item['foodId'],
            foodName: item['foodName'],
            foodNameChinese: item['foodNameChinese'] == null ? item['foodChineseName'] : item['foodNameChinese'],
            price: item['price'].toDouble(),
            total: item['total'].toDouble(),
            options: item['option'] ?? {},
        ));
    }
  }
}

class OrderSquare {
  final String? brand;
  final String? lastFourDigit;
  final String? orderId;
  final String? paymentId;

  OrderSquare({this.brand, this.lastFourDigit, this.orderId, this.paymentId});
}

class Address {
  final String? address;
  final String? zipcode;
  final String? business;
  final String? apt;

  Address({this.address, this.zipcode, this.business, this.apt});
}

class Dish {
  final String comment;
  final int count;
  final String foodId;
  final String foodName;
  final String foodNameChinese;
  final double price;
  final double total;
  final Map<String, dynamic>? options;

  Dish(
      {required this.comment,
      required this.count,
      required this.foodId,
      required this.foodName,
      required this.foodNameChinese,
      required this.price,
      required this.total,
        this.options
      });
}
