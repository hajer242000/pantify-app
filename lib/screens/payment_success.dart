import 'package:flutter/material.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/custom_button.dart';
import 'package:plant_app/widgets/main_appbar.dart';

class PaymentSuccess extends StatefulWidget {
  const PaymentSuccess({super.key});

  @override
  State<PaymentSuccess> createState() => _PaymentSuccessState();
}

class _PaymentSuccessState extends State<PaymentSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar('Payment'), 
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(66, 164, 163, 163),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          child: BottomAppBar(
            elevation: 10,
            height: 150,

            shadowColor: Colors.black,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 10,
              children: [
                CustomButton(
                  onPressed: () {     Navigator.pushNamed(context, '/viewOrder');},
                  isDetailButton: false,
                  isPrimaryBackground: true,
                  title: 'View Order',
                ),
                CustomButton(
                  onPressed: () { Navigator.pushNamed(context,  '/eReceipt');},
                  isDetailButton: false,
                  isPrimaryBackground: false,
                  onlyText: true,
                  title: 'View E-Receipt',
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 200, color: primaryColor, fill: 1),
              Text(
                "Payment Successful!",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "Thank you for your purchase",
                style: TextStyle(color: placeholdColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
