import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/seller_model.dart';
import 'package:plant_app/screens/home_screen.dart';
import 'package:plant_app/screens/plant_seller.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:custom_marker_builder/custom_marker_builder.dart';
import 'package:plant_app/widgets/sellers_list_view.dart';

class ExploreScreen extends ConsumerStatefulWidget {
  const ExploreScreen({super.key});

  @override
  ConsumerState<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends ConsumerState<ExploreScreen> {
  TextEditingController textEditingControllerSearch = TextEditingController();

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Position? position;
  bool _loading = true;

  Set<Marker> _markers = {};
  final Map<String, BitmapDescriptor> _markerIconCache = {};
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _loading = false;
      });
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _loading = false;
        });
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _loading = false;
      });
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final userLocation = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      position = userLocation;
      _markers
        ..clear()
        ..add(
          Marker(
            markerId: MarkerId('me'),
            position: LatLng(userLocation.latitude, userLocation.longitude),
            infoWindow: InfoWindow(title: "me"),
          ),
        );
      _loading = false;
    });
    _animateTo(LatLng(userLocation.latitude, userLocation.longitude), zoom: 15);
  }

  Future<void> _animateTo(LatLng latLng, {double zoom = 15}) async {
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: zoom),
      ),
    );
  }

  @override
  void initState() {
    _determinePosition();

    super.initState();
  }

  Future<void> _precacheAvatar(String url) async {
    final img = NetworkImage(url);
    try {
      await precacheImage(img, context);
    } catch (_) {}
  }

  Future<BitmapDescriptor> _buildMarkerIcon({
    required String url,
    required double sellerLat,
    required double sellerLng,
  }) async {
    await _precacheAvatar(url);

    final distMeters = Geolocator.distanceBetween(
      position!.latitude,
      sellerLat,
      position!.longitude,
      sellerLng,
    );

    final icon = await CustomMapMarkerBuilder.fromWidget(
      context: context,
      marker: Material(
        type: MaterialType.transparency,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: CustomMarkerWidget(url: url, distance: distMeters),
        ),
      ),
    );

    return icon;
  }

  Future<BitmapDescriptor> _getMarkerIconForSeller(SellerModel s) async {
    if (_markerIconCache.containsKey(s.id)) {
      return _markerIconCache[s.id]!;
    }
    final icon = await _buildMarkerIcon(
      url: s.image,
      sellerLat: s.lat,
      sellerLng: s.lng,
    );
    _markerIconCache[s.id] = icon;
    return icon;
  }

  List<SellerModel> _filteredOptions = [];
  bool isFirst = true;
  @override
  Widget build(BuildContext context) {
    const fallback = CameraPosition(
      target: LatLng(25.285447, 51.531040),
      zoom: 12,
    );

    ref.listen<AsyncValue<List<SellerModel>>>(sellerProvider, (
      prev,
      next,
    ) async {
      final sellers = next.value ?? [];

      final valid = sellers.where((s) => s.lat != 0 && s.lng != 0).toList();
      if (valid.isEmpty || position == null) return;

      final icons = await Future.wait(
        valid.map((s) => _getMarkerIconForSeller(s)),
      );

      final markers = <Marker>{
        ..._markers,
        for (int i = 0; i < valid.length; i++)
          Marker(
            markerId: MarkerId(valid[i].id),
            position: LatLng(valid[i].lat, valid[i].lng),
            icon: icons[i],
            infoWindow: InfoWindow(
              title: valid[i].farmName.isNotEmpty
                  ? valid[i].farmName
                  : valid[i].name,
              snippet: valid[i].location,
            ),
          ),
      };

      if (!mounted) return;
      setState(() => _markers = markers);
    });
    final plantSellers = ref.watch(sellerProvider);

    final wishlistSeller = ref.watch(wishlistSellersProvider);
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          Positioned.fill(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GoogleMap(
                    mapType: MapType.terrain,
                    onTap: (argument) {
                      print(argument);
                    },
                    initialCameraPosition: position == null
                        ? fallback
                        : CameraPosition(
                            target: LatLng(
                              position!.latitude,
                              position!.longitude,
                            ),
                            zoom: 15,
                          ),
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    compassEnabled: true,
                    zoomControlsEnabled: false,
                    markers: _markers,
                  ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,

            child: plantSellers.when(
              data: (data) {
                return SizedBox(
                  height: 320,
                  width: width(context),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                  
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final plant = data[index];
                      return InkWell( onTap: () {
            
              Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlantSeller(sellerId: plant.id),
                          ),
                        );
            },
                        child: SellerCard(
                          isInExplore: true,
                          sellerModel: plant,
                          isFirst: wishlistSeller.contains(plant),
                          onTap: () {
                            ref
                                .read(wishlistSellersProvider.notifier)
                                .addToWishlist(plant);
                          },
                        ),
                      );
                    },
                  ),
                );
              },
              error: (error, stackTrace) => Center(child: Text("Error")),
              loading: () => Center(child: CircularProgressIndicator()),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 0,
            child: SafeArea(
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: plantSellers.when(
                  data: (data) {
                    return SearchBar(
                      onSubmitted: (value) {
                        setState(() {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PlantSeller(sellerId: data.first.id),
                            ),
                          );
                          textEditingControllerSearch.clear();
                        });
                      },
                      controller: textEditingControllerSearch,
                      onChanged: (value) {
                        setState(() {
                          _filteredOptions = data
                              .where(
                                (test) => test.name.toLowerCase().startsWith(
                                  value.trim().toLowerCase(),
                                ),
                              )
                              .toList();

                          textEditingControllerSearch.text.isEmpty
                              ? _filteredOptions.clear()
                              : null;
                        });
                      },

                      hintText: "Search Plant Seller",
                      hintStyle: WidgetStateProperty.all(
                        TextStyle(color: placeholdColor, fontSize: 15),
                      ),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      leading: Icon(Icons.search, color: primaryColor),
                    );
                  },
                  error: (error, stackTrace) => Center(child: Text("Error")),
                  loading: () => CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          if (_filteredOptions.isNotEmpty)
            Positioned(
              left: 12,
              right: 12,
              top: 100,
              child: Container(
                margin: EdgeInsets.only(top: 30),
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
                                PlantSeller(sellerId: suggestion.id),
                          ),
                        );
                        textEditingControllerSearch.clear();
                      },
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class CustomMarkerWidget extends StatelessWidget {
  final String url;
  final double distance;

  const CustomMarkerWidget({
    super.key,
    required this.url,
    required this.distance,
  });

  String _fmt(double m) {
    if (m < 1000) return '${m.toStringAsFixed(0)} m';
    final km = m / 1000;
    return '${km.toStringAsFixed(km < 10 ? 1 : 0)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            border: Border.all(color: primaryColor, width: 3),
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(25),

            child: Image.network(
              url,
              width: 48,
              height: 48,
              fit: BoxFit.cover,

              errorBuilder: (c, e, s) => Container(
                width: 48,
                height: 48,
                color: Colors.grey.shade300,
                alignment: Alignment.center,
                child: const Icon(Icons.person, size: 24),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: const [BoxShadow(blurRadius: 2, color: Colors.black26)],
          ),
          child: Text(
            _fmt(distance),
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
