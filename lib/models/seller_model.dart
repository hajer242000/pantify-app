import 'package:plant_app/utils/num_cast.dart';

class SellerModel {
  final String id;
  final String name;
  final String farmName;
  final String position;
  final String location;
  final String about;
  final String image;
  final double lat;
  final double lng;
  final String farmImage;
  SellerModel({
    required this.id,
    required this.name,
    required this.farmName,
    required this.position,
    required this.location,
    required this.about,
    required this.image,
    required this.lat,
    required this.lng,
    required this.farmImage
  });

  factory SellerModel.fromMap(Map<String, dynamic> m) {
    return SellerModel(
      id: m['id'] ?? "",
      name: m['name'] ?? "",
      farmName: m['farm_name'] ?? "",
      position: m['job_title'] ?? "",
      location: m['location'] ?? "",
      about: m['about'] ?? "",
      image: m['image'] ?? "",
      lat: NumCast.toDouble(m['lat']),
      lng: NumCast.toDouble(m['lng']),
      farmImage: m['farm_image']??''
    );
  }
}
