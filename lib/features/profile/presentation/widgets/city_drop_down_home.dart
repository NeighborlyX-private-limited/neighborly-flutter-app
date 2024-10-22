import 'package:flutter/material.dart';

class CityDropdownHome extends StatelessWidget {
  final String? selectCity;
  final Function(String?) onChanged;

  const CityDropdownHome({
    super.key,
    required this.selectCity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        items: const [
          DropdownMenuItem(
            value: 'Delhi',
            child: Text('Delhi', style: TextStyle(fontSize: 10)),
          ),
          DropdownMenuItem(
            value: 'Noida',
            child: Text('Noida', style: TextStyle(fontSize: 10)),
          ),
          DropdownMenuItem(
            value: 'Gurugram',
            child: Text('Gurugram', style: TextStyle(fontSize: 10)),
          ),
          DropdownMenuItem(
            value: 'New Delhi',
            child: Text('New Delhi', style: TextStyle(fontSize: 10)),
          ),
        ],
        onChanged: onChanged,
        isExpanded: false,
      ),
    );
  }
}
