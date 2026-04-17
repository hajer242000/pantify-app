import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/data/shipping_type_data.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/cart_item.dart';
import 'package:plant_app/widgets/cart_paymentRow.dart';
import 'package:plant_app/widgets/custom_button.dart';
import 'package:plant_app/widgets/expand_up_tile.dart';
import 'package:plant_app/models/cart_model.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  ConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  bool _allowSwipe = true;
  bool _sheetOpen = false;

  List<CartModel> _items = [];

  @override
  void initState() {
    super.initState();

    _items = List<CartModel>.from(ref.read(stateProvider));
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(stateTotalProvider(shippingType[0].price));
   final subtotal = ref.watch(stateSubTotalProvider);
     final tax = ref.watch(stateTaxProvider);
    ref.listen<List<CartModel>>(stateProvider, (previous, current) {
      final prev = previous ?? const <CartModel>[];
      final next = current;

      if (next.length == prev.length + 1) {
        final inserted = next.firstWhere((e) => !prev.any((p) => p.id == e.id));
        final insertIndex = next.indexWhere((e) => e.id == inserted.id);

        setState(() {
          _items = List<CartModel>.from(next);
        });
        _listKey.currentState?.insertItem(insertIndex);
        return;
      }

      if (next.length == prev.length - 1) {
    
        final removed = prev.firstWhere((e) => !next.any((n) => n.id == e.id));
        final removeIndex = prev.indexWhere((e) => e.id == removed.id);

  
        _listKey.currentState?.removeItem(
          removeIndex,
          (context, animation) => SizeTransition(
            sizeFactor: animation,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: CartItem(cartModel: removed),
            ),
          ),
        );

    
        setState(() {
          _items = List<CartModel>.from(next);
        });
        return;
      }

    
      setState(() {
        _items = List<CartModel>.from(next);
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Cart"),
        actions: [
          IconButton(
            onPressed: () => ref.read(stateProvider.notifier).clear(),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: Text("Empty"))
          : Stack(
              children: [
                AnimatedList(
                  key: _listKey,
                  initialItemCount: _items.length,
                  padding: const EdgeInsets.only(bottom: 220),
                  itemBuilder: (context, index, animation) {
                    if (index < 0 || index >= _items.length) {
                      return const SizedBox.shrink();
                    }
                    final item = _items[index];
                    return SizeTransition(
                      sizeFactor: animation,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: _dismissibleRow(context, item),
                      ),
                    );
                  },
                ),

                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Material(
                    elevation: 10,
                    color: Colors.white,
                    child: ExpandUpTile(
                      title: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CustomButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/checkout'),
                            isDetailButton: false,
                            title: "Proceed to Checkout",
                          ),
                        ],
                      ),
                      subtitle: CartPaymentRow(
                       title : "Total Cost",
                       price: double.parse(total.toStringAsFixed(2)),
                      ),
                      content: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CartPaymentRow(title : "Sub-Total",price:  double.parse(subtotal.toStringAsFixed(2))),
                          CartPaymentRow(title :"Delivery Fee",price:  shippingType[0].price.toDouble()),
                          CartPaymentRow(title :"Tax",price: double.parse( tax.toStringAsFixed(2))),
                         // _cartPaymentRow("discounted", 92.00),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _dismissibleRow(BuildContext context, CartModel item) {
    return Dismissible(
      key: ValueKey(item.id),
      direction: _allowSwipe
          ? DismissDirection.endToStart
          : DismissDirection.none,
      background: const Card(
        color: Color(0xFFF2BEC1),
        child: Align(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete, color: Colors.red, size: 70),
        ),
      ),
      confirmDismiss: (_) async => false,
      onUpdate: (details) async {
        if (!_sheetOpen && details.progress > 0.20) {
          setState(() {
            _allowSwipe = false;
            _sheetOpen = true;
          });

          final bool? confirm = await showModalBottomSheet<bool>(
            barrierColor: const Color.fromARGB(55, 0, 0, 0),
            backgroundColor: Colors.white,
            context: context,
            builder: (context) {
              return Container(
                width: width(context),
                height: height(context)/ 2.5,
                decoration: BoxDecoration(
                  color: quaternaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Remove from cart?",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(color: Color(0xFFE2DDDD)),
                      CartItem(isInCart: false, cartModel: item),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              isDetailButton: false,
                              isPrimaryBackground: false,
                              title: "Cancel",
                              onPressed: () => Navigator.pop(context, false),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomButton(
                              isDetailButton: false,
                              isPrimaryBackground: true,
                              title: "Yes, Remove",
                              onPressed: () => Navigator.pop(context, true),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );

          if (!mounted) return;

          if (confirm == true) {
            ref.read(stateProvider.notifier).remove(item.id);
          }

          setState(() {
            _allowSwipe = true;
            _sheetOpen = false;
          });
        }
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: CartItem(cartModel: item),
      ),
    );
  }


}
