import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/models/seller_model.dart';
import 'package:plant_app/screens/plant_seller.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/favorite_button.dart';

class SellersListView extends StatefulWidget {
  final bool isFirst;
  final void Function()? onTap;

  final List<SellerModel> sellers;
  const SellersListView({
    super.key,
    required this.isFirst,
    this.onTap,
    required this.sellers,

  });

  @override
  State<SellersListView> createState() => _SellersListViewState();
}

class _SellersListViewState extends State<SellersListView> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: widget.sellers.length,
      padding: EdgeInsets.all(15),
      itemBuilder: (context, index) {
        return SizedBox(
          height: 300,
          child: InkWell(
            onTap: () {
              print("object");
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlantSeller(sellerId: widget.sellers[index].id),
                          ),
                        );
            },
            child: SellerCard(
              sellerModel: widget.sellers[index],
              isFirst: widget.isFirst,
              onTap: widget.onTap,
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(height: 10);
      },
    );
  }
}

class SellerCard extends StatelessWidget {
  const SellerCard({
    super.key,
    required this.sellerModel,
    required this.isFirst,
    required this.onTap,
    this.isInExplore = false,
  });

  final SellerModel sellerModel;
  final bool isFirst;
  final void Function()? onTap;
  final bool isInExplore;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: isInExplore ? 320 : 0,
      margin: isInExplore
          ? EdgeInsets.symmetric(horizontal: 5)
          : EdgeInsets.zero,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 180,
                width: width(context),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(sellerModel.farmImage),
                  ),
                ),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: quaternaryColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.star, color: yelloColor),
                          Text(
                            '4.8',
                            style: TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    FavoriteButton(isFirst: !isFirst, onTap: onTap),
                  ],
                ),
              ),
              Text(
                sellerModel.farmName,
                style: TextTheme.of(context).titleLarge,
              ),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        HeroIcon(
                          HeroIcons.user,
                          style: HeroIconStyle.solid,
                          color: primaryColor,
                        ),
                        Expanded(
                          child: Text(
                            sellerModel.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        HeroIcon(
                          HeroIcons.mapPin,
                          style: HeroIconStyle.solid,
                          color: primaryColor,
                        ),
                        Expanded(
                          child: Text(
                            sellerModel.location,
                            overflow: TextOverflow.ellipsis,

                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Text(
                "\$10.000 - 25.00",
                style: TextStyle(
                  color: primaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
