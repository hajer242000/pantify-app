import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:plant_app/controller/app_profivders.dart';
import 'package:plant_app/models/address_model.dart';
import 'package:plant_app/statics_var.dart';
import 'package:plant_app/theme/theme.dart';
import 'package:plant_app/utils/dimensions.dart';
import 'package:plant_app/widgets/footer.dart';
import 'package:plant_app/widgets/text_form_field.dart';

class AddAddress extends ConsumerStatefulWidget {
  const AddAddress({super.key});

  @override
  ConsumerState<AddAddress> createState() => _AddAddressState();
}

class _AddAddressState extends ConsumerState<AddAddress> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  Position? position;
  bool _loading = true;
  Set<Marker> _markers = {};

  static const CameraPosition _fallback = CameraPosition(
    target: LatLng(25.285447, 51.531040),
    zoom: 14,
  );

  @override
  void initState() {
    super.initState();
    _determinePosition(address, floor, landmark);
  }

  Future<void> _determinePosition(
    TextEditingController address,
    TextEditingController floor,
    TextEditingController landmark,
  ) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => _loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _loading = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() => _loading = false);
        return;
      }

      final userLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      position = userLocation;

      final me = LatLng(userLocation.latitude, userLocation.longitude);
      List<Placemark> placemark = await placemarkFromCoordinates(
        userLocation.latitude,
        userLocation.longitude,
      );

      setState(() {
        print(address.text);
        _markers = {
          Marker(
            markerId: const MarkerId('me'),
            position: me,
            infoWindow: const InfoWindow(title: 'Me'),
          ),
        };
        address.text =
            '${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].locality} ${placemark[0].administrativeArea} ${placemark[0].country}';
        floor.text = '${placemark[0].postalCode}';
        landmark.text = placemark[0].locality!;
        _loading = false;
      });

      await _moveCamera(me, zoom: 17);
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _moveCamera(LatLng target, {double zoom = 16}) async {
    if (!_controller.isCompleted) return;
    final controller = await _controller.future;
    await controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: target, zoom: zoom),
      ),
    );
  }

  saveAddress(String buildingTypeText) {
    try {
      AddressModel addressModel = AddressModel(
        userId: supabase.auth.currentUser!.id,
        buildingType: buildingTypeText,
        fullAddress: address.text,
        floor: floor.text,
        landmark: landmark.text,
        lat: _markers.first.position.latitude,
        lng: _markers.first.position.longitude,
        isDefault: true,
      );
      ref.read(userAddress).addAddress(addressModel);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Your address was saved successfully')),
      );

      ref.invalidate(userAddress);
      ref.invalidate(getAddress);

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger(
        child: SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            "Failed to Save your Address",
            style: TextStyle(color: Colors.white),
          ),
        ),
      );
    }
  }

  List<String> buildingType = ["Home", "Parents House", "Farm House", "Other"];
  int selected = 0;

  TextEditingController address = TextEditingController();
  TextEditingController floor = TextEditingController();
  TextEditingController landmark = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String buildingTypeText = buildingType[selected];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Add Address"),
      ),
      body: Stack(
        children: [
          SizedBox(height: height(context), width: width(context)),
          Positioned(
            top: 0,
            child: Stack(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 2.7,
                  width: MediaQuery.of(context).size.width,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    initialCameraPosition: position == null
                        ? _fallback
                        : CameraPosition(
                            target: LatLng(
                              position!.latitude,
                              position!.longitude,
                            ),
                            zoom: 16,
                          ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    zoomControlsEnabled: true,
                    markers: _markers,
                    onTap: (latLng) async {
                      setState(() {
                        _markers = {
                          Marker(
                            markerId: const MarkerId('me'),
                            position: latLng,
                            infoWindow: const InfoWindow(title: 'Me'),
                          ),
                        };
                      });
                      List<Placemark> placemark =
                          await placemarkFromCoordinates(
                            latLng.latitude,
                            latLng.longitude,
                          );
                      address.text =
                          '${placemark[0].name} ${placemark[0].subLocality} ${placemark[0].locality} ${placemark[0].country}';
                      floor.text = '${placemark[0].postalCode}';
                      landmark.text = placemark[0].locality!;
                      _moveCamera(latLng, zoom: 17);
                    },
                    onMapCreated: (GoogleMapController controller) async {
                      _controller.complete(controller);

                      if (position != null) {
                        await _moveCamera(
                          LatLng(position!.latitude, position!.longitude),
                          zoom: 17,
                        );
                      }
                    },
                  ),
                ),
                if (_loading)
                  const Positioned.fill(
                    child: IgnorePointer(
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height / 2.8,
            child: Container(
              height: MediaQuery.of(context).size.height / 2.1,
              width: width(context),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 202, 201, 201),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              padding: EdgeInsets.all(15),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: height(context)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Save address as*',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        spacing: 5,
                        children: List.generate(
                          buildingType.length,
                          (index) => RawChip(
                            onSelected: (value) {
                              setState(() {
                                selected = index;
                                buildingTypeText[selected];
                              });
                            },
                            backgroundColor: selected == index
                                ? primaryColor
                                : const Color.fromARGB(255, 225, 225, 225),
                            label: Text(
                              buildingType[index],
                              style: TextStyle(
                                fontSize: 11,
                                color: selected == index
                                    ? Colors.white
                                    : Colors.black,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.transparent),
                              borderRadius: BorderRadiusGeometry.circular(15),
                            ),
                          ),
                        ),
                      ),
                    ),
                    title("Complete Address"),
                    AppTextField(
                      controller: address,
                      hint: "Enter Address*",
                      maxLines: 3,
                    ),
                    title("Floor"),
                    AppTextField(
                      controller: floor,
                      hint: "Enter Floor*",
                      maxLines: 1,
                    ),
                    title("LandMark"),
                    AppTextField(
                      controller: landmark,
                      hint: "Enter Landmark*",
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            child: Footer(
              title: "Save Address",
              onPressed: () => saveAddress(buildingTypeText),
            ),
          ),
        ],
      ),
    );
  }

  Widget title(String title) => Text(title, style: TextStyle(fontSize: 15));
}
