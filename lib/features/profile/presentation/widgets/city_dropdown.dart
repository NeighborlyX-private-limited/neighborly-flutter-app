import 'package:flutter/material.dart';

class CityDropdown extends StatelessWidget {
  final String? selectCity;
  final bool? isHome;
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
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),
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
        DropdownMenuItem(
          value: 'New Delhi',
          child: Text('New Delhi'),
        ),
      ],
      onChanged: onChanged,
    );
  }
}
