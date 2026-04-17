import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/custom_button.dart';
import 'package:readmore/readmore.dart';

class PlantDetails extends ConsumerStatefulWidget {
  final PlantModel plantModel;
  const PlantDetails({super.key, required this.plantModel});

  @override
  ConsumerState<PlantDetails> createState() => _PlantDetailsState();
}

class _PlantDetailsState extends ConsumerState<PlantDetails> {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    final wishlistItem = ref.watch(wishlistProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(26, 254, 254, 254),

        title: Text('Plant Details', style: TextStyle(color: quaternaryColor)),
        centerTitle: true,
        actions: [
          IconButtonAppBar(
            icon:  HeroIcons.heart,
            isFav:    wishlistItem.contains(widget.plantModel) ,
            onPressed: () {
              ref
                  .read(wishlistProvider.notifier)
                  .addToWishlist(widget.plantModel);
              isFirst:
              wishlistItem.contains(widget.plantModel) ? false : true;
            },
          ),
          IconButtonAppBar(icon: HeroIcons.share, onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          Positioned(
            top: 0,

            left: 0,
            right: 0,
            bottom: height(context) / 7,
            child: SizedBox(
              height: height(context) ,
              width: width(context),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: width(context),
                      height: height(context) / 2,
                      child: Image.network(
                        fit: BoxFit.cover,
                        widget.plantModel.image ?? "",
                      ),
                    ),
                    Padding(
                      padding: EdgeInsetsGeometry.all(20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.plantModel.category?.name ??
                                    'Unknown category',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: placeholdColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Row(
                                children: [
                                  Icon(Icons.star, color: starColor),
                                  Text(
                                    "5.7",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: placeholdColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Text(
                            widget.plantModel.name,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Seller",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              SellerContact(plantModel: widget.plantModel),
                            ],
                          ),
                          title("Plant Detail"),
                          ReadMoreText(
                            widget.plantModel.description,
                            trimMode: TrimMode.Line,
                            trimLines: 3,
                            trimLength: 240,

                            preDataTextStyle: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                            style: const TextStyle(
                              fontSize: 14,
                              color: placeholdColor,
                              fontWeight: FontWeight.w500,
                            ),
                            colorClickableText: primaryColor,
                            moreStyle: TextStyle(
                              color: primaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: primaryColor,
                            ),
                            trimCollapsedText: 'Read more',
                            trimExpandedText: ' show less',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: Container(
              height: height(context)  / 7,
              width: width(context),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: placeholdColor,
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Price",
                        style: TextStyle(
                          fontSize: 17,
                          color: placeholdColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '\$ ${widget.plantModel.price}',
                        style: TextStyle(
                          fontSize: 17,

                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 20),
                  CustomButton(
                    onPressed: () {
                      ref
                          .read(stateProvider.notifier)
                          .addToCart(widget.plantModel);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SellerContact extends StatelessWidget {
  const SellerContact({
    super.key,
    required this.plantModel,
  });

  final PlantModel plantModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 40,
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          plantModel.seller!.image ??
              'https://nbzztwylzzscrvcywbto.supabase.co/storage/v1/object/sign/avatars/sara.jpg?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9lZTU3MzM0Zi00NDBjLTRjMDktYjllMS01ZmU2ZGM2ZjJhM2UiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJhdmF0YXJzL3NhcmEuanBnIiwiaWF0IjoxNzYwNDg5OTcwLCJleHAiOjE3OTIwMjU5NzB9.L13OkZaK-T0EoH8ZaXm98hQEZcVP70ZRwY-ts9ahNQ4',
        ),
      ),
      title: Text(plantModel.seller!.name),
      subtitle: Text(
        plantModel.seller!.position,
      ),
      trailing: Wrap(
        children: [
          IconButtonAppBar(
            onPressed: () {},
            icon:
                HeroIcons.chatBubbleBottomCenterText,
            isIconAppBar: false,
          ),
          IconButtonAppBar(
            onPressed: () {},
            icon: HeroIcons.phone,
            isIconAppBar: false,
          ),
        ],
      ),
    );
  }
}
