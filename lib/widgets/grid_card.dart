import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/plant_model.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/widgets/favorite_button.dart';

class GridCard extends ConsumerStatefulWidget {
  final bool isFirst;
  final void Function()? onTapFav;
  final PlantModel plantModel;
  final void Function()? onTap;
  final int isWishIt;
  const GridCard({
    super.key,
    required this.isFirst,
    this.onTapFav,
    required this.plantModel,
    required this.onTap,
    required this.isWishIt,
  });

  @override
  ConsumerState<GridCard> createState() => _GridCardState();
}

class _GridCardState extends ConsumerState<GridCard> {
  bool isFirst = true;
  

  @override
  Widget build(BuildContext context) {
    final wishlistItem = ref.watch(wishlistProvider);
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 2600),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: isFirst
          ? TweenAnimationBuilder<double>(
              key: ValueKey('fir'),
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(seconds: 1),
              onEnd: () => setState(() => isFirst = false),
              builder: (BuildContext context, value, Widget? child) {
                return Opacity(
                  opacity: value,
                  child: Transform.scale(
                    scale: 0.96 + 0.04 * value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 150,
                          width: 250,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(186, 234, 233, 233),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 16,
                              width: 100,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(186, 234, 233, 233),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              padding: EdgeInsets.all(10),
                            ),
                            Row(
                              children: [
                                Container(
                                  height: 16,
                                  width: 36,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                      186,
                                      234,
                                      233,
                                      233,
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  padding: EdgeInsets.all(10),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          height: 16,
                          width: 60,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(186, 234, 233, 233),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.all(10),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          : Column(
              key: ValueKey('sec'),
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 250,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(186, 234, 233, 233),
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(widget.plantModel.image ?? ""),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: FavoriteButton(
                      onTap: () => ref
                          .read(wishlistProvider.notifier)
                          .addToWishlist(widget.plantModel),
                      isFirst: wishlistItem.contains(widget.plantModel)
                          ? false
                          : true,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.plantModel.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Color(0xffFDD442)),
                        Text('4.9', style: TextStyle(color: tertiaryColor)),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$${widget.plantModel.price}',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
    );
  }
}
