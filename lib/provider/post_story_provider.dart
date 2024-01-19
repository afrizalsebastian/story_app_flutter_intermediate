import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PostStoryProvider extends ChangeNotifier {
  String? imagePath;
  XFile? imageFile;

  void setImagePath(String? value) {
    imagePath = value;
    notifyListeners();
  }

  void setImageFile(XFile? value) {
    imageFile = value;
    notifyListeners();
  }

  //Location
  bool openMap = false;
  LatLng? _myLocation;
  final Set<Marker> _myLocationMarkers = {};
  geo.Placemark? _placemark;

  Set<Marker> get myLocationMarkers => _myLocationMarkers;
  LatLng? get myLocation => _myLocation;
  geo.Placemark? get placemark => _placemark;

  void activateLocation() async {
    openMap = true;
    await getMyLocation();
    notifyListeners();
  }

  void deactivateLocation() {
    openMap = false;
    notifyListeners();
  }

  Future<void> getMyLocation() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    defineMarker(latLng, street, address);

    _myLocation = latLng;
    _placemark = place;

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );

    _myLocationMarkers.clear();
    _myLocationMarkers.add(marker);
    notifyListeners();
  }

  void longPressMaps(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

    _myLocation = latLng;
    _placemark = place;

    defineMarker(latLng, street, address);
    notifyListeners();
  }

  void removeLocation() {
    _myLocation = null;
    _myLocationMarkers.clear();
    _placemark = null;
    notifyListeners();
  }
}
