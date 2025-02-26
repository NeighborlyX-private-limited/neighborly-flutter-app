import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import '../../../../core/utils/shared_preference.dart';

class LocationPickerScreen extends StatefulWidget {
  const LocationPickerScreen({super.key});

  @override
  LocationPickerScreenState createState() => LocationPickerScreenState();
}

class LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  late TextEditingController _searchController;
  LatLng _currentLocation = LatLng(28.6139, 77.2088);
  LatLng? _pendingLocation;
  Marker _marker = Marker(
    markerId: MarkerId("selected-location"),
    position: LatLng(28.6139, 77.2088),
  );
// INIT STATE
  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
    _searchController = TextEditingController();
  }

// DISPOSE
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // GET USER SAVED LOCATION
  void _loadSavedLocation() {
    double? lat = ShardPrefHelper.getLat();
    double? lng = ShardPrefHelper.getLng();
    String? city = ShardPrefHelper.getCity();
    print('Lat:$lat');
    print('Lng:$lng');
    print('City:$city');

    if (lat != null && lng != null) {
      setState(() {
        _currentLocation = LatLng(lat, lng);
        _marker = _marker.copyWith(
          positionParam: _currentLocation,
        );
      });
    }
  }

  void _onPlaceSelected(Prediction prediction) async {
    List<Location> locations =
        await locationFromAddress(prediction.description!);
    if (locations.isNotEmpty) {
      LatLng newLocation = LatLng(
        locations.first.latitude,
        locations.first.longitude,
      );
      _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
      _pendingLocation = newLocation;
    }
  }

  // SAVE NEW LOCATION
  Future<void> _saveLocation() async {
    if (_pendingLocation == null) return;
    List<Placemark> placemarks = await placemarkFromCoordinates(
      _pendingLocation!.latitude,
      _pendingLocation!.longitude,
    );
    String city = placemarks.isNotEmpty ? placemarks[0].locality ?? "" : "";

    await ShardPrefHelper.setLat(_pendingLocation!.latitude);
    await ShardPrefHelper.setLng(_pendingLocation!.longitude);
    await ShardPrefHelper.setCity(city);

    setState(() {
      _currentLocation = _pendingLocation!;
      _pendingLocation = null;
    });
    if (mounted) {
      showSnackBar(context: context, message: 'Location saved');
    }
  }

  // UPDATE LOCATION WHEN MAP IS DRAGED BY USER
  void _onMapDragEnd() async {
    if (_mapController != null) {
      LatLngBounds bounds = await _mapController!.getVisibleRegion();
      LatLng center = LatLng(
        (bounds.northeast.latitude + bounds.southwest.latitude) / 2,
        (bounds.northeast.longitude + bounds.southwest.longitude) / 2,
      );
      setState(() {
        _pendingLocation = center;
        _marker = _marker.copyWith(
          positionParam: center,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Location")),
      body: Column(
        children: [
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: GooglePlaceAutoCompleteTextField(
              textEditingController: _searchController,
              googleAPIKey: "AIzaSyD_gdm23ym8o6hVytuEDoQ3jVCmbFS4tSk",
              debounceTime: 400,
              itemClick: (postalCodeResponse) {
                _searchController.text = postalCodeResponse.description!;
                _onPlaceSelected(postalCodeResponse);
                FocusScope.of(context).unfocus();
              },
              getPlaceDetailWithLatLng: (Prediction prediction) {
                _onPlaceSelected(prediction);
              },
            ),
          ),
          Expanded(
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation,
                zoom: 14,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
              },
              onCameraIdle: _onMapDragEnd,
              markers: {_marker},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveLocation,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                elevation: 0,
                minimumSize: Size(
                  MediaQuery.of(context).size.width * 0.8,
                  40,
                ),
              ),
              child: Text(
                "Save Location",
                style: TextStyle(
                  color: AppColors.whiteColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
