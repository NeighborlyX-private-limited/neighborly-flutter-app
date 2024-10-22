import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class HomeDropdownCity extends StatefulWidget {
  final String? selectCity;
  final Function(String?) onChanged;

  const HomeDropdownCity({
    super.key,
    required this.selectCity,
    required this.onChanged,
  });

  @override
  HomeDropdownCityState createState() => HomeDropdownCityState();
}

class HomeDropdownCityState extends State<HomeDropdownCity> {
  final GlobalKey _dropdownKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  @override
  void dispose() {
    _overlayEntry?.remove();
    super.dispose();
  }

  OverlayEntry _createOverlay() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 0,
        top: 50,
        width: 180,
        child: Material(
          elevation: 2,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              children: _buildMenuItems(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildMenuItems() {
    List<String> cities = ['Delhi', 'Noida', 'Gurugram', 'New Delhi'];

    return cities.map((city) {
      return Column(
        children: [
          ListTile(
            leading: Icon(Icons.location_on, color: AppColors.primaryColor),
            title: Text(city),
            onTap: () {
              widget.onChanged(city);
              _overlayEntry?.remove();
            },
          ),
          Divider(height: 1, color: Colors.grey),
        ],
      );
    }).toList();
  }

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlay();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: SizedBox(
        key: _dropdownKey,
        width: 30,
        child: Icon(
          Icons.arrow_drop_down,
          size: 30,
          color: AppColors.primaryColor,
        ),
      ),
    );
  }
}
