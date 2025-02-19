import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/core/constants/constants.dart';
import 'package:neighborly_flutter_app/core/error/exception.dart';
import 'package:neighborly_flutter_app/core/utils/shared_preference.dart';
import 'dart:convert';
import 'package:neighborly_flutter_app/features/authentication/presentation/cubit/tutorial_state.dart';

import '../../../../core/utils/set_auth.dart';

class TutorialCubit extends Cubit<TutorialState> {
  final http.Client httpClient;

  TutorialCubit(this.httpClient) : super(TutorialInitial());

  // Function to call the API and update tutorial status
  Future<void> updateTutorialStatus(bool viewed, bool skipped) async {
    emit(TutorialUpdateLoading());

    try {
      String? cookies = ShardPrefHelper.getCookie();
      String? accessToken = ShardPrefHelper.getAccessToken();
      if (cookies == null || cookies.isEmpty) {
        throw const ServerException(message: 'No cookies found');
      }

      // String cookieHeader = cookies.join('; ');

      //  API URL
      const url = '$kBaseUrl/user/update-tutorial-info';

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
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
          'Cookie': cookies,
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        handleAuthHeaders(response.headers);
        // List<String> cookies = response.headers['set-cookie']?.split(',') ?? [];
        // String accessToken = response.headers['authorization'] ?? '';
        // ShardPrefHelper.setCookie(cookies);
        // ShardPrefHelper.setAccessToken(accessToken);

        bool isSkippedTutorial =
            jsonDecode(response.body)['user']['skippedTutorial'];
        bool isViewedTutorial =
            jsonDecode(response.body)['user']['viewedTutorial'];

        ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
        ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);

        emit(TutorialUpdateSuccess());
      } else {
        emit(TutorialUpdateFailure(
            'Failed to update tutorial status: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TutorialUpdateFailure(e.toString()));
    }
  }
}
