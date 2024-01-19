import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app_flutter_intermediate/common/styles.dart';
import 'package:story_app_flutter_intermediate/provider/post_story_provider.dart';

class PostLocation extends StatefulWidget {
  const PostLocation({super.key});

  @override
  State<PostLocation> createState() => _PostLocationState();
}

class _PostLocationState extends State<PostLocation> {
  late GoogleMapController mapController;

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final psWatch = context.watch<PostStoryProvider>();
    final psRead = context.read<PostStoryProvider>();

    return Center(
      child: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              zoom: 16,
              target:
                  psWatch.myLocation ?? const LatLng(-6.8957473, 107.6337669),
            ),
            markers: psRead.myLocationMarkers,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            myLocationButtonEnabled: false,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            scrollGesturesEnabled: true,
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            onLongPress: (LatLng latLng) => onLongPressGoogleMap(latLng),
          ),
          Positioned(
            top: 16,
            right: 16,
            child: FloatingActionButton(
              backgroundColor: Styles.primaryColor,
              foregroundColor: Colors.white,
              onPressed: () {
                psRead.getMyLocation();

                mapController.animateCamera(
                  CameraUpdate.newLatLng(psWatch.myLocation!),
                );
              },
              child: const Icon(Icons.my_location),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: PlacemarkWidget(placemark: psRead.placemark!),
          ),
          Positioned(
            bottom: 10,
            right: 16,
            child: ElevatedButton(
              style: const ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(
                  Styles.primaryColor,
                ),
              ),
              onPressed: () {
                psRead.deactivateLocation();
              },
              child: const Text(
                "Simpan",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final psRead = context.read<PostStoryProvider>();

    psRead.longPressMaps(latLng);
    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget({
    super.key,
    required this.placemark,
  });

  /// todo-05-02: create a variable
  final geo.Placemark placemark;

  @override
  Widget build(BuildContext context) {
    return Container(
      /// todo-05-03: show the information
      padding: const EdgeInsets.all(8),
      constraints: const BoxConstraints(maxWidth: 250),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: const TextStyle(fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: const TextStyle(fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
