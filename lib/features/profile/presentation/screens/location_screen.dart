import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../../../core/widgets/custom_snackbar.dart';
import '../../../../l10n/app_localizations.dart';

import '../../../../core/widgets/svg_icon.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  LocationScreenState createState() => LocationScreenState();
}

class LocationScreenState extends State<LocationScreen> {
  String? selectedCity;
  bool? isCurrentLocationOn = false;
  bool isLoading = false;

  // POPULAR CITIES
  List<Map<String, dynamic>> popularLocations = [
    {"name": "New Delhi", "lat": 28.6139, "lng": 77.2088},
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
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print("Saving City: $city");
    print("Saving Lat: $lat");
    print("Saving Lng: $lng");
    print("Saving isLocationOn: $isLocationOn");

    await ShardPrefHelper.setCity(city);
    await ShardPrefHelper.setLat(lat);
    await ShardPrefHelper.setLng(lng);
    await ShardPrefHelper.setIsCurrentLocationOn(isLocationOn);
    await Future.delayed(Duration(seconds: 1));
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    if (mounted) {
      context.go('/home');
    }
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

        await _saveLocation(
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back_ios)),
          centerTitle: true,
          title: Text(
            "Location",
            style: TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CURRENT LOCATION
                  ListTile(
                    leading: CircularSvgImage(
                      assetPath: AppImages.currentLocationIcon,
                      color: isCurrentLocationOn!
                          ? AppColors.primaryColor
                          : AppColors.greyColor,
                    ),
                    title: Text(
                      "Current Location",
                      style: TextStyle(
                        color: isCurrentLocationOn!
                            ? AppColors.primaryColor
                            : null,
                      ),
                    ),
                    subtitle: Text(
                      "Use Current Location",
                      style: TextStyle(
                        color: isCurrentLocationOn!
                            ? AppColors.primaryColor
                            : null,
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        isCurrentLocationOn = true;
                      });

                      fetchLocationAndUpdate();
                      // if (context.mounted) {
                      //   context.go('/home');
                      // }
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
                      leading: CircularSvgImage(
                        assetPath: AppImages.locationIcon,
                        color: selectedCity == city["name"] &&
                                !isCurrentLocationOn!
                            ? AppColors.primaryColor
                            : AppColors.greyColor,
                      ),
                      title: Text(
                        city["name"],
                        style: TextStyle(
                          color: selectedCity == city["name"] &&
                                  !isCurrentLocationOn!
                              ? AppColors.primaryColor
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
                        // if (context.mounted) {
                        //   context.go('/home');
                        // }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: SizedBox(
                  child: CustomCircularIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
