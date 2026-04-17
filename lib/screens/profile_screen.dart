import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';
import 'package:plant_app/models/profile_tile_model.dart';
import 'package:plant_app/theme/theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ProfileTileModel> tile = [
    ProfileTileModel(title: 'Your Profile', heroIcons: HeroIcons.user , ),
    ProfileTileModel(title: 'Mange Address', heroIcons: HeroIcons.mapPin),
    ProfileTileModel(title: 'Payment Methods', heroIcons: HeroIcons.creditCard),
    ProfileTileModel(
      title: 'My Orders',
      heroIcons: HeroIcons.clipboardDocument,
      onTap: (BuildContext context) {
        Navigator.pushNamed(context, '/orders');
      },
    ),
    ProfileTileModel(title: 'My Coupons', heroIcons: HeroIcons.calendarDays),
    ProfileTileModel(title: 'My Wallet', heroIcons: HeroIcons.wallet),
    ProfileTileModel(title: 'Setting', heroIcons: HeroIcons.cog8Tooth),
    ProfileTileModel(
      title: 'Help Center',
      heroIcons: HeroIcons.informationCircle,
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Column(
        children: [
          Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('images/profile.jpg'),
              ),
            ),
          ),
          SizedBox(height: 12,),
          Text(
            "Esther Howard",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 12,),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 12 , vertical: 0),
              itemBuilder: (context, index) {
                final item = tile[index];
                return ListTile(
                  leading: HeroIcon(item.heroIcons, color: primaryColor),
                  title: Text(item.title),
                  trailing: HeroIcon(HeroIcons.chevronRight),
              onTap: () => item.onTap?.call(context),

                );
              },
              separatorBuilder: (context, index) => Divider(color:  Colors.grey,),
              itemCount: tile.length,
            ),
          ),
        ],
      ),
    );
  }
}
