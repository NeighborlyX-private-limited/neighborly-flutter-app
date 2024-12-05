import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import '../../../../core/constants/status.dart';
import '../../../posts/presentation/widgets/toggle_button_widget.dart';
import '../bloc/communities_main_cubit.dart';
import '../widgets/community_card_widget.dart';
import '../widgets/community_sheemer.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen({super.key});
  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen> {
  late CommunityMainCubit communityMainCubit;
  bool isNearBy = false;
  bool isSummary = true;

  ///init state method
  @override
  void initState() {
    super.initState();
    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    communityMainCubit.init();
  }

  ///handle toggle method for fetching groups
  void handleToggle(bool value) {
    setState(() {
      isNearBy = value;
    });

    communityMainCubit.updateNearBy(!value);
  }

  ///handle toggle is summary
  void handleToggleIsSummary(bool value) {
    setState(() {
      isSummary = value;
      communityMainCubit.updateIsSummary(value, !isNearBy);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        appBar: AppBar(
          backgroundColor: AppColors.whiteColor,
          title: Row(
            children: [
              ///app logo
              SvgPicture.asset(
                'assets/logo.svg',
                width: 30,
                height: 34,
              ),
              const SizedBox(width: 10),

              ///toggle button
              CustomToggleSwitch(
                imagePath1: 'assets/home.svg',
                imagePath2: 'assets/location.svg',
                onToggle: handleToggle,
              ),
            ],
          ),
          actions: [
            ///search icon
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  context.push('/groups/search');
                },
                child: SvgPicture.asset(
                  'assets/search.svg',
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                ),
              ),
            ),

            ///chat icon
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  context.push('/chat');
                },
                child: SvgPicture.asset(
                  'assets/chat.svg',
                  fit: BoxFit.contain,
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<CommunityMainCubit, CommunityMainState>(
          bloc: communityMainCubit,
          listener: (context, state) {
            switch (state.status) {
              ///loading state
              case Status.loading:
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) =>
                      const Center(child: CircularProgressIndicator()),
                );
                print('loading state in listner');
                break;

              /// failure state
              case Status.failure:
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      '${state.errorMessage}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.red,
                    duration: const Duration(seconds: 3),
                  ),
                );
                print('failure state in listner');

                break;

              /// success state
              case Status.success:
                print('success state in listner');
                break;

              /// initial  state
              case Status.initial:
                print('initial state in listner');
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<CommunityMainCubit, CommunityMainState>(
              bloc: communityMainCubit,
              builder: (context, state) {
                ///loading state in builder
                if (state.status == Status.loading) {
                  print('loading in builder');
                  return const CommunityMainSheemer();
                }

                if (state.status == Status.success &&
                    state.communities.isNotEmpty) {
                  print('success and isNotEmpty in builder');
                  // return CommunityEmptyWidget();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      int crossAxisCount = 2;
                      if (constraints.maxWidth >= 600) {
                        crossAxisCount = 3;
                      } else if (constraints.maxWidth >= 900) {
                        crossAxisCount = 4;
                      }
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: Container(
                          color: AppColors.whiteColor,
                          child: Column(
                            children: [
                              const SizedBox(height: 5),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      isSummary ? 'Summary' : 'All Groups',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        handleToggleIsSummary(!isSummary);
                                      },
                                      child: Text(
                                        isSummary ? 'See all' : 'See less',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Color(0xff635BFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: crossAxisCount,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                    childAspectRatio: 1 / 1.5,
                                  ),
                                  itemCount: state.communities.length,
                                  itemBuilder: (context, index) {
                                    return CommunityCardWidget(
                                      community: state.communities[index],
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }

                if (state.communities.isNotEmpty &&
                    state.status != Status.initial) {
                  return Text('empty');
                }

                return Text('No Data');
              },
            );
          },
        ),
      ),
    );
  }
}
