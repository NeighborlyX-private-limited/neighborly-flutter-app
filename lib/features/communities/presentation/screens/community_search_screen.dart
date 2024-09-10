import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/status.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/models/user_simple_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import '../bloc/communities_search_cubit.dart';
import '../widgets/community_details_sheemer.dart';
import '../widgets/community_search_empty_widget.dart';
import '../widgets/search_ahead_widget.dart';

class CommunitySearchScreen extends StatefulWidget {
  const CommunitySearchScreen({super.key});

  @override
  State<CommunitySearchScreen> createState() => _CommunitySearchScreenState();
}

class _CommunitySearchScreenState extends State<CommunitySearchScreen> {
  late var communitySearchCubit;
  bool showDashInfo = true;

  final searchTermEC = TextEditingController();

  @override
  void initState() {
    super.initState();

    communitySearchCubit = BlocProvider.of<CommunitySearchCubit>(context);
    communitySearchCubit.init();
  }

  @override
  void dispose() {
    super.dispose();
    searchTermEC.dispose();
  }

  void handleSearchTermSelection(String searchTermFromHistory) {
    print('jump to same search');
    communitySearchCubit.getSearchResultBySumit(searchTermFromHistory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: SearchAheadElement(
          showTitle: true,
          isDarkmode: false,
          lintText: 'Search',
          icon: Icons.search,
          onSearchTextChange: (currentStrSearchValue) {
            print('... currentStrSearchValue=${currentStrSearchValue}');
            print('... SHOW? ${(currentStrSearchValue == '')}');
            // if (currentStrSearchValue == '') {
            setState(() {
              showDashInfo = currentStrSearchValue == '';
            });
            // }

            if (currentStrSearchValue == '') {
              communitySearchCubit.cleanSearchTerm();
            }
          },
          onFocusChange: (newFocusValie) {
            print('... newFocusValie=${newFocusValie}');
          },
          onSuggestionSelected: (selectedItem) {
            // widget.onSuggestionSelected(selectedItem);
          },
          suggestionCallback: (userSearchCriteria) async {
            if (userSearchCriteria.trim().length < 3) return [];

            var results = await communitySearchCubit
                .suggestionCallback(userSearchCriteria);

            if (results.length > 0) {
              setState(() {
                showDashInfo = false;
              });
            }
            return results;
          },
          onSubmit: (searchTerm) {
            print('... SEARCH = $searchTerm');
            communitySearchCubit.getSearchResultBySumit(searchTerm);
          },
          showBackButton: true,
        ),
      ),
      body: BlocConsumer<CommunitySearchCubit, CommunitySearchState>(
        listener: (context, state) {
          switch (state.status) {
            case Status.loading:
              break;
            case Status.failure:
              print('ERROR ${state.failure?.message}');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('Something went wrong! ${state.failure?.message}'),
                ),
              );
              break;
            case Status.success:
              break;
            case Status.initial:
              break;
          }
        },
        builder: (context, state) {
          return BlocBuilder<CommunitySearchCubit, CommunitySearchState>(
            bloc: communitySearchCubit,
            builder: (context, state) {
              //
              //
              if (state.status == Status.loading) {
                return const CommunityDetailsSheemer(); // CommunitySearchSheemer
              }

              //
              // RESULTS by submit/enter
              if (state.searchTerm != '' && state.status != Status.loading) {
                if (state.communities.length == 0 && state.people.length == 0)
                  return CommunitySearchEmptyWidget(
                    searchTem: state.searchTerm,
                  );

                return ResultArea(
                  communities: state.communities,
                  people: state.people,
                  onSelect: (selected) {
                    print(
                        'JUMP TO...${selected is CommunityModel ? "Community" : "Profile info"}');

                    if (selected is CommunityModel) {
                      Navigator.of(context).pop();
                      context.push('/groups/${selected.id}');
                    } else {
                      Navigator.of(context).pop();
                      context.push('/userProfileScreen/${selected.id}');
                    }
                  },
                );
              }

              //
              //
              return Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      //
                      //
                      if (showDashInfo && state.dashData?.history != null)
                        HistoryListArea(
                          terms: state.histories,
                          onDelete: (toDeleteTerm) {
                            communitySearchCubit
                                .deleteHistoryTerm(toDeleteTerm);
                          },
                          onSelect: (historyTerm) {
                            // communitySearchCubit.deleteHistoryTerm(toDeleteTerm);
                            handleSearchTermSelection(historyTerm);
                          },
                        ),
                      const SizedBox(height: 20),
                      //
                      //
                      if (showDashInfo && state.dashData?.trending != null)
                        TrendListArea(
                          communities: state.dashData!.trending,
                          onSelect: (communityId) {
                            // communitySearchCubit.deleteHistoryTerm(toDeleteTerm);
                            Navigator.of(context).pop();
                            context.push('/groups/${communityId}');
                          },
                        ),
                      //
                      //
                      //
                      //
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ###############################################################
// ###############################################################
// ###############################################################

class HistoryListArea extends StatelessWidget {
  final List<String> terms;
  final Function(String) onDelete;
  final Function(String) onSelect;
  const HistoryListArea({
    Key? key,
    required this.terms,
    required this.onDelete,
    required this.onSelect,
  }) : super(key: key);

  Widget historyTile(String term) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/mdi_recent.svg',
            fit: BoxFit.contain,
            width: 30, // Adjusted to fit within the AppBar
            height: 30,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
                child: InkWell(
                    onTap: () {
                      onSelect(term);
                    },
                    child: Text(
                      term,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ))),
          ),
          GestureDetector(
              onTap: () {
                onDelete(term);
              },
              child: Icon(Icons.close)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (terms.length == 0) return SizedBox.shrink();

    return Container(
      color: Colors.white,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: terms.length,
        itemBuilder: (context, index) => historyTile(terms[index]),
      ),
    );
  }
}

// ###############################################################
// ###############################################################
// ###############################################################

class TrendListArea extends StatelessWidget {
  final List<CommunityModel> communities;
  final Function(String) onSelect;
  const TrendListArea({
    Key? key,
    required this.communities,
    required this.onSelect,
  }) : super(key: key);

