import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final bool isDetailButton;
  final bool isPrimaryBackground;
  final bool onlyText;
  final String title;
  final void Function()? onPressed;

  final bool isCustomized;
  final double? width;
  final double? height;

  const CustomButton({
    super.key,
    this.isDetailButton = true,
    this.isPrimaryBackground = true,
    this.onlyText = false,
    this.title = "",
    required this.onPressed,
    this.isCustomized = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final buttonWidth = isCustomized
        ? (width ?? MediaQuery.of(context).size.width)
        : MediaQuery.of(context).size.width;
    final buttonHeight = isCustomized ? (height ?? 50) : 50.0;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: onlyText ? 0 : 1,
        backgroundColor: isPrimaryBackground ? primaryColor : Colors.white,
        // fixedSize: Size(buttonWidth, buttonHeight),
        padding: EdgeInsets.symmetric(
          horizontal: isCustomized ? width! : 30,
          vertical: isCustomized ? height! : 15,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      ),
      onPressed: onPressed,
      child: isDetailButton
          ? Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.shopping_bag, color: Colors.white, size: 26),
                SizedBox(width: 12),
                Text(
                  "Add To Cart",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            )
          : Center(
              child: Text(
                title,
                style: TextStyle(
                  color: isPrimaryBackground ? Colors.white : primaryColor,
                  fontWeight: FontWeight.w700,
                  fontSize: isCustomized ? 14 : 16,
                ),
              ),
            ),
    );
  }
}

class IconButtonAppBar extends StatelessWidget {
  final void Function()? onPressed;
  final HeroIcons icon;
  final bool isIconAppBar;
  final bool isFav;
  const IconButtonAppBar({
    super.key,
    required this.onPressed,
    required this.icon,
    this.isIconAppBar = true,
    this.isFav=false
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      icon: Container(
        padding: EdgeInsets.all(7),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isIconAppBar ? Colors.white : Color(0xffF6F6F6),
        ),
        child: HeroIcon(
          style: isIconAppBar ? isFav?HeroIconStyle.solid:HeroIconStyle.outline : HeroIconStyle.solid,
          icon,
          color: isIconAppBar ? isFav?Colors.red:Colors.black  : primaryColor,
        ),
      ),
    );
  }
}
