import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class ProfileTileModel {
  final String title;
  final HeroIcons heroIcons;
 final void Function(BuildContext context)? onTap;

  ProfileTileModel({required this.title, required this.heroIcons, this.onTap});
}
