import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';

import '../../../../core/models/community_model.dart';
import '../../../../core/widgets/stacked_avatar_indicator_widget.dart';

class CommunityCardWidget extends StatelessWidget {
  final CommunityModel community;
  const CommunityCardWidget({
    super.key,
    required this.community,
  });

  void openCommunity(BuildContext context) {
    // Navigator.of(context).push(
    //   MaterialPageRoute(
    //     builder: (BuildContext context) {
    //       return CommunityDetailsScreen(
    //         community: this.community,
    //       );
    //     },
    //   ),
    // );

    context.push('/groups/${community.id}');
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        openCommunity(context);
      },
      child: Card(
        elevation: 7,
        child: Container(
          height: 150,
          width: 125,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(10),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: CachedNetworkImageProvider(community.avatarUrl),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Container(
                      height: 19,
                      // width: double.infinity,
                      decoration: BoxDecoration(
                        // color: Colors.black.withOpacity(0.7),
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                community.isPublic
                                    ? Icons.public
                                    : Icons.lock_person_outlined,
                                color: Colors.white,
                                size: 15,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                community.isPublic ? 'Public' : 'Private',
                                // textAlign: TextAlign.center,

                                style: TextStyle(
                                  height: 0.5,
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Container(
                decoration: BoxDecoration(
                  // color: Colors.green,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.4),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.8),
                      Colors.black.withOpacity(0.9),
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Text(
                        community.name,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StackedAvatarIndicator(
                            avatarUrls: community.users
                                .map((e) => e.avatarUrl)
                                .toList(),
                            showOnly: 3,
                            avatarSize: 22,
                            onTap: () {},
                          ),
                          Expanded(
                            child: Text(
                              '${community.users.length}k+ Members',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 35,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xff635BFF),
                              borderRadius: BorderRadius.circular(20)),
                          child: Center(
                            child: Text(
                              community.isPublic ? 'Join' : 'Request',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
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
