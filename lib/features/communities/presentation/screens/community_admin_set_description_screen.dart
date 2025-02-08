import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:neighborly_flutter_app/core/constants/status.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import '../../../../core/theme/colors.dart';
import '../bloc/community_detail_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommunityAdminDescriptionScreen extends StatefulWidget {
  const CommunityAdminDescriptionScreen({
    super.key,
  });

  @override
  State<CommunityAdminDescriptionScreen> createState() =>
      _CommunityAdminDescriptionScreenState();
}

class _CommunityAdminDescriptionScreenState
    extends State<CommunityAdminDescriptionScreen> {
  late CommunityDetailsCubit communityCubit;
  final newDescriptionEC = TextEditingController();

  @override
  void initState() {
    super.initState();
    communityCubit = BlocProvider.of<CommunityDetailsCubit>(context);
    newDescriptionEC.text = communityCubit.state.community?.description ?? '';
  }

  @override
  void dispose() {
    newDescriptionEC.dispose();
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
          AppLocalizations.of(context)!.description,
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
              if (state.status == Status.failure) {
                showSnackBar(
                  context: context,
                  message:
                      state.failure?.message ?? 'oops something went wrong',
                );
              }
              if (state.status == Status.success) {
                communityCubit.getCommunityDetail(
                  communityCubit.state.community?.id ?? '',
                );
                Navigator.of(context).pop();
              }
            },
            builder: (context, state) {
              if (state.status == Status.loading) {
                return Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: BouncingLogoIndicator(logo: ''),
                );
              }
              return TextButton(
                onPressed: () {
                  if (newDescriptionEC.text.trim() == '') {
                    showSnackBar(
                      context: context,
                      message: AppLocalizations.of(context)!
                          .select_a_description_to_be_saved,
                    );
                  } else {
                    communityCubit.updateDescription(
                      communityCubit.state.community?.id ?? '',
                      newDescriptionEC.text.trim(),
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
          ),
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
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {},
                  controller: newDescriptionEC,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText:
                        AppLocalizations.of(context)!.describe_your_community,
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
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
