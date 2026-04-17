class AddressModel {
  final String? id;           
  final String userId;
  final String buildingType;
  final String fullAddress;
  final String? floor;
  final String? landmark;
  final double lat;
  final double lng;
  final bool isDefault;
  final DateTime? createdAt;

  AddressModel({
     this.id,
    required this.userId,
    required this.buildingType,
    required this.fullAddress,
    required this.lat,
    required this.lng,
    this.floor,
    this.landmark,
    this.isDefault = false,
    this.createdAt,
  });

  factory AddressModel.fromMap(Map<String, dynamic> data) {
    return AddressModel(
      id: data['id'] as String,
      userId: data['user_id'] as String,
      buildingType: data['building_type'] as String,
      fullAddress: data['full_address'] as String,
      floor: data['floor'] as String?,
      landmark: data['landmark'] as String?,
      lat: (data['lat'] as num).toDouble(),
      lng: (data['lng'] as num).toDouble(),
      isDefault: (data['is_default'] as bool?) ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.tryParse(data['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'building_type': buildingType,
      'full_address': fullAddress,
      'floor': floor,
      'landmark': landmark,
      'lat': lat,
      'lng': lng,
      'is_default': isDefault,
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? buildingType,
    String? fullAddress,
    String? floor,
    String? landmark,
    double? lat,
    double? lng,
    bool? isDefault,
    DateTime? createdAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      buildingType: buildingType ?? this.buildingType,
      fullAddress: fullAddress ?? this.fullAddress,
      floor: floor ?? this.floor,
      landmark: landmark ?? this.landmark,
      lat: lat ?? this.lat,
      lng: lng ?? this.lng,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}