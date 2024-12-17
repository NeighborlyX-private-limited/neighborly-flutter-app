import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/constants.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/dropdown_search_field.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminLocationScreen extends StatefulWidget {
  const CommunityAdminLocationScreen({
    super.key,
  });

  @override
  State<CommunityAdminLocationScreen> createState() =>
      _CommunityAdminLocationScreenState();
}

class _CommunityAdminLocationScreenState
    extends State<CommunityAdminLocationScreen> {
  late CommunityDetailsCubit communityCubit;

  final newLocationEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    newLocationEC.text = communityCubit.state.community?.locationStr ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    newLocationEC.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Location',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          TextButton(
              onPressed: () {
                if (newLocationEC.text.trim() == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select a location to be saved'),
                    ),
                  );
                } else {
                  print('SAVE');
                  communityCubit.updateLocation(
                      communityCubit.state.community?.id ?? '',
                      newLocationEC.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 15),
        width: double.infinity,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: DropdownSearchField(
                  items: [...kLocationList],
                  onChanged: (value) {
                    newLocationEC.text = value ?? '';
                  },
                  initialValue: newLocationEC.text,
                  placeholder: 'Type to search location',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
