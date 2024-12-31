import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityAdminDisplaynameScreen extends StatefulWidget {
  const CommunityAdminDisplaynameScreen({
    super.key,
  });

  @override
  State<CommunityAdminDisplaynameScreen> createState() =>
      _CommunityAdminDisplaynameScreenState();
}

class _CommunityAdminDisplaynameScreenState
    extends State<CommunityAdminDisplaynameScreen> {
  late CommunityDetailsCubit communityCubit;
  final newDisplaynameEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    newDisplaynameEC.text = communityCubit.state.community?.displayName ?? '';
  }

  @override
  void dispose() {
    newDisplaynameEC.dispose();
    super.dispose();
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
          AppLocalizations.of(context)!.community_display_name,
         // 'Community display name',
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
                if (newDisplaynameEC.text.trim() == '') {
                  ScaffoldMessenger.of(context).showSnackBar(
                     SnackBar(
                      content: Text(
                        AppLocalizations.of(context)!.select_a_display_name_to_be_saved,
                        //'Select a display name to be saved'
                        ),
                    ),
                  );
                } else {
                  communityCubit.updateDisplayName(
                      communityCubit.state.community?.id ?? '',
                      newDisplaynameEC.text.trim());
                  Navigator.of(context).pop();
                }
              },
              child: Text(
                 AppLocalizations.of(context)!.save,
               // 'Save',
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                height: 450,
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                margin: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  onChanged: (value) {},
                  controller: newDisplaynameEC,
                  decoration:  InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.your_community_name,
                    // 'your community name',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
