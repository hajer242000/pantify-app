import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/screens/orders.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/cart_paymentRow.dart';

import 'package:plant_app/widgets/footer.dart';
import 'package:plant_app/widgets/main_appbar.dart';

class TrackOrder extends ConsumerStatefulWidget {
  final String orderID;
  const TrackOrder({super.key, required this.orderID});

  @override
  ConsumerState<TrackOrder> createState() => _TrackOrderState();
}

class _TrackOrderState extends ConsumerState<TrackOrder> {
  Color stepperColor = primaryColor;
  late String orderID;
  @override
  void initState() {
    orderID = widget.orderID;
    super.initState();
  }

  String statusMessageEn(String track) {
    switch (track) {
      case 'placed':
        return 'Your order has been placed.';
      case 'progress':
        return 'We’re preparing your order.';
      case 'shipped':
        return 'Your order is on the way.';
      default:
        return 'Your order has been delivered.';
    }
  }

  int getStepperIndex(String track) {
    switch (track) {
      case 'placed':
        return 0;
      case 'progress':
        return 1;
      case 'shipped':
        return 2;
      default:
        return 3;
    }
  }

  List<Step> buildSteps(BuildContext context, dynamic data) {
    final stepsInfo = [
      ("Order Placed", HeroIcons.clipboardDocumentCheck),
      ("In Progress", HeroIcons.cube),
      ("Shipped", HeroIcons.truck),
      ("Delivered", HeroIcons.checkBadge),
    ];

    return List.generate(stepsInfo.length, (index) {
      final (title, icon) = stepsInfo[index];
      return _buildStep(
        context: context,
        title: title,
        icon: icon,
        date: "19 Dec 2025",
        isActive: getStepperIndex(data.track!) >= index,
        isComplete:
            index == stepsInfo.length - 1 && getStepperIndex(data.track!) == 3,
      );
    });
  }

  Step _buildStep({
    required BuildContext context,
    required String title,
    required HeroIcons icon,
    required String date,
    required bool isActive,
    bool isComplete = false,
  }) {
    return Step(
      isActive: isActive,
      state: isComplete ? StepState.complete : StepState.indexed,
      title: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(title, style: Theme.of(context).textTheme.bodySmall),
        subtitle: Text(
          date,
          style: const TextStyle(color: placeholdColor, fontSize: 11),
        ),
        trailing: HeroIcon(
          icon,
          color: isActive ? primaryColor : placeholdColor,
        ),
      ),
      content: const SizedBox(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(getOrderById(orderID));
    print(widget.orderID);
    print(orderID);

    return Scaffold(
      appBar: mainAppBar('Track Order'),
      bottomNavigationBar: Footer(title: "Cancel Order", onPressed: () {}),
      body: orderAsync.when(
        data: (data) {
          final plants = data.items;
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: CustomScrollView(
              slivers: [
                SliverList.separated(
                  itemBuilder: (context, index) {
                    final plant_ = data.items![index];
                    final plantInfo = ref.watch(getPlantById(plant_.plantID));

                    return plantInfo.when(
                      data: (plant) {
                        return OrderCard(
                          isTrack: true,
                          orderItem: plant_,
                          order: data,
                          buttonTitle: "no button",
                          plant: plant,
                          onPressed: () {},
                        );
                      },
                      error: (error, stackTrace) =>
                          Center(child: Text("Error")),
                      loading: () => Center(child: CircularProgressIndicator()),
                    );
                  },
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey.shade500, height: 30),
                  itemCount: plants!.length,
                ),
                SliverFillRemaining(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Divider(
                          color: const Color.fromARGB(255, 220, 218, 218),
                        ),
                        SizedBox(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              title("Order Details"),
                              CartPaymentRow(
                                title: "Order Id",
                                isPrice: false,

                                subtitle: widget.orderID,
                              ),
                              CartPaymentRow(
                                title: "Expected Delivery Date",
                                isPrice: false,

                                subtitle: "19 Dec 2025",
                              ),
                              CartPaymentRow(
                                title: "Total",
                                isPrice: true,
                                price: data.total,
                                subtitle: "19 Dec 2025",
                              ),
                              Divider(
                                color: const Color.fromARGB(255, 220, 218, 218),
                              ),
                            ],
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            title("Order Status"),

                            Stepper(
                              connectorThickness: 4,
                              currentStep: getStepperIndex(data.track!),
                              physics: NeverScrollableScrollPhysics(),
                              onStepTapped: null,
                              stepIconBuilder: (stepIndex, stepState) {
                                return Container(
                                  color: Colors.white,
                                  child: Icon(
                                    Icons.check_circle,
                                    color:
                                        stepIndex <=
                                            getStepperIndex(data.track!)
                                        ? primaryColor
                                        : placeholdColor,
                                  ),
                                );
                              },
                              connectorColor: WidgetStateProperty.all(
                                primaryColor,
                              ),
                              controlsBuilder: (context, details) => SizedBox(
                                width: width(context),

                                child: Text(
                                  "${statusMessageEn(data.track!)} \u{1F60A}",
                                  style: TextStyle(color: primaryColor),
                                ),
                              ),

                              steps: buildSteps(context, data),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text("Error")),
        loading: () => Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
