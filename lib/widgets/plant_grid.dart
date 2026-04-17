import 'package:flutter/material.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/plant_details.dart';
import 'package:plant_app/widgets/grid_card.dart';

class PlantGrid extends StatefulWidget {
  final bool isFirst;
  final bool isInHomeScreen;
  final void Function()? onTapFav;
  final int length;
  final List<PlantModel> plantModel;
  const PlantGrid({
    super.key,
    required this.isFirst,
    required this.onTapFav,
    required this.length,
    required this.plantModel,
    this.isInHomeScreen = true
  });

  @override
  State<PlantGrid> createState() => _PlantGridState();
}

class _PlantGridState extends State<PlantGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.all(15),
      physics:widget.isInHomeScreen? const NeverScrollableScrollPhysics():const AlwaysScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 250,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
      ),
      itemCount: widget.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            print(widget.plantModel[index].category?.id);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    PlantDetails(plantModel: widget.plantModel[index]),
              ),
            );
          },
          child: GridCard(
            isFirst: widget.isFirst,
            onTap: widget.onTapFav,
            plantModel: widget.plantModel[index],
            isWishIt: index,
          ),
        );
      },
    );
  }
}
