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
    print("api hit start");
    emit(TutorialUpdateLoading());
    print("api hit loading start");
    try {
      List<String>? cookies = ShardPrefHelper.getCookie();
      if (cookies == null || cookies.isEmpty) {
        throw const ServerException(message: 'No cookies found');
      }
      print('cookies list $cookies');
      String cookieHeader = cookies.join('; ');
      //  API URL
      const url = '$kBaseUrl/user/update-tutorial-info';
      print(url);
      print("api hit loading start");

      //  request body
      final data = {
        "tutorialInfo": {
          "viewedTutorial": viewed,
          "skippedTutorial": skipped,
        }
      };

      print("api calling start");
      // API call
      final response = await httpClient.put(
        Uri.parse(url),
        headers: <String, String>{
          'Cookie': cookieHeader,
          'Content-Type': 'application/json',
          //'Cookie': 'connect.sid=s%3ATNsUxcpmB530JPuGonUAMDf7UM75k6Q4.mxgR3Q0l1w8bXnJiiZlxe76Dlme%2FOEHdlLkM4ZHRoFA; refreshToken=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjY2N2QwZDZkNjIxMDQxZGEyYzdiNzllOCIsImlhdCI6MTcyNjE1MTY5OCwiZXhwIjoxNzM5MTExNjk4fQ.nVVIIKSfktYn64zktVqexxi86sfXqkuKRjp9g13fuM0',
        },
        body: jsonEncode(data),
      );
      print("api finish ${response.body}");

      //  successful
      if (response.statusCode == 200) {
        bool isSkippedTutorial =
            jsonDecode(response.body)['user']['skippedTutorial'];
        bool isViewedTutorial =
            jsonDecode(response.body)['user']['viewedTutorial'];

        ShardPrefHelper.setIsSkippedTutorial(isSkippedTutorial);
        ShardPrefHelper.setIsViewedTutorial(isViewedTutorial);
        print(response.body);
        emit(TutorialUpdateSuccess());
      } else {
        emit(TutorialUpdateFailure(
            'Failed to update tutorial status. Error: ${response.statusCode}'));
      }
    } catch (e) {
      emit(TutorialUpdateFailure(e.toString()));
    }
  }
}
