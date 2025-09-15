import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import '../../../../l10n/app_localizations.dart';

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
  // INIT STATE
  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    newDisplaynameEC.text = communityCubit.state.community?.displayName ?? '';
  }

  // DISPOSE
  @override
  void dispose() {
    newDisplaynameEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.community_display_name,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.normal,
            fontSize: 18,
          ),
        ),
        centerTitle: false,
        actions: [
          BlocConsumer<CommunityDetailsCubit, CommunityDetailsState>(
            listener: (context, state) {
              // FAILURE STATE
              if (state.status == Status.failure) {
                showSnackBar(
                  context: context,
                  message:
                      state.failure?.message ?? 'oops something went wrong',
                );
              }
              // SUCCESS STATE
              if (state.status == Status.success) {
                communityCubit.getCommunityDetail(
                  communityCubit.state.community?.id ?? '',
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              // LOADING STATE
              if (state.status == Status.loading) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: CustomCircularIndicator(),
                );
              }
              return TextButton(
                onPressed: () {
                  if (newDisplaynameEC.text.trim() == '') {
                    showSnackBar(
                      context: context,
                      message: AppLocalizations.of(context)!
                          .select_a_display_name_to_be_saved,
                    );
                  } else {
                    communityCubit.updateDisplayName(
                      communityCubit.state.community?.id ?? '',
                      newDisplaynameEC.text.trim(),
                    );
                  }
                },
                child: Text(
                  AppLocalizations.of(context)!.save,
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          )
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
                height: 250,
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
                  onChanged: (value) {
                    // CAN BE ADD SOME CHECK POINT HERE
                  },
                  controller: newDisplaynameEC,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: AppLocalizations.of(context)!.your_community_name,
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
