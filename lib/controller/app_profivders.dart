import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:plant_app/controller/address_controller.dart';
import 'package:plant_app/controller/app_service.dart';
import 'package:plant_app/controller/cart_controller.dart';
import 'package:plant_app/controller/order_controller.dart';
import 'package:plant_app/controller/wish_list_service.dart';
import 'package:plant_app/models/address_model.dart';
import 'package:plant_app/models/cart_model.dart';
import 'package:plant_app/models/category_model.dart';
import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/models/seller_model.dart';
import 'package:plant_app/repository/auth_repository.dart';
import 'package:plant_app/statics_var.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/orderitems_model.dart' show OrderItemsModel;

final provider = Provider((ref) {
  return AppService();
});

final categoryProvider = FutureProvider<List<CategoryModel>>(
  (ref) => ref.read(provider).getCategories(),
);

final plantsByCategoryProvider =
    FutureProvider.family<List<PlantModel>, String>(
      (ref, categoryId) => ref.read(provider).getPlantsByCategory(categoryId),
    );

final sellerProvider = FutureProvider<List<SellerModel>>(
  (ref) => ref.read(provider).getSellers(),
);

final getPlantById = FutureProvider.family<PlantModel, String>(
  (ref, id) => ref.read(provider).getPlantsById(id),
);

final getAllPlants = FutureProvider<List<PlantModel>>(
  (ref, ) => ref.read(provider).getAllPlants(),
);

final getSellerPlants = FutureProvider.family<List<PlantModel>, String>(
      (ref, sellerId)  => ref.read(provider).getSellerPlants(sellerId),
);

final stateProvider = StateNotifierProvider<CartController, List<CartModel>>(
  (ref) => CartController(),
);

final stateSubTotalProvider = StateProvider<double>((ref) {
  final items = ref.watch(stateProvider);
  return items.fold<double>(0.0, (sum, e) => sum + (e.price * e.quantity));
});
final stateTaxProvider = StateProvider<double>((ref) {
  final items = ref.watch(stateProvider);
  return items.fold<double>(
    0.0,
    (sum, e) => sum + (e.price * 0.05 * e.quantity),
  );
});
final stateTotalProvider = StateProvider.family<double, int>((ref, delivery) {
  final subtotal = ref.watch(stateSubTotalProvider);
  final tax = ref.watch(stateTaxProvider);
  return subtotal + delivery + tax;
});

final wishlistProvider =
    StateNotifierProvider<WishListService, List<PlantModel>>(
      (ref) => WishListService(),
    );
final wishlistSellersProvider =
    StateNotifierProvider<WishListSellers, List<SellerModel>>(
      (ref) => WishListSellers(),
    );
final supabaseClientProvider = Provider<SupabaseClient>((ref) => supabase);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return AuthRepository(client);
});

final userAddress = Provider(
  (ref) => AddressController(ref.read(supabaseClientProvider)),
);

final addAddress = FutureProvider.family<void, AddressModel>((ref, address) {
  return ref.read(userAddress).addAddress(address);
});

final getAddress = FutureProvider.family<List<AddressModel>, String>((
  ref,
  userId,
) {
  return ref.read(userAddress).getAddresses(userId);
});

final getDefaultAddress = FutureProvider.family<AddressModel?, String>(
  (ref, userId) => ref.read(userAddress).getDefaultAddress(userId),
);

final ordersProvider = Provider(
  (ref) => OrderController(ref.read(supabaseClientProvider)),
);

final addOrderProvider =
    FutureProvider.family<OrderModel, Map<String, dynamic>>((ref, params) {
      final controller = ref.read(ordersProvider);
      final order = params['order'] as OrderModel;
      final items = params['items'] as List<OrderItemsModel>;
      return controller.addOrder(order, items);
    });

final getLastOrder = FutureProvider(
  (ref) => ref.read(ordersProvider).getLastOrder(),
);

final getTabOrder = FutureProvider.family<List<OrderModel>, String>((
  ref,
  status,
) {
  final controller = ref.read(ordersProvider);

  return controller.getTabOrder(status);
});

final getOrderById = FutureProvider.family<OrderModel, String>(
  (ref, id) => ref.read(ordersProvider).getOrderByID(id),
);
