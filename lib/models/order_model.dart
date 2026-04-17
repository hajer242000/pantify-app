
import 'package:plant_app/models/orderitems_model.dart';

class OrderModel {
  final String? id;
  final String userID;
  final String addressID;
  final String shippedType;
  final double total;
  final String paymentMethod;
  final DateTime? orderPost;
  final List<OrderItemsModel>? items;
  final String shippingMethod;

  final String? status;
  final String? track;

  OrderModel({
    this.id,
    this.orderPost,
    required this.userID,
    required this.addressID,
    required this.shippedType,
    required this.total,
    required this.paymentMethod,
    required this.shippingMethod,
    this.items,
    this.status,
    this.track,
  });

  static DateTime? _tryParseDate(dynamic v) {
    if (v == null) return null;
    if (v is DateTime) return v;
    if (v is String) return DateTime.tryParse(v);
    return null;
  }

  factory OrderModel.fromMap(Map<String, dynamic> data) {
    return OrderModel(
      id: data['id'] as String?,
      orderPost: _tryParseDate(data['created_at']),
      userID: data['user_id'] as String,
      addressID: data['address_id'] as String,
      shippedType: data['shipping_type'] as String? ?? '',
      total: (data['total'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: data['payment_method'] as String? ?? '',
      shippingMethod:
          data['shipping_methods'] as String? ?? data['shipping_method'] as String? ?? '',
      status: data['status'] as String?,
      track: data['track'] as String?,
      items: data['order_items'] != null
          ? (data['order_items'] as List)
              .map(
                (e) => OrderItemsModel.fromMap(
                  Map<String, dynamic>.from(e as Map),
                ),
              )
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userID,
      'address_id': addressID,
      'shipping_type': shippedType,
      'total': total,
      'payment_method': paymentMethod,
      'shipping_methods': shippingMethod,
      'status': status,
      'track': track,
     
    };
  }
}
