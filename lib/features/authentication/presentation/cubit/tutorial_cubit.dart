import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'dart:convert';

import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_state.dart';

class TutorialCubit extends Cubit<TutorialState> {
  final http.Client httpClient;

  TutorialCubit(this.httpClient) : super(TutorialInitial());

  // Function to call the API and update tutorial status
  Future<void> updateTutorialStatus(bool viewed, bool skipped) async {
    print("updateTutorialStatus api start with...");
    print('viewed: $viewed');
    print('skipped: $skipped');
    emit(TutorialUpdateLoading());

    try {
      List<String>? cookies = ShardPrefHelper.getCookie();
      if (cookies == null || cookies.isEmpty) {
        print("No cookies found...");
        throw const ServerException(message: 'No cookies found');
      }
      print('cookies list: $cookies');
      String cookieHeader = cookies.join('; ');

      //  API URL
      const url = '$kBaseUrl/user/update-tutorial-info';
      print('url: $url');

      //  request body
      final data = {
        "tutorialInfo": {
          "viewedTutorial": viewed,
          "skippedTutorial": skipped,
        }
      };

      // API call
      final response = await httpClient.put(
        Uri.parse(url),
        headers: <String, String>{
          'Cookie': cookieHeader,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );
      print("update Tutorial Status code: ${response.statusCode}");
      print("update Tutorial Status response: ${response.body}");

      if (response.statusCode == 200) {
        bool isSkippedTutorial =
            jsonDecode(response.body)['user']['skippedTutorial'];
        bool isViewedTutorial =
            jsonDecode(response.body)['user']['viewedTutorial'];

        ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
        ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);

        emit(TutorialUpdateSuccess());
      } else {
        print("update Tutorial Status else error: ${response.body}");
        emit(TutorialUpdateFailure(
            'Failed to update tutorial status: ${response.statusCode}'));
      }
    } catch (e) {
      print("update Tutorial Status catch error: ${e.toString()}");
      emit(TutorialUpdateFailure(e.toString()));
    }
  }
}
