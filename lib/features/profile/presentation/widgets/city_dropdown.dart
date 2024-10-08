import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  final String? selectCity;
  final Function(String?) onChanged;

  const CityDropdown(
      {super.key, required this.selectCity, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: 'City',
        border: OutlineInputBorder(
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
