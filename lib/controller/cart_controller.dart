import 'package:flutter_riverpod/legacy.dart';
import 'package:plant_app/models/cart_model.dart';
import 'package:plant_app/models/plant_model.dart';

class CartController extends StateNotifier<List<CartModel>> {
  CartController() : super([]);

  addToCart(PlantModel product, {int q = 1}) {
    int index = state.indexWhere((test) => test.id == product.id);

    if (index == -1) {
      state = [
        ...state,
        CartModel(
          id: product.id,
          name: product.name,
          price: product.price,
          quantity: q,
          category: product.category!.name,
          image: product.image,
        ),
      ];
    } else {
      final item = state[index];
      final next = List<CartModel>.of(state)
        ..[index] = item.copyWith(qty: q + item.quantity);
      state = next;
    }
  }

  increment(String id) {
    int index = state.indexWhere((test) => test.id == id);
    if (index == -1) return;

    final item = state[index];
    final next = List<CartModel>.of(state)
      ..[index] = item.copyWith(qty: 1 + item.quantity);
    state = next;
  }

  decrement(String id) {
    int index = state.indexWhere((test) => test.id == id);
    if (index == -1) return;
    final item = state[index];
    if (item.quantity <= 1) {
      state = [
        for (final e in state)
          if (item.id != e.id) e,
      ];
      
    } else {
      final next = List<CartModel>.of(state)
        ..[index] = item.copyWith(qty: item.quantity - 1);
      state = next;
    }
  }

  remove(String id) {
    int index = state.indexWhere((test) => test.id == id);
    final item = state[index];
    state = [
      for (final e in state)
        if (item.id != e.id) e,
    ];
  }

  clear() {
    state = [];
  }
}
