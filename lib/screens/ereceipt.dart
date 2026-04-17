import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/data/shipping_type_data.dart';
import 'package:plant_app/models/order_model.dart';
import 'package:plant_app/repository/save_openDocuments.dart';
import 'package:plant_app/repository/simple_pdfapi.dart';
import 'package:plant_app/widgets/cart_paymentRow.dart';
import 'package:plant_app/widgets/footer.dart';
import 'package:plant_app/widgets/main_appbar.dart';
import 'package:plant_app/widgets/order_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EReceipt extends ConsumerStatefulWidget {
  const EReceipt({super.key});

  @override
  ConsumerState<EReceipt> createState() => _EReceiptState();
}

class _EReceiptState extends ConsumerState<EReceipt> {
  String formatOrderDate(DateTime date) {
    final datePart = DateFormat('MMM dd, yyyy').format(date);
    final timePart = DateFormat('hh:mm a').format(date);
    return "$datePart | $timePart";
  }

  @override
  Widget build(BuildContext context) {
    final orderAsync = ref.watch(getLastOrder);

    return Scaffold(
      appBar: mainAppBar('E-Receipt'),
      bottomNavigationBar: Footer(
        title: "Download E-Receipt",
        onPressed: () async {
          try {
            final OrderModel? userOrder = await ref.read(getLastOrder.future);
            if (userOrder == null) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('No recent order found.')),
              );
              return;
            }
            final supabase = Supabase.instance.client;
            final pdfFile = await SimplePdfApi.generateOrderPdf(
              order: userOrder,
              supabase: supabase,
              fileName: 'order_receipt${userOrder.id}.pdf',
            );
            await SaveAndOpenDocuments.openPdf(pdfFile);
          } catch (e, st) {
            print('Error creating/opening PDF: $e\n$st');
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Failed to create PDF: $e')));
          }
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: orderAsync.when(
            data: (data) {
              return EReceiptContent(data: data);
            },
            error: (error, stackTrace) {
              print(error);
              return Center(child: Text("Error to fetch your data $error"));
            },
            loading: () => Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class EReceiptContent extends StatelessWidget {
  final OrderModel? data;
  final bool isEReceipt;
  const EReceiptContent({
    super.key,
    required this.data,
    this.isEReceipt = true,
  });

  String formatOrderDate(DateTime date) {
    final datePart = DateFormat('MMM dd, yyyy').format(date);
    final timePart = DateFormat('hh:mm a').format(date);
    return "$datePart | $timePart";
  }

  @override
  Widget build(BuildContext context) {
    final orderDate = data!.orderPost;
    final formatted = orderDate != null ? formatOrderDate(orderDate) : "-";
    final charge = shippingType
        .where((test) => test.name == data!.shippingMethod)
        .toList();
    double chargePrice = charge.first.price.toDouble();
    double tax = data!.items!.fold<double>(
                0.0,
                (sum, e) => sum + (e.price * 0.05 * e.quantity),
              );
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        isEReceipt
            ? BarcodeWidget(
                barcode: Barcode.code128(),
                data: data!.id!,
                errorBuilder: (context, error) => Center(child: Text(error)),
                height: 80,
                textPadding: 10,
              )
            : SizedBox(),
        Expanded(
          child: ListView.builder(
            itemCount: data!.items!.length,
            itemBuilder: (context, index) {
              final orderItem = data!.items![index];
          
              return Padding(
                padding: const EdgeInsets.all(15.0),

                child: OrderItem(orderItemsModel: orderItem),
              );
            },
          ),
        ),
        Column(
          children: [
            CartPaymentRow(
              title: "Order Date",
              isPrice: false,
              subtitle: formatted,
            ),
            CartPaymentRow(title: "Promo Code", isPrice: false, subtitle: "-"),
            CartPaymentRow(
              title: "Delivery Type",
              isPrice: false,
              subtitle: data!.shippingMethod,
            ),
            isEReceipt ? SizedBox() : Divider(),
            isEReceipt
                ? SizedBox()
                : CartPaymentRow(
                    title: "Amount",
                    isPrice: true,
                    price: data!.total,
                    subtitle: data!.total.toString(),
                  ),
            isEReceipt
                ? SizedBox()
                : CartPaymentRow(
                    title: "Delivery Charge",
                    isPrice: true,
                    price: chargePrice,
                    subtitle: chargePrice.toString(),
                  ),
            isEReceipt
                ? SizedBox()
                : CartPaymentRow(
                    title: "Tax",
                    isPrice: true,
                    price: tax,
                    subtitle:tax.toStringAsFixed(2),
                  ),
          ],
        ),
      ],
    );
  }
}
