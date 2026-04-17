import 'package:flutter_riverpod/legacy.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/models/seller_model.dart';

class WishListService extends StateNotifier<List<PlantModel>> {
  WishListService() : super([]);

  addToWishlist(PlantModel plant) {
    final index = state.indexWhere((test) => test.id == plant.id);
    if (index == -1) {
      state = [...state, plant];
    } else {
      state = [
        for (final e in state)
          if (e.id != plant.id) e,
      ];
    }
  }
}



class WishListSellers extends StateNotifier<List<SellerModel>> {
  WishListSellers() : super([]);

  addToWishlist(SellerModel seller) {
    final index = state.indexWhere((test) => test.id == seller.id);
    if (index == -1) {
      state = [...state, seller];
    } else {
      state = [
        for (final e in state)
          if (e.id != seller.id) e,
      ];
    }
  }
}
