import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/models/orderitems_model.dart' show OrderItemsModel;
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderController {
  final SupabaseClient supabaseClient;
  OrderController(this.supabaseClient);

  Future<OrderModel> addOrder(
    OrderModel order,
    List<OrderItemsModel> items,
  ) async {
    try {
      final currentUser = supabaseClient.auth.currentUser;
      if (currentUser == null) {
        throw StateError('No authenticated user found.');
      }

      final userOrder = Map<String, dynamic>.from(order.toMap())..remove('id');
      userOrder['user_id'] = currentUser.id;

      final insertedOrder = await supabaseClient
          .from('orders')
          .insert(userOrder)
          .select()
          .maybeSingle();

      if (insertedOrder == null) {
        throw StateError('Order insert returned null. Check RLS / policies.');
      }

      final insertedMap = Map<String, dynamic>.from(insertedOrder as Map);
      final createdOrderId = insertedMap['id'] as String?;
      if (createdOrderId == null) {
        throw StateError('Inserted order has no id. Response: $insertedMap');
      }

      final itemsMaps = items.map((it) {
        final m = Map<String, dynamic>.from(it.toMap())..remove('id');
        m['order_id'] = createdOrderId;
        return m;
      }).toList();

      if (itemsMaps.isNotEmpty) {
        final itemsInsertRes = await supabaseClient
            .from('order_items')
            .insert(itemsMaps)
            .select();
      }

      final fullOrder = await supabaseClient
          .from('orders')
          .select('*, order_items(*)')
          .eq('id', createdOrderId)
          .maybeSingle();

      if (fullOrder == null) {
        return OrderModel.fromMap(insertedMap);
      }

      return OrderModel.fromMap(Map<String, dynamic>.from(fullOrder as Map));
    } catch (e, st) {
      print('AddOrder error: $e\n$st');
      rethrow;
    }
  }

  Future<OrderModel?> getLastOrder() async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw StateError('No authenticated user found.');
    }

    final rawRes = await supabaseClient
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', currentUser.id)
        .order('created_at', ascending: false)
        .limit(1)
        .maybeSingle();

    if (rawRes == null) {
      return null;
    }

    final rawMap = Map<String, dynamic>.from(rawRes as Map);

    print("order post data : ${rawMap['created_at']}");
    return OrderModel.fromMap(rawMap);
  }

  Future<List<OrderModel>> getTabOrder(String status) async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw StateError('No authenticated user found.');
    }

    final rawRes = await supabaseClient
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', currentUser.id)
        .eq('status', status)
        .order('created_at', ascending: false);

    if (rawRes == null) return [];

    final list = (rawRes as List)
        .map(
          (toElement) =>
              OrderModel.fromMap(Map<String, dynamic>.from(toElement as Map)),
        )
        .toList();

    return list;
  }



  Future<OrderModel> getOrderByID(String id) async {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) {
      throw StateError('No authenticated user found.');
    }

    final rawRes = await supabaseClient
        .from('orders')
        .select('*, order_items(*)')
        .eq('user_id', currentUser.id)
        .eq('id', id)
        .limit(1)
        .maybeSingle();



    final rawMap = Map<String, dynamic>.from(rawRes as Map);

   
    return OrderModel.fromMap(rawMap);
  }
}
