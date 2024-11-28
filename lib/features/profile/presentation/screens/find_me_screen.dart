import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/shared_preference.dart';
import '../bloc/edit_profile_bloc/edit_profile_bloc.dart';
import '../bloc/get_profile_bloc/get_profile_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FindMeScreen extends StatefulWidget {
  const FindMeScreen({super.key});

  @override
  State<FindMeScreen> createState() => _FindMeScreenState();
}

class _FindMeScreenState extends State<FindMeScreen> {
  bool allowFindMe = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<GetProfileBloc>(context)
        .add(GetProfileButtonPressedEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          leading: InkWell(
            child: const Icon(Icons.arrow_back_ios, size: 20),
            onTap: () => context.pop(),
          ),
          title: Text(
            AppLocalizations.of(context)!.find_me,
            // 'Find Me',
            style: blackNormalTextStyle,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: AppColors.whiteColor,
            ),
            child: BlocConsumer<GetProfileBloc, GetProfileState>(
              listener: (context, state) {
                if (state is GetProfileSuccessState) {
                  setState(() {
                    allowFindMe = state.profile.findMe!;
                  });
                }
              },
              builder: (context, state) {
                if (state is GetProfileSuccessState) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(
                        'assets/find-me2.svg',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.find_me,
                              // 'Find me',
                              style: blackonboardingBody2Style,
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              AppLocalizations.of(context)!
                                  .you_will_automatically_join_the_community_group_when_it_is_created,
                              // 'You will automatically join the community group when it is created.',
                              style: mediumGreyTextStyleBlack,
                              softWrap: true,
                            ),
                          ],
                        ),
                      ),
                      BlocListener<EditProfileBloc, EditProfileState>(
                        listener: (context, state) {
                          if (state is EditProfileSuccessState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(AppLocalizations.of(context)!
                                    .find_me_updated_successfully),
                                // content: Text('Find me updated successfully'),
                                backgroundColor: AppColors.greenColor,
                              ),
                            );
                          } else if (state is EditProfileFailureState) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(state.error),
                                backgroundColor: AppColors.redColor,
                              ),
                            );
                          }
                        },
                        child: Switch(
                          value: allowFindMe,
                          onChanged: (value) {
                            setState(() {
                              allowFindMe = value;
                            });
                            String? userName = ShardPrefHelper.getUsername();
                            String? gender = ShardPrefHelper.getGender();
                            print('find Me $allowFindMe');

                            BlocProvider.of<EditProfileBloc>(context).add(
                              EditProfileButtonPressedEvent(
                                toggleFindMe: allowFindMe,
                                username: userName ?? 'Default User',
                                gender: gender ?? 'Male',
                              ),
                            );
                          },
                          inactiveThumbColor: AppColors.whiteColor,
                          inactiveTrackColor: AppColors.greyColor,
                          activeTrackColor: AppColors.primaryColor,
                          activeColor: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