  Widget trendTile(CommunityModel community) {
    return Container(
      padding: EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        children: [
          UserAvatarStyledWidget(
            avatarUrl: community.avatarUrl,
            avatarSize: 22,
            avatarBorderSize: 0,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              child: InkWell(
                  onTap: () {
                    onSelect(community.id);
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        '${community.membersCount} Members',
                        style: TextStyle(fontWeight: FontWeight.normal),
                      ),
                    ],
                  )),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (communities.length == 0) return SizedBox.shrink();

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Trending Communities',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: communities.length,
            itemBuilder: (context, index) => trendTile(communities[index]),
          ),
        ],
      ),
    );
  }
}

// ###############################################################
// ###############################################################
// ###############################################################

class ResultArea extends StatefulWidget {
  final List<CommunityModel> communities;
  final List<UserSimpleModel> people;
  final Function(dynamic) onSelect; // type is CommunityModel or UserSimpleModel
  const ResultArea({
    Key? key,
    required this.communities,
    required this.people,
    required this.onSelect,
  }) : super(key: key);

  @override
  State<ResultArea> createState() => _ResultAreaState();
}

class _ResultAreaState extends State<ResultArea>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget resultTile(dynamic resultLine) {
    return InkWell(
      onTap: () {
        widget.onSelect(resultLine);
      },
      child: Container(
        padding: EdgeInsets.all(12),
        width: double.infinity,
        color: Colors.white,
        child: Row(
          children: [
            UserAvatarStyledWidget(
              avatarUrl: resultLine is CommunityModel
                  ? resultLine.avatarUrl
                  : (resultLine as UserSimpleModel).avatarUrl,
              avatarSize: 22,
              avatarBorderSize: 0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    resultLine.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 7),
                  Text(
                    resultLine is CommunityModel
                        ? '${resultLine.membersCount} Members'
                        : '${resultLine.karma} Karma',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              )),
            ),
            if (resultLine is CommunityModel) ...[
              ElevatedButton(
                onPressed: () {
                  // Lógica ao clicar no botão
                  // context.go('/groups/create');
                  print('JOIN');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        50), // Ajuste o raio conforme necessário
                  ),
                  // padding: EdgeInsets.all(15)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 1),
                  child: Text(
                    'Join',
                    style: TextStyle(
                        color: Colors.white, fontSize: 18, height: 0.3),
                  ),
                ),
              )
            ]
          ],
        ),
      ),
    );
  }

  Widget tabTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          // color: Colors.black,
        ),
      ),
    );
  }

  Widget listArea(List<dynamic> list) {
    if (list.length == 0) return Text('vazio');

    return Container(
      color: Colors.white,
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) => resultTile(list[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.communities.length == 0) return SizedBox.shrink();

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          //
          //
          const SizedBox(height: 15),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 0, right: 5),
              child: TabBar(
                indicatorColor: AppColors.primaryColor,
                unselectedLabelColor: Colors.grey,
                unselectedLabelStyle: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: Colors.grey,
                ),

                // labelColor: AppColors.primaryColor.withOpacity(0.8),
                controller: _tabController,
                tabAlignment: TabAlignment.start,
                isScrollable: true,
                // labelPadding: EdgeInsets.only(left: 0, right: 20),
                tabs: [
                  Tab(child: tabTitle('Communities')),
                  Tab(child: tabTitle('People')),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                //
                //
                listArea(widget.communities),
                //
                //
                listArea(widget.people),
                //
                //
              ],
            ),
          ),
          //
          //
        ],
      ),
    );
  }
}
