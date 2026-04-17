import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/orderitems_model.dart';
import 'package:plant_app/theme/theme.dart';

class OrderItem extends ConsumerWidget {
  final OrderItemsModel orderItemsModel;
  const OrderItem({super.key, required this.orderItemsModel});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plant = ref.watch(getPlantById(orderItemsModel.plantID));
    return plant.when(
      data: (data) {
        return Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: placeholdColor,
                image: DecorationImage(
                  image: NetworkImage(data.image),
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
                  Text(data.name, style: TextStyle(fontSize: 15)),
                  Text(
                    data.category!.name,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '\$ ${data.price}',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "x${orderItemsModel.quantity}",
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
      error: (error, stackTrace) =>
          Center(child: Text("Can't loading plant Info")),
      loading: () => CircularProgressIndicator(),
    );
  }
}
