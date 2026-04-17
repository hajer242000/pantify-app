class CartModel {
  final String id;
  final String name;
  final String category;
  final String image;
  final double price;
  final int quantity;

  CartModel({
    required this.id,
    required this.name,
    required this.category,
    required this.image,
    required this.price,
     this.quantity =1,
  });

  CartModel copyWith ({int? qty}) {
    return CartModel(
      id: id,
      name: name,
      category: category,
      image: image,
      price: price,
      quantity: qty ?? quantity
    );
  }
}
