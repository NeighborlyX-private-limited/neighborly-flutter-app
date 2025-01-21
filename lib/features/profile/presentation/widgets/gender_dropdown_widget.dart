import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GenderDropdown extends StatelessWidget {
  final String? selectedGender;
  final Function(String?) onChanged;

  const GenderDropdown(
      {super.key, required this.selectedGender, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showGenderSelectionSheet(context);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          hintText: selectedGender ?? AppLocalizations.of(context)!.gender,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              this.selectedGender ?? AppLocalizations.of(context)!.gender,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _showGenderSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
      ),
      builder: (BuildContext context) {
        final List<String> genders = ['Male', 'Female', 'Other'];
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                AppLocalizations.of(context)!.gender,
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            Divider(height: 1.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: genders.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(genders[index]),
                  onTap: () {
                    onChanged(genders[index]);
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
    
    
    
//     DropdownButtonFormField<String>(
//       decoration: InputDecoration(
//         hintText: AppLocalizations.of(context)!.gender,
//         // hintText: 'Gender',
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(8.0),
//         ),
//       ),
//       value: selectedGender,
//       items: const [
//         DropdownMenuItem(
//           value: 'Male',
//           child: Text('Male'),
//         ),
//         DropdownMenuItem(
//           value: 'Female',
//           child: Text('Female'),
//         ),
//         DropdownMenuItem(
//           value: 'Other',
//           child: Text('Other'),
//         ),
//       ],
//       onChanged: onChanged,
//     );
//   }
// }
