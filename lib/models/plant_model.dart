import 'package:plant_app/models/category_model.dart';
import 'package:plant_app/models/seller_model.dart';
import 'package:plant_app/utils/num_cast.dart';

class PlantModel {
  final String id;
  final String name;
  final String description;
  final String type;
  final String season;
  final double price;
  final double discount;
  final int quantity;
  final String image;
  final String categoryId;
  final CategoryModel? category;

  final String? sellerId;
  final SellerModel? seller;

  PlantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.season,
    required this.price,
    required this.discount,
    required this.quantity,
    required this.image,
    required this.categoryId,
    this.category,
    this.sellerId,
    this.seller,
  });

  factory PlantModel.fromMap(Map<String, dynamic> m) {
    return PlantModel(
      id: m['id'].toString(),
      name: m['name'] ?? '',
      description: m['description'] ?? '',
      type: m['type'] ?? '',
      season: m['season'] ?? '',
      price: NumCast.toDouble(m['price']),
      discount: NumCast.toDouble(m['discount']),
      quantity: NumCast.toInt(m['quantity']),
      image: m['image'] ?? '',
      categoryId: m['category_id']?.toString() ?? '',
      sellerId: m['seller_id']?.toString(),
      category: _categoryFrom(m['category']),
      seller: _sellerFrom(m['seller']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'type': type,
      'season': season,
      'price': price,
      'discount': discount,
      'quantity': quantity,
      'image': image,
      'category_id': categoryId,
      'seller_id': sellerId,
      'category': _categoryFrom(category),
      'seller': _sellerFrom(seller),
    };
  }

  static CategoryModel? _categoryFrom(dynamic v) {
    if (v is Map<String, dynamic>) return CategoryModel.fromMap(v);
    if (v is List && v.isNotEmpty && v.first is Map<String, dynamic>) {
      return CategoryModel.fromMap(v.first as Map<String, dynamic>);
    }
    return null;
  }

  static SellerModel? _sellerFrom(dynamic v) {
    if (v is Map<String, dynamic>) return SellerModel.fromMap(v);
    if (v is List && v.isNotEmpty && v.first is Map<String, dynamic>) {
      return SellerModel.fromMap(v.first as Map<String, dynamic>);
    }
    return null;
  }
}
