import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/plant_details.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/custom_button.dart';
import 'package:plant_app/widgets/plant_grid.dart';
import 'package:readmore/readmore.dart';

class PlantSeller extends ConsumerStatefulWidget {
  final String sellerId;
  const PlantSeller({super.key, required this.sellerId});

  @override
  ConsumerState<PlantSeller> createState() => _PlantSellerState();
}

class _PlantSellerState extends ConsumerState<PlantSeller> {
  List<Map<String, dynamic>> sections = [
    {'icon': HeroIcons.user, 'number': 7500, 'title': 'Customer'},
    {'icon': HeroIcons.cube, 'number': 250, 'title': 'Plants'},
    {'icon': HeroIcons.star, 'number': 4.9, 'title': 'Rating'},
    {'icon': HeroIcons.chatBubbleOvalLeft, 'number': 4956, 'title': 'Review'},
  ];
  bool isFirst = true;

  final List<Map<String, String?>> workingHours = [
    {'day': 'Monday', 'openTime': '09:00 AM', 'closeTime': '06:00 PM'},
    {'day': 'Tuesday', 'openTime': '09:00 AM', 'closeTime': '06:00 PM'},
    {'day': 'Wednesday', 'openTime': '09:00 AM', 'closeTime': '06:00 PM'},
    {'day': 'Thursday', 'openTime': '09:00 AM', 'closeTime': '06:00 PM'},
    {'day': 'Friday', 'openTime': 'Closed', 'closeTime': 'Closed'},
    {'day': 'Saturday', 'openTime': '10:00 AM', 'closeTime': '04:00 PM'},
    {'day': 'Sunday', 'openTime': 'Closed', 'closeTime': 'Closed'},
  ];

  @override
  Widget build(BuildContext context) {
    final plantSellers = ref.watch(getSellerPlants(widget.sellerId));
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(26, 254, 254, 254),

          title: Text('Plant Seller'),
          centerTitle: true,
          actions: [IconButtonAppBar(icon: HeroIcons.share, onPressed: () {})],
        ),
        body: plantSellers.when(
          data: (data) {
            print(data.first.seller!.farmName);
            print(data.first.seller!.name);
            return CustomScrollView(
              slivers: [
                SliverAppBar(
                  toolbarHeight: 100,

                  leadingWidth: 0,
                  leading: SizedBox(),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: placeholdColor,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(data.first.seller!.image),
                              ),
                            ),
                          ),
                          Positioned(
                            right: -5,
                            bottom: 7,
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: quaternaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: HeroIcon(
                                HeroIcons.checkBadge,
                                color: primaryColor,
                                style: HeroIconStyle.solid,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data.first.seller!.name,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              data.first.seller!.farmName,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                HeroIcon(
                                  HeroIcons.mapPin,
                                  color: primaryColor,
                                  style: HeroIconStyle.solid,
                                ),
                                Text(
                                  data.first.seller!.location,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineSmall,
                                ),
                                HeroIcon(
                                  HeroIcons.map,
                                  color: primaryColor,
                                  style: HeroIconStyle.solid,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider(
                //       color: const Color.fromARGB(255, 220, 218, 218),
                //     ),
                SliverAppBar(
                  toolbarHeight: 140,
                  leadingWidth: 0,
                  leading: SizedBox(),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: sections
                        .map(
                          (toElement) => Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(
                                    255,
                                    240,
                                    239,
                                    239,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: HeroIcon(
                                  toElement['icon'],
                                  color: primaryColor,
                                  style: HeroIconStyle.solid,
                                ),
                              ),
                              Text(
                                "${toElement['number']}+",
                                style: TextStyle(
                                  color: primaryColor,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                toElement['title'],
                                style: TextStyle(
                                  fontSize: 14,
                                  color: placeholdColor,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
                SliverFillRemaining(
                  child: Column(
                    children: [
                      TabBar(
                        indicatorWeight: 6,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(color: primaryColor, width: 6),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        splashBorderRadius: BorderRadius.circular(25),
                        dividerColor: Colors.grey,
                        indicatorPadding: EdgeInsetsGeometry.symmetric(
                          horizontal: 10,
                        ),
                        unselectedLabelStyle: TextStyle(
                          color: tertiaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        labelStyle: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                        tabs: [
                          Tab(text: "Plants"),
                          Tab(text: 'About'),
                          Tab(text: "Gallery"),
                          Tab(text: 'Review'),
                        ],
                      ),

                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TabBarView(
                            children: [
                              sellerPlants(data),
                              sellerAbout(data),
                              sellerGallery(data),
                              SizedBox(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error')),
          loading: () => Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Column sellerGallery(List<PlantModel> data) {
    return Column(
                              children: [
                                PlantsSellerTitle(
                                  title: 'Gallery',
                                  length: data.length,
                                ),
                                SizedBox(height: 10,) ,
                                Expanded(
                                  child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          mainAxisExtent: 250,
                                          mainAxisSpacing: 15,
                                          crossAxisSpacing: 15,
                                        ),
                                    itemCount: data.length,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        height: 150,
                                        width: 250,
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                            186,
                                            234,
                                            233,
                                            233,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            15,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              data[index].image ?? "",
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
  }

  Column sellerAbout(List<PlantModel> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SellerTitle(title: 'About Plant Seller'),
        SizedBox(height: 7),
        ReadMoreText(
          data.first.seller!.about,
          trimMode: TrimMode.Line,
          trimLines: 3,
          trimLength: 240,
          textAlign: TextAlign.start,
          preDataTextStyle: const TextStyle(fontWeight: FontWeight.w500),
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
        SizedBox(height: 20),
        SellerTitle(title: 'Plant Seller Contact'),
        SellerContact(plantModel: data.first),
        SizedBox(height: 20),
        SellerTitle(title: 'Working Hours'),
        Divider(color: const Color.fromARGB(255, 231, 229, 229)),
        Expanded(
          child: ListView.builder(
            itemCount: workingHours.length,
            itemBuilder: (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    workingHours[index]['day'].toString(),
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '${workingHours[index]['openTime']} - ${workingHours[index]['closeTime']}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Column sellerPlants(List<PlantModel> data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlantsSellerTitle(title: 'Plants', length: data.length),
        Expanded(
          child: PlantGrid(
            isFirst: isFirst,
isInHomeScreen: false,
            onTapFav: () => setState(() => isFirst = !isFirst),
            length: data.length,
            plantModel: data,
          ),
        ),
      ],
    );
  }
}

class PlantsSellerTitle extends StatelessWidget {
  final String title;
  final int length;
  const PlantsSellerTitle({
    super.key,
    required this.title,
    required this.length,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        RichText(
          text: TextSpan(
            text: title,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
            children: [
              TextSpan(
                text: '\t($length)',
                style: TextStyle(color: primaryColor),
              ),
            ],
          ),
        ),
        Text(
          'View All',
          style: TextStyle(
            color: primaryColor,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class SellerTitle extends StatelessWidget {
  final String title;
  const SellerTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 14,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
