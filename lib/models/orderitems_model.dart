
class OrderItemsModel {
  final String? id;
  final String orderID;
  final String plantID;
  final int quantity;
  final double price;

  OrderItemsModel({
    this.id,
    required this.orderID,
    required this.plantID,
    required this.quantity,
    required this.price,
  });

  factory OrderItemsModel.fromMap(Map<String, dynamic> data) {
    return OrderItemsModel(
      id: data['id'] as String?,
      orderID: data['order_id'] as String,
      plantID: data['product_id'] as String,
      quantity: (data['quantity'] as num).toInt(),
      price: (data['price'] as num).toDouble(),
    );
  }


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'order_id': orderID,
      'product_id': plantID,
      'quantity': quantity,
      'price': price,
    };
  }
}
