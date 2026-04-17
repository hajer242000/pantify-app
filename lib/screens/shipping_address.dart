import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/address_model.dart';
import 'package:plant_app/statics_var.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/footer.dart';

class ShippingAddress extends ConsumerStatefulWidget {
  const ShippingAddress({super.key});

  @override
  ConsumerState<ShippingAddress> createState() => _ShippingAddressState();
}

class _ShippingAddressState extends ConsumerState<ShippingAddress> {
  int? selected;
  AddressModel? selectedAddress;
  bool _didRegisterListener = false;

  @override
  Widget build(BuildContext context) {

    if (!_didRegisterListener) {
      _didRegisterListener = true;
      ref.listen(
        getAddress(supabase.auth.currentUser!.id),
        (previous, next) => next.whenData((addresses) {
         
          try {
            final defaultAddr =
                addresses.firstWhere((a) => a.isDefault == true);
            final idx = addresses.indexOf(defaultAddr);
            
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  selectedAddress = defaultAddr;
                  selected = idx;
                });
              }
            });
          } catch (e) {
            // no default address found — keep selected as-is
          }
        }),
      );
    }


    final myAddress = ref.watch(getAddress(supabase.auth.currentUser!.id));

    return Scaffold(
      appBar: AppBar(title: const Text("Shipping Address")),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 150,
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: myAddress.when(
                    data: (data) {
                      if (data.isEmpty) {
                        return const Center(child: Text("No address added yet"));
                      }

                      return ListView.separated(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final address = data[index];

                          return RadioListTile<int>(
                            value: index,
                            groupValue: selected,
                            selected: selected == index,
                            onChanged: (value) {
                              setState(() {
                                selected = value;
                                selectedAddress = address;
                              });
                            },
                            activeColor: primaryColor,
                            title: Text(address.buildingType),
                            subtitle: Text(address.fullAddress),
                            secondary: const Icon(Icons.location_pin),
                            controlAffinity: ListTileControlAffinity.trailing,
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: Theme.of(context).dividerColor);
                        },
                      );
                    },
                    error: (error, stackTrace) =>
                        Center(child: Text(error.toString())),
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, '/addAddress');
                      },
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          radius: const Radius.circular(10),
                          padding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                          color: primaryColor,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: primaryColor),
                            const SizedBox(width: 8),
                            Text(
                              "Add A new Shipping Address",
                              style: TextStyle(color: primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Footer(
            title: "Apply",
            onPressed: () {
              if (selectedAddress == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select an address')),
                );
                return;
              }
              Navigator.pop(context, selectedAddress);
            },
          ),
        ],
      ),
    );
  }
}
