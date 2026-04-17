import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/screens/ereceipt.dart';
import 'package:plant_app/widgets/footer.dart';
import 'package:plant_app/widgets/main_appbar.dart';

class ViewOrder extends ConsumerWidget {
  const ViewOrder({super.key});

  @override
  Widget build(BuildContext context , WidgetRef ref) {
      final orderAsync = ref.watch(getLastOrder);
    return Scaffold(
      appBar: mainAppBar('Review Order'),
      bottomNavigationBar: Footer(
        title: "Continue",
        onPressed: () async {},
      ), body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: orderAsync.when(
            data: (data) {
              return EReceiptContent(data: data , isEReceipt: false,);
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
