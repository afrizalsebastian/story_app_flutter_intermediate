import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/model/story.dart';
import 'package:story_app_flutter_intermediate/provider/api_enum.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiServices apiServices;
  String storyId;

  DetailStoryProvider({required this.apiServices, required this.storyId});

  late Story _story;
  late ResultState _state;
  String _message = '';
  LatLng? _storyLocation;
  final Set<Marker> _mapMarker = {};
  geo.Placemark? _placemark;

  String get message => _message;
  Story get story => _story;
  ResultState get state => _state;
  LatLng? get storyLocation => _storyLocation;
  Set<Marker> get mapMarker => _mapMarker;
  geo.Placemark? get placemark => _placemark;

  Future<dynamic> upadteStoryId(String newStoryId) async {
    storyId = newStoryId;
    return await _fetchData();
  }

  Future<dynamic> _fetchData() async {
    try {
      _state = ResultState.loading;
      notifyListeners();

      final storyData = await apiServices.getDetailStory(storyId);
      _state = ResultState.hasData;
      if (storyData.lat != null && storyData.lon != null) {
        _storyLocation = LatLng(storyData.lat!, storyData.lon!);

        final info = await geo.placemarkFromCoordinates(
            _storyLocation!.latitude, _storyLocation!.longitude);

        final place = info[0];
        final street = place.street!;
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

        _placemark = place;

        defineMarker(_storyLocation!, street, address);
      } else {
        _mapMarker.clear();
        _placemark = null;
        _storyLocation = null;
      }

      notifyListeners();
      return _story = storyData;
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      if (e is SocketException) {
        _message = 'No Internet Connection';
        return message;
      } else {
        _message = 'Error: $e';
        return message;
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

    _mapMarker.clear();
    _mapMarker.add(marker);
  }
}
