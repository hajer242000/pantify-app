import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/screens/plant_details.dart';

import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';

import 'package:badges/badges.dart' as badges;
import 'package:plant_app/widgets/plant_grid.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int tappedIndex = 0;
  int dotIndex = 0;
  bool isFirst = true;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  String categoryId = '03b4bfca-8b50-4129-b966-6534f0dad532';
  List<PlantModel> _filteredOptions = [];
  TextEditingController textEditingControllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final plantCategory = ref.watch(categoryProvider);

    final plants = ref.watch(plantsByCategoryProvider(categoryId));
    final allPlants = ref.watch(getAllPlants);
    return Column(
      children: [
        Container(
          height: 250,
          width: width(context),
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            color: const Color.fromARGB(124, 250, 250, 250),
                          ),
                        ),
                        Row(
                          children: [
                            HeroIcon(
                              HeroIcons.mapPin,
                              style: HeroIconStyle.solid,
                              color: yelloColor,
                            ),
                            Text(
                              'New York , USA',
                              style: TextStyle(
                                color: quaternaryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            HeroIcon(HeroIcons.chevronDown, color: yelloColor),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _icon(
                          HeroIcons.shoppingCart,
                          true,
                          ref.watch(stateProvider).length,

                          '/cart',
                        ),
                        _icon(HeroIcons.bell, false, 0, ''),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: allPlants.when(
                        data: (data) {
                          return TextField(
                            controller: textEditingControllerSearch,
                            onChanged: (value) {
                              setState(() {
                                _filteredOptions = data
                                    .where(
                                      (test) => test.name
                                          .toLowerCase()
                                          .startsWith(value.toLowerCase()),
                                    )
                                    .toList();
                                textEditingControllerSearch.text.isEmpty
                                    ? _filteredOptions.clear()
                                    : null;
                              });
                            },
                            style: TextStyle(fontSize: 16),

                            decoration: InputDecoration(
                              hintText: "Search Plant ",
                              hintStyle: TextStyle(
                                color: placeholdColor,
                                fontSize: 15,
                              ),

                              prefixIcon: HeroIcon(HeroIcons.magnifyingGlass),
                              prefixIconColor: primaryColor,
                              suffixIcon: HeroIcon(HeroIcons.qrCode),
                              suffixIconColor: primaryColor,
                              fillColor: quaternaryColor,
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 20,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide(color: quaternaryColor),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          );
                        },
                        error: (error, stackTrace) =>
                            Center(child: Text(error.toString())),
                        loading: () =>
                            Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Container(
                        padding: EdgeInsets.all(13),

                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color.fromARGB(129, 241, 241, 241),
                        ),
                        child: HeroIcon(
                          HeroIcons.adjustmentsHorizontal,
                          style: HeroIconStyle.solid,
                          color: quaternaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        _filteredOptions.isNotEmpty
            ? Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _filteredOptions.length,
                  padding: EdgeInsetsGeometry.zero,
                  itemBuilder: (context, index) {
                    final suggestion = _filteredOptions[index];
                    return ListTile(
                      title: Text(suggestion.name),
                      onTap: () {
                        textEditingControllerSearch.text = suggestion.name;
                        setState(() => _filteredOptions = []);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlantDetails(plantModel: suggestion),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            : Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 25, left: 12, right: 12),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        header("Special For You"),
                        SizedBox(height: 10),
                        SizedBox(
                          height: 200,
                          child: PageView.builder(
                            itemCount: 5,
                            padEnds: false,
                            controller: _pageController,
                            onPageChanged: (value) {
                              setState(() {
                                dotIndex = value;
                              });
                            },
                            itemBuilder: (context, index) => Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 250,
                                  width: width(context) - 50,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage('images/pageview.png'),
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 250,
                                  width: width(context) - 50,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight,
                                      colors: [
                                        const Color.fromARGB(209, 35, 35, 35),
                                        const Color.fromARGB(
                                          155,
                                          188,
                                          188,
                                          188,
                                        ),
                                        const Color.fromARGB(35, 254, 255, 255),
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: quaternaryColor,
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          padding: EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 10,
                                          ),
                                          child: Text('Limited Time!'),
                                        ),
                                        Text(
                                          'Get Special Offer',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: quaternaryColor,
                                            fontSize: 25,
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Up To',
                                              style: TextStyle(
                                                color: quaternaryColor,
                                              ),
                                            ),
                                            Text(
                                              '40',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: quaternaryColor,
                                                fontSize: 50,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                'All Indictor Plants Available | T&C Applied',
                                                style: TextStyle(
                                                  color: quaternaryColor,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                vertical: 10,
                                                horizontal: 20,
                                              ),
                                              decoration: BoxDecoration(
                                                color: yelloColor,
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                              ),
                                              child: Text(
                                                'Claim',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            height: 50,
                            width: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: 5,
                              itemBuilder: (context, index) => Container(
                                height: 50,
                                width: 10,
                                margin: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: dotIndex == index
                                      ? primaryColor
                                      : tertiaryColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        header("Recommended For You"),
                        plantCategory.when(
                          data: (data) {
                            return SizedBox(
                              height: 70,
                              child: ListView.builder(
                                itemCount: data.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: InkWell(
                                    onTap: () => setState(() {
                                      tappedIndex = index;
                                      categoryId = data[index].id;
                                      print(categoryId);
                                    }),
                                    child: Chip(
                                      backgroundColor: tappedIndex == index
                                          ? primaryColor
                                          : quaternaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadiusGeometry.circular(20),
                                        side: BorderSide(
                                          color: tappedIndex == index
                                              ? quaternaryColor
                                              : tertiaryColor,
                                        ),
                                      ),
                                      label: Text(
                                        data[index].name,

                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: tappedIndex == index
                                              ? quaternaryColor
                                              : secondaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          error: (error, stackTrace) => Text("error"),
                          loading: () => CircularProgressIndicator(),
                        ),
                        plants.when(
                          data: (data) {
                            return PlantGrid(
                              isFirst: isFirst,
                             
                              onTapFav: () =>
                                  setState(() => isFirst = !isFirst),
                              length: data.length,
                              plantModel: data,
                            );
                          },
                          error: (error, stackTrace) => Text("error"),
                          loading: () => CircularProgressIndicator(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ],
    );
  }

  Row header(String title_) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        title(title_),
        Text('See All', style: TextStyle(color: primaryColor)),
      ],
    );
  }

  IconButton _icon(
    HeroIcons icon,
    bool isCartIcon,
    int cartLength,
    String routeName,
  ) {
    return IconButton(
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      icon: isCartIcon
          ? badges.Badge(
              badgeContent: Text(
                '$cartLength',
                style: TextStyle(color: Colors.white),
              ),
              child: Container(
                padding: EdgeInsets.all(10),

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color.fromARGB(129, 241, 241, 241),
                ),
                child: HeroIcon(
                  icon,
                  style: HeroIconStyle.solid,
                  color: quaternaryColor,
                ),
              ),
            )
          : Container(
              padding: EdgeInsets.all(10),

              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: const Color.fromARGB(129, 241, 241, 241),
              ),
              child: HeroIcon(
                icon,
                style: HeroIconStyle.solid,
                color: quaternaryColor,
              ),
            ),
    );
  }
}

Widget title(String title) {
  return Text(
    title,
    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
  );
}
