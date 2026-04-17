
import 'package:flutter/material.dart';
import 'package:plant_app/theme/theme.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({
    super.key,
    required this.onTap,
    required this.isFirst,
  });

  final void Function()? onTap;
  final bool isFirst;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 600),
        transitionBuilder: (child, animation) =>
            FadeTransition(opacity: animation, child: child),
        child: isFirst
            ? Container(
                key: ValueKey(1),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: quaternaryColor,
                ),
                child: Icon(Icons.favorite, color: tertiaryColor),
              )
            : Container(
                key: ValueKey(2),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: quaternaryColor,
                ),
                child: Icon(Icons.favorite, color: Colors.red),
              ),
      ),
    );
  }
}
