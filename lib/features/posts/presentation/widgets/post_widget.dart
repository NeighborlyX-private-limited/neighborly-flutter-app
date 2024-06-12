import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/text_style.dart';
import 'package:neighborly_flutter_app/core/utils/helpers.dart';
import 'package:neighborly_flutter_app/features/posts/domain/entities/post_enitity.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/reaction_widget.dart';

class PostWidget extends StatelessWidget {
  final PostEntity post;
  const PostWidget({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    void showBottomSheet() {
      bottomSheet(context);
    }

    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    return InkWell(
      onTap: () {
        context.push('/post-detail');
      },
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/first_pro_pic.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              post.userName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Container(
                              width: 4,
                              height: 4,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              formatTimeDifference(post.createdAt),
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          'United States',
                          style: TextStyle(
                              fontWeight: FontWeight.w400,
                              color: Colors.grey[500],
                              fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    showBottomSheet();
                  },
                  child: Icon(
                    Icons.more_horiz,
                    size: 30,
                    color: Colors.grey[500],
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              post.content,
              textAlign: TextAlign.start,
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 15,
                height: 1.3,
              ),
            ),
            post.multimedia != null
                ? const SizedBox(
                    height: 10,
                  )
                : Container(),
            post.multimedia != null
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: Image.network(
                          width: double.infinity,
                          height: 200,
                          post.multimedia!,
                          fit: BoxFit.cover,
                        )),
                  )
                : Container(),
            const SizedBox(
              height: 20,
            ),
            ReactionWidget(
              second: true,
              third: true,
              post: post,
            )
          ],
        ),
      ),
    );
  }

  Future<dynamic> bottomSheet(BuildContext context) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 90,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: InkWell(
            onTap: () {
              showReportReasonBottomSheet();
            },
            child: Row(
              children: [
                Image.asset('assets/report_flag.png'),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  'Report',
                  style: redOnboardingBody1Style,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          height: 200,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              Image.asset('assets/report_confirmation.png'),
              Text(
                'Thanks for letting us know',
                style: onboardingHeading2Style,
              ),
              Text(
                'We appreciate your help in keeping our community safe and respectful. Our team will review the content shortly.',
                style: blackonboardingBody1Style,
              ),
            ],
          ),
        );
      },
    );
  }

  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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
                const SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Reason to Report',
                    style: onboardingHeading2Style,
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reason One',
                      style: blackonboardingBody1Style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reason Two',
                      style: blackonboardingBody1Style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reason Three',
                      style: blackonboardingBody1Style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reason Four',
                      style: blackonboardingBody1Style,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Reason Five',
                      style: blackonboardingBody1Style,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
