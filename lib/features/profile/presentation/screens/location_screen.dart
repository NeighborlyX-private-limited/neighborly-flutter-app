import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  String? selectedCity;
  bool? isCurrentLocationOn = false;

  // POPULAR CITIES
  List<Map<String, dynamic>> popularLocations = [
    {"name": "New Delhi", "lat": 28.6139, "lng": 77.2088}
  ];

  // ALL CITIES
  List<Map<String, dynamic>> allCities = [
    {"name": "Noida", "lat": 28.5747, "lng": 77.356},
    {"name": "Gurugram", "lat": 28.4732, "lng": 77.0189},
  ];

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _loadSavedLocation();
  }

  // GET SAVED LOCATION
  void _loadSavedLocation() async {
    String? savedCity = ShardPrefHelper.getCity();
    bool? isLocationOn = ShardPrefHelper.getIsCurrentLocationOn();

    print("SAVED CITY: $savedCity");
    print("SAVED IS LOCATION ON: $isLocationOn");

    setState(() {
      isCurrentLocationOn = isLocationOn ?? false;
      selectedCity = savedCity;
    });
  }

  // SAVE NEW LOCATION
  Future<void> _saveLocation(
    String city,
    double lat,
    double lng,
    bool isLocationOn,
  ) async {
    print("Saving City: $city");
    print("Saving Lat: $lat");
    print("Saving Lng: $lng");
    print("Saving isLocationOn: $isLocationOn");

    await ShardPrefHelper.setCity(city);
    await ShardPrefHelper.setLat(lat);
    await ShardPrefHelper.setLng(lng);
    await ShardPrefHelper.setIsCurrentLocationOn(isLocationOn);
  }

  // ASK LOCATION PERMISSION
  Future<bool> _handleLocationPermission() async {
    LocationPermission permission;
    var checkPushPermission = await Permission.notification.isDenied;
    if (checkPushPermission) {
      await Permission.notification.request();
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      // LOCATION PERMISSION DENIED
      if (permission == LocationPermission.denied) {
        if (mounted) {
          showSnackBar(
            context: context,
            message:
                AppLocalizations.of(context)!.location_permissions_are_denied,
          );
        }
        return false;
      }
    }

    // LOCATION PERMISSION PERMANANT DENIED
    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        showSnackBar(
          context: context,
          message: AppLocalizations.of(context)!
              .location_permissions_are_permanently_denied_we_cannot_request_permissions,
        );
      }
      return false;
    }

    // LOCATION PERMISSION GRANTED
    return true;
  }

  // FEATCH USER'S CURRENT LOCATION AND UPDATE.
  Future<void> fetchLocationAndUpdate() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() {
        isCurrentLocationOn = false;
      });
      await ShardPrefHelper.setIsCurrentLocationOn(false);
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        String? city = placemarks[0].locality ?? '';

        _saveLocation(
          city,
          position.latitude,
          position.longitude,
          true,
        );
      }
    } catch (e) {
      setState(() {
        isCurrentLocationOn = false;
      });
      await ShardPrefHelper.setIsCurrentLocationOn(false);
      if (mounted) {
        showSnackBar(context: context, message: e.toString());
      }
    }
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Location"),
        actions: [
          IconButton(
            onPressed: () {
              print('city:${ShardPrefHelper.getCity()}');
              print('lat:${ShardPrefHelper.getLat()}');
              print('long:${ShardPrefHelper.getLng()}');
              print('isLocationOn:${ShardPrefHelper.getIsCurrentLocationOn()}');
            },
            icon: Icon(Icons.location_city),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TEXT FIELD
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 20),
            // CURRENT LOCATION
            ListTile(
              leading: Icon(
                Icons.my_location,
                color: isCurrentLocationOn! ? Colors.blue : null,
              ),
              title: Text(
                "Current Location",
                style: TextStyle(
                  color: isCurrentLocationOn! ? Colors.blue : null,
                ),
              ),
              subtitle: Text(
                "Use Current Location",
                style: TextStyle(
                  color: isCurrentLocationOn! ? Colors.blue : null,
                ),
              ),
              onTap: () {
                setState(() {
                  isCurrentLocationOn = true;
                });

                fetchLocationAndUpdate();
              },
            ),
            SizedBox(height: 10),
            // POPULAR CITY
            Text(
              "Popular",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...popularLocations.map(
              (city) => ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: selectedCity == city["name"] && !isCurrentLocationOn!
                      ? Colors.blue
                      : null,
                ),
                title: Text(
                  city["name"],
                  style: TextStyle(
                    color: selectedCity == city["name"] && !isCurrentLocationOn!
                        ? Colors.blue
                        : null,
                  ),
                ),
                onTap: () {
                  setState(() {
                    selectedCity = city["name"];
                    isCurrentLocationOn = false;
                  });

                  _saveLocation(
                    city["name"],
                    city["lat"],
                    city["lng"],
                    false,
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            // ALL CITY
            Text(
              "All Cities",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...allCities.map(
              (city) => ListTile(
                leading: Icon(
                  Icons.location_on,
                  color: selectedCity == city["name"] && !isCurrentLocationOn!
                      ? Colors.blue
                      : null,
                ),
                title: Text(
                  city["name"],
                  style: TextStyle(
                    color: selectedCity == city["name"] && !isCurrentLocationOn!
                        ? Colors.blue
                        : null,
                  ),
                ),
                onTap: () async {
                  setState(() {
                    selectedCity = city["name"];
                    isCurrentLocationOn = false;
                  });

                  _saveLocation(
                    city["name"],
                    city["lat"],
                    city["lng"],
                    false,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
