import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/plant_grid.dart';
import 'package:plant_app/widgets/sellers_list_view.dart';

class WishListScreen extends ConsumerStatefulWidget {
  const WishListScreen({super.key});

  @override
  ConsumerState<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends ConsumerState<WishListScreen> {
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    final wishlistItem = ref.watch(wishlistProvider);
    final wishlistSeller = ref.watch(wishlistSellersProvider);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("My WishList"),
          bottom: TabBar(
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
            indicatorPadding: EdgeInsetsGeometry.symmetric(horizontal: 10),
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
              Tab(text: 'Sellers'),
            ],
          ),
        ),
        body: TabBarView(
          physics: AlwaysScrollableScrollPhysics(),

          children: [
            wishlistItem.isEmpty
                ? Center(child: Text("Empty"))
                : SingleChildScrollView(
                    child: PlantGrid(
                      length: wishlistItem.length,
                      plantModel: wishlistItem,
                      isFirst: true,
                      onTapFav: () {},
                    ),
                  ),

            wishlistSeller.isEmpty
                ? Center(child: Text("Empty"))
                : Container(
                    color: const Color.fromARGB(186, 234, 233, 233),
                    child: SellersListView(
                      isFirst: isFirst,
                      onTap: () => setState(() => isFirst = !isFirst),
                      sellers: wishlistSeller,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
