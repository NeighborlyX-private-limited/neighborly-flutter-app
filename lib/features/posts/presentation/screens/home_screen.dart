import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/colors.dart';
import '../../../../core/theme/text_style.dart';
import '../../../authentication/presentation/widgets/button_widget.dart';
import '../../../homePage/widgets/dob_picker_widget.dart';
import '../../../profile/presentation/bloc/get_gender_and_DOB_bloc/get_gender_and_DOB_bloc.dart';
import '../bloc/get_all_posts_bloc/get_all_posts_bloc.dart';
import '../widgets/poll_widget.dart';
import '../widgets/post_sheemer_widget.dart';
import '../widgets/post_widget.dart';
import '../widgets/toggle_button_widget.dart';

class HomeScreen extends StatefulWidget {
  final bool isFirstTime;
  const HomeScreen({super.key, required this.isFirstTime});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isHome = true;

  @override
  void initState() {
    super.initState();
    _fetchPosts();
    if (widget.isFirstTime) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showBottomSheet(context);
      });
    }
  }

  void _fetchPosts() {
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome)); // Use isHome state
  }

  Future<void> _onRefresh() async {
    BlocProvider.of<GetAllPostsBloc>(context)
        .add(GetAllPostsButtonPressedEvent(isHome: isHome)); // Use isHome state
  }

  void handleToggle(bool value) {
    setState(() {
      isHome = value;
    });

    _fetchPosts(); // Fetch posts based on the new isHome value
  }

  String formatDOB(String day, String month, String year) {
    year = year.length == 2 ? '20$year' : year;
    year = int.parse(year) > 2021 ? '2021' : year;
    month = month.length == 1 ? '0$month' : month;
    month = int.parse(month) > 12 ? '12' : month;
    day = int.parse(day) > 31 ? '31' : day;
    day = day.length == 1 ? '0$day' : day;
    return '$year-$month-$day';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/logo.svg',
              width: 30,
              height: 34,
            ),
            const SizedBox(width: 10),
            CustomToggleSwitch(
              imagePath1: 'assets/home.svg',
              imagePath2: 'assets/location.svg',
              onToggle: handleToggle, // Pass the callback function
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                context.push('/notifications');
              },
              child: badges.Badge(
                badgeContent: Text(
                  '3', // TODO: this came from a checked still not maked
                  style: TextStyle(color: Colors.white),
                ),
                badgeStyle: BadgeStyle(badgeColor: AppColors.primaryColor),
                position: badges.BadgePosition.custom(end: 0, top: -8),
                child: SvgPicture.asset(
                  'assets/alarm.svg',
                  fit: BoxFit.contain,
                  width: 30, // Adjusted to fit within the AppBar
                  height: 30,
                ),
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
          builder: (context, state) {
            if (state is GetAllPostsLoadingState) {
              return const PostSheemerWidget();
            } else if (state is GetAllPostsSuccessState) {
              final posts = state.post;
              return posts.isEmpty
                  ? InkWell(
                      onTap: () {
                        context.go('/create');
                      },
                      child: Text(
                        'Create your first post',
                        style: bluemediumTextStyleBlack,
                      ),
                    )
                  : ListView.separated(
                      itemCount: posts.length,
                      itemBuilder: (context, index) {
                        final post = posts[index];
                        if (post.type == 'post') {
                          return PostWidget(
                            post: post,
                          );
                        } else if (post.type == 'poll') {
                          return PollWidget(
                            post: post,
                          );
                        }
                        return const SizedBox();
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Padding(
                          padding: EdgeInsets.only(bottom: 10.0),
                        );
                      },
                    );
            } else if (state is GetAllPostsFailureState) {
              if (state.error.contains('Invalid Token')) {
                context.go('/loginScreen');
              }
              if (state.error.contains('Internal server error')) {
                return const Center(
                    child: Text(
                  'Server Error',
                  style: TextStyle(color: Colors.red),
                ));
              }
              return Center(child: Text(state.error));
            } else {
              return const Center(
                child: Text('No data'),
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> showBottomSheet(BuildContext context) {
    // String selectedGender = 'male';
    TextEditingController dateController = TextEditingController();
    TextEditingController monthController = TextEditingController();
    TextEditingController yearController = TextEditingController();

    return showModalBottomSheet<num>(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return DraggableScrollableSheet(
              expand: false,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 40,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xffB8B8B8),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Center(
                          child: Text(
                            'One last thing before we get started!!',
                            style: onboardingHeading2Style,
                          ),
                        ),
                        // const SizedBox(height: 25),
                        // Text('1. Select your Gender',
                        //     style: blackonboardingBody1Style),
                        // const SizedBox(height: 8),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: <Widget>[
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Male',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Male'),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Female',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Female'),
                        //       ],
                        //     ),
                        //     Row(
                        //       children: [
                        //         Radio<String>(
                        //           value: 'Others',
                        //           groupValue: selectedGender,
                        //           onChanged: (String? value) {
                        //             setState(() {
                        //               selectedGender = value!;
                        //             });
                        //           },
                        //         ),
                        //         const Text('Others'),
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        const Divider(color: Colors.grey),
                        Text('Date of Birth', style: blackonboardingBody1Style),
                        const SizedBox(height: 8),
                        DOBPickerWidget(
                          dateController: dateController,
                          monthController: monthController,
                          yearController: yearController,
                          isDayFilled: true,
                          isMonthFilled: true,
                          isYearFilled: true,
                        ),
                        const SizedBox(height: 45),
                        BlocConsumer<GetGenderAndDOBBloc, GetGenderAndDOBState>(
                          listener: (BuildContext context,
                              GetGenderAndDOBState state) {
                            if (state is GetGenderAndDOBFailureState) {
                              if (state.error
                                  .contains('DOB can only be set once.')) {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text(
                                          'User Info saved successfully.')),
                                );
                              } else {
                                context.pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(state.error)),
                                );
                              }
                            } else if (state is GetGenderAndDOBSuccessState) {
                              print('User Info saved successfully.');
                              context.pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('User Info saved successfully.')),
                              );
                            }
                          },
                          builder: (context, state) {
                            if (state is GetGenderAndDOBLoadingState) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            return ButtonContainerWidget(
                              isActive: true,
                              color: AppColors.primaryColor,
                              text: 'Save',
                              isFilled: true,
                              onTapListener: () {
                                BlocProvider.of<GetGenderAndDOBBloc>(context)
                                    .add(
                                  GetGenderAndDOBButtonPressedEvent(
                                    dob: formatDOB(
                                      dateController.text.trim(),
                                      monthController.text.trim(),
                                      yearController.text.trim(),
                                    ),
                                    // gender: selectedGender,
                                  ),
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
