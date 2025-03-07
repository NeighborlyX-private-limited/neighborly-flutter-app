// post/poll--> cheer,boo,comment, award
// comments--> cheer,boo, reply,award
// reply -->  cheer,boo, awards

// post, group --> creation
// group --> creation of group, edit group details, join request, in need group id
// message--> new message--> for now it will receive to all users, i need group id,

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/theme/colors.dart';
import 'package:neighborly_flutter_app/core/widgets/custom_snackbar.dart';
import 'package:neighborly_flutter_app/core/widgets/indicator/custom_circular_progress_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/image_slider.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/widgets/video_widget.dart';
import '../../../../core/entities/option_entity.dart';
import '../../../../core/entities/post_enitity.dart';
import '../../../../core/theme/text_style.dart';
import '../../../../core/utils/helpers.dart';
import '../../../../core/utils/shared_preference.dart';
import '../../data/model/comments_model.dart';
import '../../domain/entities/comment_entity.dart';
import '../../domain/entities/reply_entity.dart';
import '../bloc/add_comment_bloc/add_comment_bloc.dart';
import '../bloc/delete_post_bloc/delete_post_bloc.dart';
import '../bloc/get_comments_by_postId_bloc/get_comments_by_postId_bloc.dart';
import '../bloc/get_post_by_id_bloc/get_post_by_id_bloc.dart';
import '../bloc/report_post_bloc/report_post_bloc.dart';
import '../widgets/comment_widget.dart';
import '../widgets/option_card.dart';
import '../widgets/post_detail_sheemer.dart';
import '../widgets/reaction_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDetailScreen extends StatefulWidget {
  //final String userId;
  final String postId;
  //final String commentId;
  // final bool isPost;

  const PostDetailScreen({
    super.key,
    // required this.userId,
    required this.postId,
    // required this.commentId,
    // required this.isPost,
  });

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late TextEditingController _commentController;
  late FocusNode _commentFocusNode;
  PostEntity? postEntity;

  bool isCommentFilled = false;
  bool isrefresh = false;
  List<dynamic> comments = [];
  dynamic commentToReply;

  // INIT STATE
  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _commentFocusNode = FocusNode();
    _fetchPostAndComments();
  }

  // DISPOSE
  @override
  void dispose() {
    _commentController.dispose();
    _commentFocusNode.dispose();
    super.dispose();
  }

  // FEATCH POST AND COMMENTS OF THAT POST
  void _fetchPostAndComments() {
    final postId = int.parse(widget.postId);
    BlocProvider.of<GetPostByIdBloc>(context).add(
      GetPostByIdButtonPressedEvent(postId: postId),
    );
    BlocProvider.of<GetCommentsByPostIdBloc>(context).add(
      GetCommentsByPostIdButtonPressedEvent(
        postId: postId,
        commentId: '',
      ),
    );
  }

  // REFRESH
  Future<void> _onRefresh() async {
    final postId = int.parse(widget.postId);
    BlocProvider.of<GetPostByIdBloc>(context).add(
      GetPostByIdButtonPressedEvent(postId: postId),
    );
    BlocProvider.of<GetCommentsByPostIdBloc>(context).add(
      GetCommentsByPostIdButtonPressedEvent(
        postId: postId,
        commentId: '',
      ),
    );
  }

  // WHEN USER TAP ON REPLY BUTTON
  void _handleReplyTap(dynamic commentOrReply) {
    setState(() {
      commentToReply = commentOrReply;
    });
  }

  // BUILD
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        context.pop();
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          // APPBAR
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            leading: InkWell(
              child: const Icon(
                Icons.arrow_back_ios,
              ),
              onTap: () => context.pop(),
            ),
            centerTitle: true,
            title: BlocBuilder<GetPostByIdBloc, GetPostByIdState>(
              builder: (context, state) {
                if (state is GetPostByIdSuccessState) {
                  return Text(
                    state.post.type == 'post'
                        ? AppLocalizations.of(context)!.post
                        : AppLocalizations.of(context)!.poll,
                    style: onboardingHeading2Style,
                  );
                }
                return Text('');
              },
            ),
          ),

          // BODY
          body: RefreshIndicator(
            onRefresh: _onRefresh,
            // GET POST BY POST ID
            child: BlocConsumer<GetPostByIdBloc, GetPostByIdState>(
              listener: (BuildContext context, GetPostByIdState state) {
                // GET POST BY POST ID SUCCESS STATE
                if (state is GetPostByIdSuccessState) {
                  if (state.post.type == 'poll') {
                    postEntity = state.post;
                  }
                }
              },
              builder: (context, postState) {
                // GET POST BY POST ID LOADING STATE
                if (postState is GetPostByIdLoadingState) {
                  return const PostDetailSheemer();
                }

                // GET POST BY POST ID FAILURE STATE
                if (postState is GetPostByIdFailureState) {
                  // postState.
                  return SomethingWentWrong(
                    imagePath: 'assets/not_found.svg',
                    title:
                        AppLocalizations.of(context)!.aaah_something_went_wrong,
                    message: AppLocalizations.of(context)!.post_not_found,
                    buttonText: AppLocalizations.of(context)!.go_back,
                    onButtonPressed: () {
                      context.pop();
                    },
                  );
                }

                // GET POST BY POST ID SUCCESS STATE
                if (postState is GetPostByIdSuccessState) {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.all(16.0),
                          children: [
                            postState.post.type == 'post'
                                // widget.isPost
                                ? _buildPostDetails(postState.post)
                                : _buildPollWidget(postState),
                            const SizedBox(height: 20),
                            ReactionWidget(post: postState.post),
                            const SizedBox(height: 10),
                            Divider(color: Colors.grey[300], thickness: 1),
                            const SizedBox(height: 20),

                            // GET COMMENTS BY POST ID
                            BlocBuilder<GetCommentsByPostIdBloc,
                                GetCommentsByPostIdState>(
                              builder: (context, commentState) {
                                // GET COMMENTS BY POST ID FAILURE STATE
                                if (commentState
                                    is GetcommentsByPostIdFailureState) {
                                  return Center(
                                    child: Text(commentState.error),
                                  );
                                }
                                // GET COMMENTS BY POST ID SUCCESS STATE AND 0 COMMENTS
                                if (commentState
                                    is GetcommentsByPostIdSuccessState) {
                                  comments = commentState.comments;
                                  if (comments.isEmpty) {
                                    return Center(
                                      child: Text(
                                        AppLocalizations.of(context)!
                                            .no_comments_yet,
                                      ),
                                    );
                                  }
                                  // GET COMMENTS BY POST ID SUCCESS STATE AND 0+ COMMENTS
                                  return ListView.separated(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: comments.length,
                                    itemBuilder: (context, index) {
                                      return CommentWidget(
                                        commentFocusNode: _commentFocusNode,
                                        comment: comments[index],
                                        onReplyTap: _handleReplyTap,
                                        isPost: postState.post.type == 'post',
                                        // isPost: widget.isPost,
                                        onDelete: () {
                                          context
                                              .read<GetCommentsByPostIdBloc>()
                                              .deleteComment(
                                                comments[index].commentid,
                                              );
                                        },
                                      );
                                    },
                                    separatorBuilder: (context, index) =>
                                        const SizedBox(height: 10),
                                  );
                                }

                                return const SizedBox();
                              },
                            ),
                          ],
                        ),
                      ),

                      // COMMENT INPUT SECTION
                      _buildCommentInputSection(),
                    ],
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
  }

  // COMMENT INPUT WIDGET
  Widget _buildCommentInputSection() {
    bool isReply = commentToReply != null;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // INPUT TEXT FIELD
            Expanded(
              child: TextField(
                controller: _commentController,
                textCapitalization: TextCapitalization.sentences,
                focusNode: _commentFocusNode,
                onChanged: (value) {
                  setState(() {
                    isCommentFilled = _commentController.text.isNotEmpty;
                  });
                },
                decoration: InputDecoration(
                  hintText: isReply
                      ? 'Reply to ${commentToReply is CommentEntity ? commentToReply.userName : (commentToReply as ReplyEntity).userName}'
                      : 'Add a comment',
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(48),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            BlocConsumer<AddCommentBloc, AddCommentState>(
              listener: (context, state) {
                // ADD COMMENT SUCCESS STATE
                if (state is AddCommentSuccessState) {
                  _fetchPostAndComments();
                }

                // ADD COMMENT FAILURE STATE
                if (state is AddCommentFailureState) {
                  if (state.error.contains("Sorry, you are banned")) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                SvgPicture.asset(
                                  'assets/something_went_wrong.svg',
                                  width: 150,
                                  height: 130,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  AppLocalizations.of(context)!
                                      .aaah_something_went_wrong,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  AppLocalizations.of(context)!
                                      .sorry_you_are_banned_please_try_it_after_some_time,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.greyColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Text(
                                      AppLocalizations.of(context)!.go_back,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.whiteColor,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    showSnackBar(
                      context: context,
                      message: state.error,
                    );
                  }
                }
              },
              builder: (context, state) {
                // SEND BUTTON
                return InkWell(
                  onTap: () {
                    if (isCommentFilled) {
                      final postId = int.parse(widget.postId);

                      // SEND REPLY
                      if (isReply) {
                        BlocProvider.of<AddCommentBloc>(context).add(
                          AddCommentButtonPressedEvent(
                            postId: postId,
                            commentId: commentToReply.commentid,
                            text: _commentController.text,
                          ),
                        );
                      }

                      // SEND COMMENT
                      else {
                        String propic =
                            ShardPrefHelper.getUserProfilePicture()!;
                        String username = ShardPrefHelper.getUsername()!;
                        String userId = ShardPrefHelper.getUserID()!;
                        setState(
                          () {
                            comments.insert(
                              0,
                              CommentModel(
                                userId: userId,
                                userName: username,
                                proPic: propic,
                                text: _commentController.text,
                                createdAt: DateTime.now().toString(),
                                awardType: const [],
                                commentid: 0,
                                cheers: 0,
                                bools: 0,
                                userFeedback: '',
                                postid: postId.toString(),
                              ),
                            );
                          },
                        );
                        BlocProvider.of<AddCommentBloc>(context).add(
                          AddCommentButtonPressedEvent(
                            postId: postId,
                            text: _commentController.text,
                          ),
                        );
                      }
                      _commentController.clear();
                      setState(() {
                        isCommentFilled = false;
                        commentToReply = null;
                      });
                    }
                  },
                  child: Opacity(
                    opacity: isCommentFilled ? 1 : 0.3,
                    child: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_upward,
                        color: AppColors.whiteColor,
                        size: 32,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // POLL WIDGET
  Column _buildPollWidget(GetPostByIdSuccessState postState) {
    void showBottomSheet() {
      menuBottomSheet(
          context, postState.post.userId, postState.post.type == 'post');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (postState.post.userName.contains('[deleted]')) {
                  context.push('/deleted-user');
                } else {
                  context.push('/userProfileScreen/${postState.post.userId}');
                }
              },
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: postState.post.proPic != null &&
                            postState.post.proPic != ''
                        ? Image.network(
                            postState.post.proPic!,
                            fit: BoxFit.contain,
                          )
                        : postState.post.userName.contains('[deleted]')
                            ? Image.asset(
                                'assets/deleted_user.png',
                                fit: BoxFit.contain,
                              )
                            : Image.asset(
                                'assets/second_pro_pic.png',
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
                          postState.post.userName.contains('[deleted]')
                              ? Text(
                                  AppLocalizations.of(context)!.neighborly_user,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14),
                                )
                              : Text(
                                  postState.post.userName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
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
                            formatTimeDifference(postState.post.createdAt),
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        postState.post.city,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          '${postState.post.title}',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 16,
            color: Colors.grey[800],
          ),
        ),
        postState.post.multimedia!.isNotEmpty
            ? const SizedBox(
                height: 10,
              )
            : Container(),
        postState.post.multimedia != null &&
                postState.post.multimedia!.isNotEmpty &&
                postState.post.multimedia!.length > 1
            ? ImageSlider(
                multimedia: postState.post.multimedia ?? [],
              )
            : Container(),
        postState.post.multimedia != null &&
                postState.post.multimedia!.isNotEmpty &&
                postState.post.multimedia!.length == 1
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: postState.post.multimedia![0],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    placeholder: (context, url) => Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 125),
                        height: 300,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          padding: EdgeInsets.all(10),
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )
            : Container(),
        const SizedBox(
          height: 10,
        ),
        for (var option in postEntity?.pollOptions! ?? [])
          OptionCard(
            key: UniqueKey(),
            onSelectOptionCallback: onSelectOptionCallback,
            option: option,
            totalVotes: calculateTotalVotes(postEntity?.pollOptions! ?? []),
            pollId: postState.post.id,
            allowMultiSelect: postEntity?.allowMultipleVotes ?? false,
            otherOptions: postEntity?.pollOptions ?? [],
            alreadyselected: option.userVoted,
          ),
      ],
    );
  }

  // OPTION CARD
  onSelectOptionCallback(
    int optionid,
  ) {
    print('call');
    if (postEntity?.allowMultipleVotes ?? false) {
      print('call 2');
      List<OptionEntity>? newOptions =
          List<OptionEntity>.from(postEntity?.pollOptions ?? []);

      for (int i = 0; i < newOptions.length; i++) {
        newOptions[i] = newOptions[i].copyWith(
          userVoted: newOptions[i].optionId == optionid
              ? true
              : newOptions[i].userVoted,
          votes: newOptions[i].optionId == optionid
              ? (newOptions[i].votes ?? 0) + 1
              : newOptions[i].votes,
        );
      }

      setState(() {
        // _fetchPostAndComments();
        print('call set');
        postEntity = postEntity?.copyWith(
          pollOptions: newOptions,
        );
        isrefresh = true;
      });

      Future.delayed(Duration(milliseconds: 10), () {
        print('call set 2');
        setState(() {
          isrefresh = false;
        });
      });
    } else {
      print('call4');
      List<OptionEntity>? newOptions =
          List<OptionEntity>.from(postEntity?.pollOptions ?? []);

      for (int i = 0; i < newOptions.length; i++) {
        newOptions[i] = newOptions[i].copyWith(
          userVoted: newOptions[i].optionId == optionid
              ? true
              : newOptions[i].userVoted,
          votes: newOptions[i].optionId == optionid
              ? (newOptions[i].votes ?? 0) + 1
              : newOptions[i].votes,
        );
      }

      setState(() {
        // _fetchPostAndComments();
        print('call4 set');
        postEntity = postEntity?.copyWith(
          pollOptions: newOptions,
        );
        isrefresh = true;
      });

      Future.delayed(Duration(milliseconds: 10), () {
        print('call 5 set');
        setState(() {
          isrefresh = false;
        });
      });
    }
  }

  // MENU BUTTON SHEET
  Future<dynamic> menuBottomSheet(
      BuildContext context, String otherUserId, bool isPost) {
    void showReportReasonBottomSheet() {
      reportReasonBottomSheet(context);
    }

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        String? userId = ShardPrefHelper.getUserID();
        return Container(
          color: AppColors.whiteColor,
          height: 96,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: userId != otherUserId
              ? InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    showReportReasonBottomSheet();
                  },
                  child: Row(
                    children: [
                      Image.asset('assets/report_flag.png'),
                      const SizedBox(
                        width: 10,
                      ),
                      Text(
                        AppLocalizations.of(context)!.report,
                        style: redOnboardingBody1Style,
                      )
                    ],
                  ),
                )
              : BlocConsumer<DeletePostBloc, DeletePostState>(
                  listener: (context, state) {
                    // DELETE POST SUCCESS STATE
                    if (state is DeletePostSuccessState) {
                      showSnackBar(
                        context: context,
                        message: isPost
                            // message: widget.isPost
                            ? AppLocalizations.of(context)!.post_deleted
                            : AppLocalizations.of(context)!.poll_deleted,
                      );
                      context.pop(context);
                      context.pop(context);
                    }

                    // DELETE POST FAILURE STATE
                    else if (state is DeletePostFailureState) {
                      context.pop(context);
                      showSnackBar(
                        context: context,
                        message: state.error,
                      );
                    }
                  },
                  builder: (context, state) {
                    // DELETE POST LOADING STATE
                    if (state is DeletePostLoadingState) {
                      return CustomCircularIndicator();
                    }
                    return InkWell(
                      onTap: () {
                        context.read<DeletePostBloc>().add(
                              DeletePostButtonPressedEvent(
                                postId: int.parse(widget.postId),
                                type: 'post',
                              ),
                            );
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.delete,
                            color: AppColors.redColor,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            AppLocalizations.of(context)!.delete_post,
                            style: redOnboardingBody1Style,
                          )
                        ],
                      ),
                    );
                  },
                ),
        );
      },
    );
  }

  // REPORT REASON BOTTOM SHEET
  Future<dynamic> reportReasonBottomSheet(BuildContext context) {
    void showReportConfirmationBottomSheet() {
      reportConfirmationBottomSheet(context);
    }

    // LIST OF REPORT REASON
    List<String> reportReasons = [
      AppLocalizations.of(context)!.inappropriate_content,
      AppLocalizations.of(context)!.spam,
      AppLocalizations.of(context)!.harassment_or_hate_speech,
      AppLocalizations.of(context)!.violence_or_dangerous_organizations,
      AppLocalizations.of(context)!.intellectual_property_violation,
    ];

    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return BlocConsumer<ReportPostBloc, ReportPostState>(
          listener: (context, state) {
            // REPORT POST SUCCESS STATE
            if (state is ReportPostSuccessState) {
              Navigator.of(context).pop();
              showReportConfirmationBottomSheet();
            }

            // REPORT POST FAILURE STATE
            else if (state is ReportPostFailureState) {
              Navigator.of(context).pop();
              showSnackBar(context: context, message: state.error);
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                child: Column(
                  children: [
                    // REPORT POST LOADING STATE
                    state is ReportPostLoadingState
                        ? const CustomCircularIndicator()
                        : Center(
                            child: Text(
                              AppLocalizations.of(context)!.reason_to_report,
                              style: onboardingHeading2Style,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'content',
                                postId: widget.postId.toString(),
                                reason: reportReasons[0],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[0],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'content',
                                postId: widget.postId.toString(),
                                reason: reportReasons[1],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[1],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'content',
                                postId: widget.postId.toString(),
                                reason: reportReasons[2],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[2],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'content',
                                postId: widget.postId.toString(),
                                reason: reportReasons[3],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[3],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                    ListTile(
                      onTap: () {
                        context.read<ReportPostBloc>().add(
                              ReportButtonPressedEvent(
                                type: 'content',
                                postId: widget.postId.toString(),
                                reason: reportReasons[4],
                              ),
                            );
                      },
                      title: Text(
                        reportReasons[4],
                        style: blackonboardingBody1Style,
                      ),
                      contentPadding: EdgeInsets.zero,
                      visualDensity:
                          VisualDensity(horizontal: -4, vertical: -4),
                      minTileHeight: 30,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

// REPORT POST CONFIRMATION BOTTOM SHEET
  Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.whiteColor,
      showDragHandle: true,
      useRootNavigator: true,
      isScrollControlled: true,
      builder: (BuildContext context) {
        Future.delayed(Duration(seconds: 2), () {
          if (context.mounted) {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
              context.pop(context);
            }
          }
        });
        return Container(
          color: AppColors.whiteColor,
          height: 240,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset('assets/report_confirmation.png'),
              Text(
                AppLocalizations.of(context)!.thanks_for_letting_us_know,
                style: onboardingHeading2Style,
                textAlign: TextAlign.center,
              ),
              Text(
                AppLocalizations.of(context)!
                    .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
                style: blackonboardingBody1Style,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  // /// report confirmation bottom sheet
  // Future<dynamic> reportConfirmationBottomSheet(BuildContext context) {
  //   return showModalBottomSheet(
  //     useRootNavigator: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Container(
  //         color: AppColors.whiteColor,
  //         height: 240,
  //         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //           children: [
  //             Container(
  //               width: 40,
  //               height: 4,
  //               decoration: BoxDecoration(
  //                 color: Colors.grey[300],
  //                 borderRadius: BorderRadius.circular(40),
  //               ),
  //             ),
  //             const SizedBox(
  //               height: 4,
  //             ),
  //             Image.asset('assets/report_confirmation.png'),
  //             Text(
  //               AppLocalizations.of(context)!.thanks_for_letting_us_know,
  //               style: onboardingHeading2Style,
  //             ),
  //             Text(
  //               textAlign: TextAlign.center,
  //               AppLocalizations.of(context)!
  //                   .we_appreciate_your_help_in_keeping_our_community_safe_and_respectful_our_team_will_review_the_content_shortly,
  //               style: blackonboardingBody1Style,
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

  // Future<dynamic> reportReasonBottomSheet(BuildContext context) {
  //   void showReportConfirmationBottomSheet() {
  //     reportConfirmationBottomSheet(context);
  //   }

  //   List<String> reportReasons = [
  //     AppLocalizations.of(context)!.inappropriate_content,
  //     AppLocalizations.of(context)!.spam,
  //     AppLocalizations.of(context)!.harassment_or_hate_speech,
  //     AppLocalizations.of(context)!.violence_or_dangerous_organizations,
  //     AppLocalizations.of(context)!.intellectual_property_violation,
  //   ];

  //   return showModalBottomSheet(
  //     useRootNavigator: true,
  //     context: context,
  //     builder: (BuildContext context) {
  //       return BlocConsumer<ReportPostBloc, ReportPostState>(
  //         listener: (context, state) {
  //           ///Report Post Success State
  //           if (state is ReportPostSuccessState) {
  //             Navigator.pop(context);
  //             showReportConfirmationBottomSheet();
  //           }

  //           ///Report Post Failure State
  //           else if (state is ReportPostFailureState) {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               SnackBar(
  //                 content: Text(state.error),
  //               ),
  //             );
  //           }
  //         },
  //         builder: (context, state) {
  //           return SingleChildScrollView(
  //             child: Container(
  //               color: AppColors.whiteColor,
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   Center(
  //                     child: Container(
  //                       width: 40,
  //                       height: 5,
  //                       decoration: BoxDecoration(
  //                         color: AppColors.greyColor,
  //                         borderRadius: BorderRadius.circular(40),
  //                       ),
  //                     ),
  //                   ),
  //                   const SizedBox(
  //                     height: 15,
  //                   ),

  //                   ///Report Post Loading State
  //                   state is ReportPostLoadingState
  //                       ? const Center(
  //                           child: CircularProgressIndicator(
  //                             color: AppColors.primaryColor,
  //                           ),
  //                         )
  //                       : Center(
  //                           child: Text(
  //                             AppLocalizations.of(context)!.reason_to_report,
  //                             style: onboardingHeading2Style,
  //                           ),
  //                         ),
  //                   const SizedBox(
  //                     height: 10,
  //                   ),
  //                   Column(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       InkWell(
  //                         onTap: () {
  //                           context.read<ReportPostBloc>().add(
  //                                 ReportButtonPressedEvent(
  //                                   type: 'content',
  //                                   postId: widget.postId.toString(),
  //                                   reason: reportReasons[0],
  //                                 ),
  //                               );
  //                         },
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               reportReasons[0],
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       InkWell(
  //                         onTap: () {
  //                           context.read<ReportPostBloc>().add(
  //                                 ReportButtonPressedEvent(
  //                                   type: 'content',
  //                                   postId: widget.postId,
  //                                   reason: reportReasons[1],
  //                                 ),
  //                               );
  //                         },
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               reportReasons[1],
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       InkWell(
  //                         onTap: () => context.read<ReportPostBloc>().add(
  //                               ReportButtonPressedEvent(
  //                                 type: 'content',
  //                                 postId: widget.postId,
  //                                 reason: reportReasons[2],
  //                               ),
  //                             ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               reportReasons[2],
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       InkWell(
  //                         onTap: () => context.read<ReportPostBloc>().add(
  //                               ReportButtonPressedEvent(
  //                                 type: 'content',
  //                                 postId: widget.postId,
  //                                 reason: reportReasons[3],
  //                               ),
  //                             ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               reportReasons[3],
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       const SizedBox(
  //                         height: 10,
  //                       ),
  //                       InkWell(
  //                         onTap: () => context.read<ReportPostBloc>().add(
  //                               ReportButtonPressedEvent(
  //                                 postId: widget.postId,
  //                                 type: 'content',
  //                                 reason: reportReasons[4],
  //                               ),
  //                             ),
  //                         child: Row(
  //                           mainAxisAlignment: MainAxisAlignment.start,
  //                           children: [
  //                             Text(
  //                               reportReasons[4],
  //                               style: blackonboardingBody1Style,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  /// build post detail section
  Widget _buildPostDetails(PostEntity post) {
    void showBottomSheet() {
      menuBottomSheet(context, post.userId, post.type == 'post');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                if (post.userName.contains('[deleted]')) {
                  context.push('/deleted-user');
                } else {
                  context.push('/userProfileScreen/${post.userId}');
                }
              },
              child: Row(
                children: [
                  ClipOval(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: post.proPic != null && post.proPic != ''
                          ? CachedNetworkImage(
                              imageUrl: post.proPic!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                              placeholder: (context, url) => Center(
                                child: SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator(
                                    color: AppColors.primaryColor,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            )
                          : post.userName.contains('[deleted]')
                              ? Image.asset(
                                  'assets/deleted_user.png',
                                  fit: BoxFit.contain,
                                )
                              : const Image(
                                  image:
                                      AssetImage('assets/second_pro_pic.png'),
                                  fit: BoxFit.contain,
                                ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  post.userName.contains('[deleted]')
                      ? Text(
                          AppLocalizations.of(context)!.neighborly_user,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        )
                      : Text(
                          post.userName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                ],
              ),
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
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (post.title != null)
          Text(
            post.title!,
            style: TextStyle(
              color: Colors.grey[900],
              fontWeight: FontWeight.w500,
              fontSize: 17,
              height: 1.3,
            ),
          ),
        const SizedBox(height: 10),
        if (post.content != null)
          Text(
            post.content!,
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 15,
              height: 1.3,
            ),
          ),
        const SizedBox(height: 10),
        post.multimedia != null &&
                post.multimedia!.isNotEmpty &&
                post.multimedia!.length > 1
            ? ImageSlider(
                multimedia: post.multimedia ?? [],
              )
            : Container(),
        post.multimedia != null &&
                post.multimedia!.isNotEmpty &&
                post.multimedia!.length == 1 &&
                post.multimedia![0].contains('.mp4')
            ? VideoDisplayWidget(
                videoUrl: post.multimedia![0],
                thumbnailUrl: post.thumbnail!,
              )
            : Container(),
        post.multimedia != null &&
                post.multimedia!.isNotEmpty &&
                post.multimedia!.length == 1 &&
                (!post.multimedia![0].contains('.mp4'))
            ? Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: post.multimedia![0],
                    fit: BoxFit.contain,
                    width: double.infinity,
                    placeholder: (context, url) => Center(
                      child: SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator(
                          color: AppColors.primaryColor,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              )
            : Container(),
        const SizedBox(height: 10),
        Text(
          convertDateString(post.createdAt),
          style: TextStyle(
            color: Colors.grey[800],
            fontSize: 15,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}
