import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';

class CommunityAdminRadiusScreen extends StatefulWidget {
  const CommunityAdminRadiusScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<CommunityAdminRadiusScreen> createState() =>
      _CommunityAdminRadiusScreenState();
}

class _CommunityAdminRadiusScreenState
    extends State<CommunityAdminRadiusScreen> {
  late CommunityDetailsCubit communityCubit;

  final newRadiusEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);

    newRadiusEC.text = '${communityCubit.state.community?.radius ?? 0}';
  }

  @override
  void dispose() {
    super.dispose();
    newRadiusEC.dispose();
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
          'Radius',
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
                if (newRadiusEC.text.trim() == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select a radius to be saved'),
                    ),
                  );
                } else {
                  print('SAVE');
                  communityCubit.updateRadius(
                      communityCubit.state.community?.id ?? '',
                      double.parse(newRadiusEC.text.trim()));
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
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //
              //
              FlutterSlider(
                values: [double.parse(newRadiusEC.text)],
                max: kMaxRadius,
                min: kMinRadius,
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  setState(() {
                    newRadiusEC.text = '${lowerValue}';
                  });
                },
              ),
              //
              //
              Text(
                '  ${newRadiusEC.text} miles',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
              //               Text(
              //   'Current Value',
              //   style: TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.w500,
              //     color: Colors.grey
              //   ),
              // ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  'You can use this slider to increase and decrease the radius of your community',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
