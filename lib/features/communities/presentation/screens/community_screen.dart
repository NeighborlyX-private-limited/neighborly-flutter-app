import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
  late var communityMainCubit;
  bool isNearBy = false;
  bool isSummary = true;

  @override
  void initState() {
    print('... COMMUNITY MAIN - init');
    super.initState();

    communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);

    communityMainCubit.init();
  }

  void handleToggle(bool value) {
    setState(() {
      isNearBy = value;
    });

    communityMainCubit.updateNearBy(!value);
  }

  void handleToggleIsSummary(bool value) {
    setState(() {
      isSummary = value;
      communityMainCubit.updateIsSummary(value, !isNearBy);
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    // communityMainCubit = BlocProvider.of<CommunityMainCubit>(context);
    return SafeArea(
      child: Scaffold(
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
              child: InkWell(
                onTap: () {
                  context.push('/groups/search');
                },
                child: SvgPicture.asset(
                  'assets/search.svg',
                  fit: BoxFit.contain,
                  width: 30, // Adjusted to fit within the AppBar
                  height: 30,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: InkWell(
                onTap: () {
                  context.push('/chat');
                },
                child: SvgPicture.asset(
                  'assets/chat.svg',
                  fit: BoxFit.contain,
                  width: 30, // Adjusted to fit within the AppBar
                  height: 30,
                ),
              ),
            ),
          ],
        ),
        body: BlocConsumer<CommunityMainCubit, CommunityMainState>(
          bloc: communityMainCubit,
          listener: (context, state) {
            print('... state.currentUser: ${state.status}');

            switch (state.status) {
              case Status.loading:
                break;
              case Status.failure:
                // hideLoader();
                // showError(state.errorMessage ?? 'Some error');
                print('ERROR ${state.failure?.message}');
                break;
              case Status.success:
                break;
              case Status.initial:
                break;
            }
          },
          builder: (context, state) {
            return BlocBuilder<CommunityMainCubit, CommunityMainState>(
              bloc: communityMainCubit,
              builder: (context, state) {
                if (state.status == Status.loading) {
                  return const CommunityMainSheemer();
                }

                if (state.communities.isNotEmpty) {
                  // return CommunityEmptyWidget();

                  return LayoutBuilder(builder: (context, constraints) {
                    int crossAxisCount = 2;

                    if (constraints.maxWidth >= 600) {
                      crossAxisCount = 3;
                    } else if (constraints.maxWidth >= 900) {
                      crossAxisCount = 4;
                    }

                    return Padding(
                        padding: EdgeInsets.all(10),
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
                                        fontSize: 20),
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
                                        crossAxisCount:
                                            crossAxisCount, // Número de colunas
                                        crossAxisSpacing:
                                            10.0, // Espaçamento horizontal entre os itens
                                        mainAxisSpacing:
                                            10.0, // Espaçamento vertical entre os itens
                                        childAspectRatio: 1 / 1.5),
                                itemCount: state.communities.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: CommunityCardWidget(
                                      community: state.communities[index],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ));
                  });
                }

                if (state.communities.isNotEmpty &&
                    state.status != Status.initial) {
                  return Text('empty');
                }

                return Text('...');
              },
            );
          },
        ),
      ),
    );
  }
}
