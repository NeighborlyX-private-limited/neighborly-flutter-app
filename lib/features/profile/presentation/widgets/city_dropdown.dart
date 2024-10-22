import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  final bool isHome;
  final String? selectCity;
  final Function(String?) onChanged;

  const CityDropdown(
      {super.key,
      required this.selectCity,
      required this.onChanged,
      this.isHome = false});

  @override
  Widget build(BuildContext context) {
    print('city in basic info widget ==> $selectCity');
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        icon: isHome == true
            ? Icon(
                Icons.arrow_drop_down,
                size: 30,
              )
            : null,
        //hintText: 'City',
        border: isHome == true
            ? InputBorder.none
            : OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
      ),
      value: selectCity,
      items: const [
        DropdownMenuItem(
          value: 'Delhi',
          child: Text('Delhi'),
        ),
        DropdownMenuItem(
          value: 'Noida',
          child: Text('Noida'),
        ),
        DropdownMenuItem(
          value: 'Gurugram',
          child: Text('Gurugram'),
        ),
        // DropdownMenuItem(
        //   value: 'Kannauj',
        //   child: Text('Kannauj'),
        // ),
        DropdownMenuItem(
          value: 'New Delhi',
          child: Text('New Delhi'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
