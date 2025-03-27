import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:neighborly_flutter_app/core/models/post_model.dart';
import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// e2Gw-Q9rSCqz6RYeMn1YvD:APA91bHpTNm3SoqdZ8mDy_L7YkJTTY-ynM_nt_Gidg7gh9QYfiLQHfySwyO2wSUcBtgT7RIAaDaKzvdTZnTid5_2G5vouxIRcxjh2tLHBgPQu6mi2ZtnQ1c
// SEARCH TEXT FIELD WIDGET
class SearchAheadElement extends StatefulWidget {
  const SearchAheadElement({
    super.key,
    required this.onFocusChange,
    required this.onSearchTextChange,
    required this.onSuggestionSelected,
    required this.suggestionCallback,
    required this.showTitle,
    this.onSubmit,
    this.isDarkmode = false,
    this.showClose = true,
    this.lintText = '',
    this.icon = Icons.search,
    this.showBackButton = false,
  });

  final Function(bool) onFocusChange;
  final Function(String) onSearchTextChange;
  final Function(String)? onSubmit;
  final Function(dynamic) onSuggestionSelected;
  final FutureOr<List<dynamic>> Function(String) suggestionCallback;
  final bool showTitle;
  final bool? isDarkmode;
  final bool? showClose;
  final String? lintText;
  final IconData? icon;
  final bool? showBackButton;

  @override
  State<SearchAheadElement> createState() => _SearchAheadElementState();
}

class _SearchAheadElementState extends State<SearchAheadElement> {
  final searchEC = TextEditingController();

  @override
  void dispose() {
    searchEC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (widget.showBackButton == true) ...[
          GestureDetector(
            child: Icon(
              Icons.arrow_back_ios,
              size: 24,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ],
        Flexible(
          fit: FlexFit.tight,
          child: SizedBox(
            child: TypeAheadField<dynamic>(
              controller: searchEC,
              debounceDuration: Duration(milliseconds: 600),
              hideOnEmpty: true,
              // suggestionsCallback: () {},
              suggestionsCallback: widget.suggestionCallback,
              builder: (context, controller, focusNode) {
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: (value) {
                    if (widget.onSubmit == null) return;
                    widget.onSubmit!(value);
                  },
                  decoration: InputDecoration(
                    suffixIcon: widget.showClose!
                        ? IconButton(
                            icon: Icon(
                              Icons.close,
                              color: AppColors.lightGreyColor,
                            ),
                            onPressed: () {
                              controller.clear();
                              searchEC.clear();
                              focusNode.unfocus();
                              widget.onSearchTextChange('');
                              searchEC.text = '';
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.lightBackgroundColor,
                    hintText: widget.lintText == ''
                        ? AppLocalizations.of(context)!.type_something_here
                        : widget.lintText,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 5,
                    ),
                    hintStyle: TextStyle(
                      color: AppColors.lightGreyColor,
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      gapPadding: 0,
                      borderSide: BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  cursorColor: Colors.black,
                );
              },
              errorBuilder: (context, error) => Text(
                '$error',
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
              emptyBuilder: (context) => Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppLocalizations.of(context)!.type_to_search,
                  textAlign: TextAlign.center,
                ),
              ),
              itemBuilder: (context, result) {
                print('here $result');
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      UserAvatarStyledWidget(
                        avatarUrl:
                            result is PostModel ? result.proPic : result.proPic,
                        avatarSize: 22,
                        avatarBorderSize: 0,
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text(
                            //   result is CommunityModel
                            //       ? result.name
                            //       : result.,
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(
                            //     fontWeight: FontWeight.w600,
                            //     fontSize: 15,
                            //   ),
                            // ),
                            // Text(
                            //   result is CommunityModel
                            //       ? '${result.membersCount} ${AppLocalizations.of(context)!.members}'
                            //       : '${result.karma} ${AppLocalizations.of(context)!.karma}',
                            //   maxLines: 1,
                            //   overflow: TextOverflow.ellipsis,
                            //   style: TextStyle(fontWeight: FontWeight.normal),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (movie) {
                searchEC.clear();
                widget.onSuggestionSelected(movie);
              },
            ),
          ),
        ),
      ],
    );
  }
}
