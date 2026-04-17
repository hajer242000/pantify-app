import 'package:flutter/material.dart';
import 'package:plant_app/data/shipping_type_data.dart';
import 'package:plant_app/models/shipping_model.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/footer.dart';

class ShippingType extends StatefulWidget {
  const ShippingType({super.key});

  @override
  State<ShippingType> createState() => _ShippingTypeState();
}

class _ShippingTypeState extends State<ShippingType> {
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Choose Shipping")),
      body: Stack(
        children: [
          Positioned.fill(
            bottom: 150,
            child: Column(
              children: [
                Flexible(
                  flex: 3,
                  child: ListView.separated(
                    itemCount: shippingType.length,

                    itemBuilder: (context, index) {
                      final type = shippingType[index];
                      return RadioListTile(
                        value: index,
                        groupValue: selected,
                        selected: selected == index,
                        onChanged: (value) {
                          setState(() {
                            selected = index;
                          });
                        },
                        activeColor: primaryColor,

                        title: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(type.name),
                          trailing: Text(
                            "\$${type.price}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          subtitle: Text(type.arrival),
                          leading: Icon(Icons.local_shipping),
                        ),

                        controlAffinity: ListTileControlAffinity.trailing,
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return Divider(color: Theme.of(context).dividerColor);
                    },
                  ),
                ),
              ],
            ),
          ),
          Footer(
            title: "Apply",
            onPressed: () {
              Navigator.pop(context , shippingType[selected]);
            },
          ),
        ],
      ),
    );
  }
}
