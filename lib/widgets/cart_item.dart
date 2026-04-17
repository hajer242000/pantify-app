import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';

import 'package:plant_app/models/cart_model.dart';
import 'package:plant_app/theme/theme.dart';

class CartItem extends ConsumerWidget {
  final bool isInCart;
  final CartModel cartModel;
  const CartItem({super.key, this.isInCart = true, required this.cartModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: placeholdColor,
            image: DecorationImage(
              image: NetworkImage(cartModel.image),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(cartModel.name, style: TextStyle(fontSize: 15)),
              Text(
                cartModel.category,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Row(
                children: [
                  Text(
                    '\$ ${cartModel.price}',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  isInCart
                      ? Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(stateProvider.notifier)
                                    .decrement(cartModel.id);
                        
                              },
                              icon: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: const Color.fromARGB(
                                    255,
                                    239,
                                    238,
                                    238,
                                  ),
                                ),
                                child: Icon(Icons.remove),
                              ),
                            ),
                            Text(
                              cartModel.quantity.toString(),
                              style: TextStyle(
                                fontSize: 17,

                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                ref
                                    .read(stateProvider.notifier)
                                    .increment(cartModel.id);
                              },
                              icon: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: primaryColor,
                                ),
                                child: Icon(Icons.add, color: quaternaryColor),
                              ),
                            ),
                          ],
                        )
                      : Text("x${cartModel.quantity}" , style: TextStyle(color: Colors.red),),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
