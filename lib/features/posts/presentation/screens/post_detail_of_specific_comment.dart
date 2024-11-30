import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:neighborly_flutter_app/core/widgets/bouncing_logo_indicator.dart';
import 'package:neighborly_flutter_app/core/widgets/somthing_went_wrong.dart';
import 'package:neighborly_flutter_app/features/posts/presentation/bloc/get_comment_by_comment_id_bloc/get_comments_by_commentId_bloc.dart';
import 'package:neighborly_flutter_app/features/profile/presentation/widgets/post_with_specific_comment_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostDetailOfSpecificComment extends StatefulWidget {
  final String commentId;
  const PostDetailOfSpecificComment({
    super.key,
    required this.commentId,
  });

  @override
  State<PostDetailOfSpecificComment> createState() =>
      _PostDetailOfSpecificComment();
}

class _PostDetailOfSpecificComment extends State<PostDetailOfSpecificComment> {
  final bloc = GetIt.instance<GetCommentByCommentIdBloc>();

  /// init method
  @override
  void initState() {
    super.initState();
    _fetchPostDetail();
  }

  /// fetch post detail
  void _fetchPostDetail() {
    var commentId = widget.commentId;
    bloc.add(
      GetCommentByCommentIdButtonPressedEvent(
        commentId: commentId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<GetCommentByCommentIdBloc>.value(
      value: bloc,
      child: Scaffold(
        appBar: AppBar(),
        body:
            BlocBuilder<GetCommentByCommentIdBloc, GetCommentByCommentIdState>(
          builder: (context, state) {
            ///loading state
            if (state is GetCommentByCommentIdLoadingState) {
              return Center(
                child: BouncingLogoIndicator(
                  logo: 'images/logo.svg',
                ),
              );
            }

            /// failure state
            else if (state is GetCommentByCommentIdFailureState) {
              return SomethingWentWrong(
                imagePath: 'assets/something_went_wrong.svg',
                title: AppLocalizations.of(context)!.aaah_something_went_wrong,
                message: AppLocalizations.of(context)!
                    .we_could_not_fetch_your_data_please_try_starting_it_again,
                buttonText: AppLocalizations.of(context)!.go_back,
                onButtonPressed: () {
                  context.pop();
                },
              );
            }

            ///success state
            else if (state is GetCommentByCommentIdSuccessState) {
              return PostWithSpecificCommentsWidget(
                post: state.comment,
              );
            }

            /// no data
            else {
              return Center(
                child: Text(AppLocalizations.of(context)!.no_data),
              );
            }
          },
        ),
      ),
    );
  }
}
