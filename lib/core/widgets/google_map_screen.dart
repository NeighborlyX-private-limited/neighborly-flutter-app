// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:google_places_flutter/google_places_flutter.dart';
// import 'package:google_places_flutter/model/prediction.dart';
// import 'package:permission_handler/permission_handler.dart';
// import '../../../../core/utils/shared_preference.dart';

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _mapController;
//   LatLng _currentLocation = LatLng(28.6139, 77.2088); // Default to Delhi
//   TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _loadSavedLocation();
//   }

//   // Load saved location from SharedPreferences
//   void _loadSavedLocation() {
//     double? lat = ShardPrefHelper.getLat();
//     double? lng = ShardPrefHelper.getLng();
//     String? city = ShardPrefHelper.getCity();

//     if (lat != null && lng != null) {
//       setState(() {
//         _currentLocation = LatLng(lat, lng);
//         _searchController.text = city ?? "";
//       });
//     }
//   }

//   // Save location to SharedPreferences
//   Future<void> _saveLocation(LatLng position) async {
//     print('hello $position');
//     List<Placemark> placemarks =
//         await placemarkFromCoordinates(position.latitude, position.longitude);
//     String city = placemarks.isNotEmpty ? placemarks[0].locality ?? "" : "";

//     await ShardPrefHelper.setLat(position.latitude);
//     await ShardPrefHelper.setLng(position.longitude);
//     await ShardPrefHelper.setCity(city);

//     setState(() {
//       _searchController.text = city;
//     });
//   }

//   // Handle map drag
//   // void _onMapDragEnd(CameraPosition position) {
//   //   _saveLocation(position.target);
//   // }

//   // Handle search selection
//   // void _onPlaceSelected(Prediction prediction) async {
//   //   List<Location> locations =
//   //       await locationFromAddress(prediction.description!);
//   //   if (locations.isNotEmpty) {
//   //     LatLng newLocation =
//   //         LatLng(locations.first.latitude, locations.first.longitude);
//   //     _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
//   //     _saveLocation(newLocation);
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Select Location")),
//       body: Column(
//         children: [
//           // Search Box
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: GooglePlaceAutoCompleteTextField(
//           //     itemClick: (postalCodeResponse) {
//           //       _searchController.text = postalCodeResponse.description!;
//           //       _onPlaceSelected(postalCodeResponse);
//           //       FocusScope.of(context).unfocus();
//           //     },
//           //     textEditingController: _searchController,
//           //     googleAPIKey: "AIzaSyByCyGvfaMDCyXXaZwYNE3jK6qXCFABo7A",
//           //     debounceTime: 400,
//           //     getPlaceDetailWithLatLng: (Prediction prediction) {
//           //       _onPlaceSelected(prediction);
//           //     },

//           //   ),
//           // ),
//           Expanded(
//             child: GoogleMap(
//               initialCameraPosition: CameraPosition(
//                 target: _currentLocation,
//                 zoom: 14,
//               ),
//               onMapCreated: (controller) {
//                 _mapController = controller;
//               },
//               //  onCameraIdle: () async {
//               //   if (_mapController != null) {
//               //     var position = await _mapController!.getLatLng(_mapController!.getScreenCoordinate(latLng));
//               //     _onMapDragEnd(position);
//               //   }
//               // },
//               // onCameraIdle: () {
//               //   _onMapDragEnd(_mapController!.getLatLng(screenCoordinate));
//               // },
//               markers: {
//                 Marker(
//                   markerId: MarkerId("selected-location"),
//                   position: _currentLocation,
//                   draggable: true,
//                   onDragEnd: (position) {
//                     _saveLocation(position);
//                   },
//                 ),
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../../../../core/utils/shared_preference.dart';

class LocationPickerScreen extends StatefulWidget {
  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  LatLng _currentLocation = LatLng(28.6139, 77.2088); // Default to Delhi
  LatLng? _pendingLocation;
  TextEditingController _searchController = TextEditingController();
  Marker _marker = Marker(
    markerId: MarkerId("selected-location"),
    position: LatLng(28.6139, 77.2088),
  );

  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  // Load saved location from SharedPreferences
  void _loadSavedLocation() {
    double? lat = ShardPrefHelper.getLat();
    double? lng = ShardPrefHelper.getLng();
    String? city = ShardPrefHelper.getCity();

    if (lat != null && lng != null) {
      setState(() {
        _currentLocation = LatLng(lat, lng);
        _searchController.text = city ?? "";
        _marker = _marker.copyWith(
          positionParam: _currentLocation,
        );
      });
    }
  }

//   // Handle search selection
  void _onPlaceSelected(Prediction prediction) async {
    List<Location> locations =
        await locationFromAddress(prediction.description!);
    if (locations.isNotEmpty) {
      LatLng newLocation =
          LatLng(locations.first.latitude, locations.first.longitude);
      _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
      // _saveLocation(newLocation);
    }
  }

  // Save location to SharedPreferences
  Future<void> _saveLocation() async {
    if (_pendingLocation == null) return;
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _pendingLocation!.latitude, _pendingLocation!.longitude);
    String city = placemarks.isNotEmpty ? placemarks[0].locality ?? "" : "";

    await ShardPrefHelper.setLat(_pendingLocation!.latitude);
    await ShardPrefHelper.setLng(_pendingLocation!.longitude);
    await ShardPrefHelper.setCity(city);

    setState(() {
      _currentLocation = _pendingLocation!;
      _searchController.text = city;
      _pendingLocation = null;
    });
  }

  // Update pending location and move marker when map is moved
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
          //           // Search Box
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GooglePlaceAutoCompleteTextField(
              itemClick: (postalCodeResponse) {
                _searchController.text = postalCodeResponse.description!;
                _onPlaceSelected(postalCodeResponse);
                FocusScope.of(context).unfocus();
              },
              textEditingController: _searchController,
              googleAPIKey: "AIzaSyByCyGvfaMDCyXXaZwYNE3jK6qXCFABo7A",
              debounceTime: 400,
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
              child: Text("Save Location"),
            ),
          ),
        ],
      ),
    );
  }
}
