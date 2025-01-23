import 'package:flutter/material.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

class CityDropdown extends StatefulWidget {
  final bool isHome;
  final String? selectCity;
  final Function(String?) onChanged;

  const CityDropdown({
    super.key,
    required this.selectCity,
    required this.onChanged,
    this.isHome = false,
  });

  @override
  State<CityDropdown> createState() => _CityDropdownState();
}

class _CityDropdownState extends State<CityDropdown> {
  @override
  Widget build(BuildContext context) {
   
    return InkWell(
      onTap: () {
        _showCitySelectionSheet(context);
      },
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          filled: true,
          fillColor: Colors.white, // Match TextField color
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
            borderSide: BorderSide(color: Colors.grey), // Border like TextField
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(color: Colors.grey),
          ),
        ),
        value: widget.selectCity, // Current selected value
        hint: Text(
          widget.selectCity ?? 'Select City',
          style: TextStyle(
              color: AppColors.blackColor, fontWeight: FontWeight.w600),
        ),
        icon: Icon(
          Icons.arrow_drop_down,
          color: AppColors.greyColor,
        ),
        items: [], // Empty items list
        onChanged: null, // Disable dropdown functionality
      ),
    );

    // return SizedBox(
    //   width: MediaQuery.of(context).size.width * 0.9,
    //   height: MediaQuery.of(context).size.height * 0.07,
    //   child: ElevatedButton(
    //     style: ElevatedButton.styleFrom(
    //       elevation: 0, // Remove shadow
    //       backgroundColor: Colors.white, // Match TextField color
    //       shape: RoundedRectangleBorder(
    //         borderRadius: BorderRadius.circular(8.0), // Rounded corners
    //         side: BorderSide(color: Colors.grey), // Border like TextField
    //       ),
    //     ),
    //     onPressed: () => _showCitySelectionSheet(context),
    //     child: Row(
    //       mainAxisAlignment: MainAxisAlignment.start,
    //       children: [
    //         Text(
    //           widget.selectCity ?? 'Select City',
    //           style: TextStyle(color: AppColors.blackColor),
    //         ),
    //         Icon(
    //           Icons.arrow_drop_down,
    //           color: AppColors.greyColor,
    //         )
    //       ],
    //     ),
    //   ),
    // );
  }

  void _showCitySelectionSheet(BuildContext context) {
    showModalBottomSheet(
       backgroundColor: AppColors.whiteColor,
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final List<String> cities = [
          'Delhi',
          'Noida',
          'Gurugram',
        ]; // Example cities list
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select your location',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: cities.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(cities[index]),
                  onTap: () {
                    widget.onChanged(cities[index]);
                    Navigator.pop(context); // Close the bottom sheet
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
