import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/screens/chat_screen.dart';
import 'package:plant_app/screens/explore_screen.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/screens/profile_screen.dart';
import 'package:plant_app/screens/wish_list_screen.dart';

class LaunchScreen extends StatefulWidget {
  const LaunchScreen({super.key});

  @override
  State<LaunchScreen> createState() => _LaunchScreenState();
}

class _LaunchScreenState extends State<LaunchScreen> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: index,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.home, style: HeroIconStyle.solid),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.mapPin, style: HeroIconStyle.solid),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.heart, style: HeroIconStyle.solid),
            label: 'WishList',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(
              HeroIcons.chatBubbleOvalLeftEllipsis,
              style: HeroIconStyle.solid,
            ),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: HeroIcon(HeroIcons.user, style: HeroIconStyle.solid),
            label: 'Profile',
          ),
        ],
      ),
      body: IndexedStack(
        index: index,
        children: [
          HomeScreen(),
          ExploreScreen(),
          WishListScreen(),
          ChatScreen(),
          ProfileScreen(),
        ],
      ),
    );
  }
}
