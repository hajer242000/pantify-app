import 'package:flutter/material.dart';

class CartPaymentRow extends StatelessWidget {
  final String title;
  final double price;
  final Color? textColor;
  final bool isPrice;
  final String? subtitle;
  const CartPaymentRow({
    super.key,
    required this.title,
     this.price = 0.0,
    this.textColor,
    this.isPrice = true,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: textColor ?? Colors.grey,
            fontWeight: FontWeight.w400,
          ),
        ),
        Text(
          isPrice ? "\$${price.toStringAsFixed(2)}" : subtitle!,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
