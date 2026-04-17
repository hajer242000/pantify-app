import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/models/orderitems_model.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/track_order.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/custom_button.dart';

class Orders extends ConsumerStatefulWidget {
  const Orders({super.key});

  @override
  ConsumerState<Orders> createState() => _OrdersState();
}

class _OrdersState extends ConsumerState<Orders> {
  String defaultTab = 'active';
  String buttonTitle = 'Track Order';
  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(getTabOrder(defaultTab.toLowerCase()));

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My Orders"),
          bottom: TabBar(
            indicatorWeight: 6,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: primaryColor, width: 6),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25),
                topRight: Radius.circular(25),
              ),
            ),
            splashBorderRadius: BorderRadius.circular(25),
            dividerColor: Colors.grey,
            indicatorPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
            unselectedLabelStyle: TextStyle(
              color: tertiaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
            labelStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: primaryColor,
            ),
            onTap: (value) {
              setState(() {
                switch (value) {
                  case 0:
                    defaultTab = 'active';
                    buttonTitle = 'Track Order';

                    break;
                  case 1:
                    defaultTab = 'completed';
                    buttonTitle = 'Leave Review';
                    break;
                  default:
                    defaultTab = 'cancelled';
                    buttonTitle = 'Re-Order';
                }
              });
            },
            tabs: const <Widget>[
              Tab(child: Text("Active")),
              Tab(child: Text("Completed")),
              Tab(child: Text("Cancelled")),
            ],
          ),
        ),
        body: TabBarView(
          children: List.filled(
            3,
            orders.when(
              data: (data) {
                if (data.isEmpty) {
                  return const Center(child: Text('No orders'));
                }
                return ListView.separated(
                  padding: EdgeInsets.all(15),
                  itemBuilder: (context, index) {
                    final order = data[index];
                    final orderItem = order.items!.first;
                    if (orderItem == null) {
                      return const SizedBox.shrink();
                    }
                    final plantInfo = ref.watch(
                      getPlantById(orderItem.plantID),
                    );

                    return plantInfo.when(
                      data: (plant) {
                        return OrderCard(
                          orderItem: orderItem,
                          order: order,
                          buttonTitle: buttonTitle,
                          plant: plant,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TrackOrder(orderID: order.id!),
                              ),
                            );
                          },
                        );
                      },
                      error: (error, stackTrace) =>
                          Center(child: Text("Error")),
                      loading: () => Center(child: CircularProgressIndicator()),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade500, height: 30),
                  itemCount: data.length,
                );
              },
              error: (error, stackTrace) => Center(child: Text("Error")),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({
    super.key,
    required this.orderItem,
    required this.order,
    required this.buttonTitle,
    required this.plant,
    this.isTrack = false,
    required this.onPressed,
  });

  final OrderItemsModel orderItem;
  final OrderModel order;
  final PlantModel plant;
  final String buttonTitle;
  final bool isTrack;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(15),
          child: Image.network(
            plant.image,
            fit: BoxFit.cover,
            height: 100,
            width: 100,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.broken_image_outlined,
                size: 60,
                color: Colors.grey,
              );
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(plant.name, style: Theme.of(context).textTheme.bodySmall),
              Text(
                '${plant.category!.name} | ${orderItem.quantity} x \$${orderItem.price}',
                style: TextStyle(color: placeholdColor, fontSize: 11),
              ),
              isTrack
                  ? SizedBox()
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.total.toString(),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomButton(
                          onPressed: onPressed,
                          isCustomized: true,
                          height: 1,
                          width: 11,
                          title: buttonTitle,
                          isDetailButton: false,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
