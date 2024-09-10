import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import '../../../../core/models/community_model.dart';
import '../../../../core/theme/colors.dart';
import '../../../../core/widgets/user_avatar_styled_widget.dart';

/*
  example:

  Padding(
    padding:   EdgeInsets.fromLTRB(10, 0, 20, 2),
    child: SearchAheadElement(
      onFocusChange: (value) {},
      onSearchTextChange: (value) {},
      showTitle: true,
      isDarkmode: widget.isDarkmode,
      lintText: widget.lintText,
      icon: widget.icon,
      onSuggestionSelected: (selectedItem) {
        widget.onSuggestionSelected(selectedItem);
      },
      suggestionCallback: (userSearchCriteria) async {
        if (userSearchCriteria.trim().length < 3) return [];

        return await widget.suggestionCallback(userSearchCriteria, scopeSelected);
      },
    ),
  ),
*/
class SearchAheadElement extends StatefulWidget {
  const SearchAheadElement({
    Key? key,
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
  }) : super(key: key);

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
              color: Colors.black,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          const SizedBox(
            width: 10,
          ),
        ],
        Flexible(
          fit: FlexFit.tight,
          child: Container(
            // color: Colors.red,
            // height: 35,
            child: TypeAheadField<dynamic>(
              controller: searchEC,
              debounceDuration: Duration(milliseconds: 600),
              hideOnEmpty: true,
              suggestionsCallback: widget.suggestionCallback,
              builder: (context, controller, focusNode) {
                //
                //
                return TextFormField(
                  controller: controller,
                  focusNode: focusNode,
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: (value) {
                    if (widget.onSubmit == null) return;

                    print('...PRESS ENTER? ${value}');
                    widget.onSubmit!(value);
                  },
                  decoration: InputDecoration(
                    // prefixIcon: Icon(
                    //   widget.icon,
                    //   // color: widget.isDarkmode! ? Colors.white.withOpacity(0.4) : Colors.black54,
                    //   color: Colors.white.withOpacity(0.6),
                    // ),
                    suffixIcon: widget.showClose!
                        ? IconButton(
                            // icon: Icon(Icons.close, color: widget.isDarkmode! ? Colors.white.withOpacity(0.4) : Colors.black26),
                            icon: Icon(Icons.close,
                                color: Colors.black.withOpacity(0.4)),
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
                    // fillColor: widget.isDarkmode! ? Colors.grey[800] : Colors.grey[200],
                    fillColor: AppColors.lightBackgroundColor,
                    hintText: widget.lintText == ''
                        ? 'type something here'
                        : widget.lintText, // 'Buscar',
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 5), // Inside box padding
                    // hintStyle: TextStyle(color: widget.isDarkmode! ? Colors.white.withOpacity(0.4) : Colors.black26),
                    hintStyle: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 20,
                        fontWeight: FontWeight.w400),
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
              errorBuilder: (context, error) => Text('$error',
                  style: TextStyle(color: Theme.of(context).colorScheme.error)),
              emptyBuilder: (context) => Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(
                  'type to search', // 'nenhum resultado encontrado',
                  textAlign: TextAlign.center,
                ),
              ),
              itemBuilder: (context, result) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      UserAvatarStyledWidget(
                        avatarUrl: result is CommunityModel
                            ? result.avatarUrl
                            : result.avatarUrl,
                        avatarSize: 22,
                        avatarBorderSize: 0,
                      ),
                      const SizedBox(width: 15),
                      //
                      //
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              result is CommunityModel
                                  ? result.name
                                  : result.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15),
                            ),
                            //
                            Text(
                              result is CommunityModel
                                  ? '${result.membersCount} Members'
                                  : '${result.karma} Karma',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontWeight: FontWeight.normal),
                            ),
                            //
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
              onSelected: (movie) {
                searchEC.clear();
                print(movie);
                widget.onSuggestionSelected(movie);
              },
            ),
          ),
        ),
      ],
    );
  }
}
