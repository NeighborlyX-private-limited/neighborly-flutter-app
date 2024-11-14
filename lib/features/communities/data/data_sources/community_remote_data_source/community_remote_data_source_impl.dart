// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/community_model.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/search_dash_model.dart';
import '../../model/search_result_model.dart';
import 'community_remote_data_source.dart';

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final http.Client client;

  CommunityRemoteDataSourceImpl({required this.client});

  @override
  Future<List<CommunityModel>> getAllCommunities(
      {required bool isSummary, required bool isNearBy}) async {
    print('... getAllCommunities isSummary=$isSummary isNearBy=$isNearBy ');
    String url =
        '$kBaseUrl/group/nearby-groups'; // from postman collection 2024-08-17

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    Map<String, dynamic> queryParameters = {'isHome': 'true'};

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override
  Future<CommunityModel> getCommunity({required String communityId}) async {
    print('... getCommunity communityId=$communityId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/fetch-group-details/$communityId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );

    if (response.statusCode == 200) {
      return CommunityModel.fromJson(jsonDecode(response.body));
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override // OK
  Future<void> makeAdmin(
      {required String communityId, required String userId}) async {
    print('... makeAdmin communityId=$communityId userId=$userId ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/make-admin'; // from postman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'groupId': communityId,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      print('response.body=${response.body}');
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override
  Future<void> removeUser(
      {required String communityId, required String userId}) async {
    print('... removeUser communityId=$communityId userId=$userId ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/remove-user';

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'group_id': communityId,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // return jsonData['message'];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<void> unblockUser(
      {required String communityId, required String userId}) async {
    print('... unblockUser communityId=$communityId userId=$userId ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/unblock-user';

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, String>{
          'userId': userId,
          'group_id': communityId,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);

      // return jsonData['message'];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override // OK
  Future<void> updateType(
      {required String communityId, required String newType}) async {
    print('... unblockUser updateType=$communityId userId=$newType ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/update-group-details'; // from postman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'type': newType,
        }));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      // return jsonData['message'];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  @override
  Future<String> createCommunity(
      {required CommunityModel community, File? pictureFile}) async {
    print('... createCommunity community=$community');
    print('... createCommunity File=${pictureFile?.path}');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/create?home=true'; // TODO put a correct URL endPoint

    // Create a multipart request
    if (pictureFile != null) {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..headers['Cookie'] = cookieHeader
        ..fields['group_id'] = community.id
        ..fields['name'] = community.name
        ..fields['topic'] = 'etc'
        ..fields['radius'] = '${community.radius}'
        ..fields['description'] = community.description
        ..fields['location'] = community.locationStr ?? ''
        ..fields['typeOf'] = community.isPublic ? 'public' : 'close'
        ..fields["useHomeLocation"] = 'false'
        ..fields["isOpen"] = 'true';

      // Add multimedia file if available
      request.files.add(
        http.MultipartFile(
          'file', // Field name for the file
          pictureFile.readAsBytes().asStream(),
          pictureFile.lengthSync(),
          filename: pictureFile.path.split('/').last,
        ),
      );

      // Send the request and handle the response
      final response = await request.send();
      final responseString = await response.stream.bytesToString();
      if (response.statusCode == 200) {
        return jsonDecode(responseString)['group']['_id'];
      } else {
        final errorMessage = jsonDecode(responseString)['error'];
        throw ServerException(message: errorMessage);
      }
    } else {
      final response = await client.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Cookie': cookieHeader,
          },
          body: jsonEncode(<String, dynamic>{
            'name': community.name,
            'description': community.description,
            'isOpen': 'true',
          }));

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['group']['_id'];
      } else {
        final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
        throw ServerException(message: message);
      }
    }
  } // createCommunity

  @override
  Future<void> leaveCommunity({required String communityId}) async {
    print('... leaveCommunity community=$communityId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/leave'; // TODO put a correct URL endPoint

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  } // leaveCommunity

  @override
  Future<void> reportCommunity(
      {required String communityId, required String reason}) async {
    print('... reportCommunity community=$communityId');
    print('... reportCommunity reason=$reason');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/report'; // from postman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'reason': reason,
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  } // reportCommunity

  @override // OK
  Future<void> updateDescription(
      {required String communityId, required String newDescription}) async {
    print('... updateDescription community=$communityId');
    print('... updateDescription newDescription=$newDescription');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/update-group-details'; // from psotman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'description': newDescription,
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  } // updateDescription

  @override // OK
  Future<void> updateIcon(
      {required String communityId,
      File? pictureFile,
      String? imageUrl}) async {
    print('... updateIcon community=$communityId');
    print('... updateIcon pictureFile=${pictureFile?.path}');
    print('... updateIcon imageUrl=$imageUrl');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/update-group-details'; // from postman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'picture': imageUrl ?? '',
        }));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      // return jsonData['message'];
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }

    // case with FILE upload pictureFile
    if (pictureFile != null) {
      // Create a multipart request
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(url),
      )
        ..headers['Cookie'] = cookieHeader
        ..fields['group_id'] = communityId;

      // Add multimedia file if available

      request.files.add(
        http.MultipartFile(
          'file', // Field name for the file
          pictureFile.readAsBytes().asStream(),
          pictureFile.lengthSync(),
          filename: pictureFile.path.split('/').last,
        ),
      );

      // Send the request and handle the response
      final response = await request.send();
      final responseString = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        // final jsonData = jsonDecode(response.body);
      } else {
        final errorMessage = jsonDecode(responseString)['error'];
        throw ServerException(message: errorMessage);
      }
    }
  } // updateIcon

  @override // OK
  Future<void> updateLocation(
      {required String communityId, required String newLocation}) async {
    print('... updateLocation community=$communityId');
    print('... updateLocation newDescription=$newLocation');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/update-group-details'; // from psotman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'newLocation': newLocation, // TODO: probably other text
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  } // updateLocation

  @override
  Future<void> updateMute(
      {required String communityId, required bool newValue}) async {
    print('... updateMute community=$communityId');
    print('... updateMute newValue=$newValue');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url = '$kBaseUrl/group/mute'; // TODO put a correct URL endPoint

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'newValue': newValue,
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  } // updateMute

  @override // OK
  Future<void> updateRadius(
      {required String communityId, required num newRadius}) async {
    print('... updateRadius community=$communityId');
    print('... updateRadius newValue=$newRadius');

    List<String>? cookies = ShardPrefHelper.getCookie();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'No cookies found');
    }
    String cookieHeader = cookies.join('; ');
    String url =
        '$kBaseUrl/group/update-group-details'; // from psotman collection 2024-08-17

    final response = await client.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Cookie': cookieHeader,
        },
        body: jsonEncode(<String, dynamic>{
          'group_id': communityId,
          'radius': newRadius,
        }));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
      throw ServerException(message: message);
    }
  }

  // ################################################################
  // ################################################################

  @override
  Future<SearchDashModel> getSearchHistoryAndTrends() async {
    print('... getSearchHistoryAndTrends  ');

    // FAKE example
    // await Future.delayed(Duration(seconds: 3));

    String fakeData = '''
      {
          "trending": [
            {
              "id": "668164e760dbe07a2fd9df5b",
              "name": "Capibaras",
              "avatarUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596"
              
            },     
            {
              "id": "668164e760dbe07a2fd9df5b",
              "name": "Tech Crazy People Big Name",
              "avatarUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360"
            }     
          ],
          "history": [
            { "term": "something that I search" },
            { "term": "something that I search again" },
            { "term": "something that I search with a big text to test" },
            { "term": "something that I search" },
            { "term": "something that I search" }
          ]
      }
      ''';

    final fakeJson = json.decode(fakeData);
    return SearchDashModel.fromMap(fakeJson);

    // List<String>? cookies = ShardPrefHelper.getCookie();
    // if (cookies == null || cookies.isEmpty) {
    //   throw const ServerException(message: 'No cookies found');
    // }
    // String cookieHeader = cookies.join('; ');
    // String url = '$kBaseUrl/wall/fetch-posts';
    // Map<String, dynamic> queryParameters = {'home': '$isHome'};

    // final response = await client.get(
    //   Uri.parse(url).replace(queryParameters: queryParameters),
    //   headers: <String, String>{
    //     'Cookie': cookieHeader,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonData = jsonDecode(response.body);
    //   return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    // } else {
    //   final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
    //   throw ServerException(message: message);
    // }
  }

  @override
  Future<SearchResultModel> getSearchResults(
      {required String searchTem, required bool isPreview}) async {
    print('... getSearchResults  searchTem=$searchTem  isPreview=$isPreview ');

    String fakeData = '''
      {
          "communities": [
            {
              "id": "668164e760dbe07a2fd9df5b",
              "name": "Capibaras",
              "avatarUrl": "https://img.freepik.com/fotos-gratis/capivara-no-habitat-natural-do-norte-do-pantanal-maior-rondent-america-selvagem-da-vida-selvagem-sul-americana-beleza-da-natureza_475641-2161.jpg?t=st=1722531645~exp=1722535245~hmac=940000ad880443f24ddfc51afec3f77a0116cd23c80063e5caecaf8ce3ac7c49&w=596",
              "membersCount": 1234,
              "isPublic": false,
              "members": [
                {
                  "userId": "1111",
                  "userName": "John Wick",
                  "picture":"https://moacir.net/avatars/10.jpg",
                  "karma": 1
                },
                {
                  "userId": "222",
                  "userName": "Marta Wayne",
                  "picture":"https://moacir.net/avatars/77.jpg",
                  "karma": 1
                },
                {
                  "userId": "333",
                  "userName": "Peter Sulivan",
                  "picture":"https://moacir.net/avatars/34.jpg",
                  "karma": 1
                },
                {
                  "userId": "4444",
                  "userName": "Teresa Madre",
                  "picture":"https://moacir.net/avatars/none.png",
                  "karma": 1
                }
              ]  
            },     
            {
              "id": "668164e760dbe07a2fd9df5b",
              "name": "Tech Crazy People Big Name",
              "avatarUrl": "https://img.freepik.com/fotos-gratis/especialista-em-seguranca-cibernetica-a-trabalhar-com-tecnologia-em-luzes-de-neon_23-2151645661.jpg?t=st=1722573533~exp=1722577133~hmac=fc9a6c66bed1aef3fad7541423c49fa69ea858159e8d3d6903039c7edf5dde65&w=360",
              "membersCount": 193,
              "isPublic": true,
              "members": [
                {
                  "userId": "1111",
                  "userName": "John Wick",
                  "picture":"https://moacir.net/avatars/10.jpg",
                  "karma": 1
                },
                {
                  "userId": "222",
                  "userName": "Marta Wayne",
                  "picture":"https://moacir.net/avatars/77.jpg",
                  "karma": 1
                },
                {
                  "userId": "333",
                  "userName": "Peter Sulivan",
                  "picture":"https://moacir.net/avatars/34.jpg",
                  "karma": 1
                },
                {
                  "userId": "4444",
                  "userName": "Teresa Madre",
                  "picture":"https://moacir.net/avatars/none.png",
                  "karma": 1
                }
              ]  
            }     
          ],
          "people": [
               {
                  "userId": "1111",
                  "userName": "John Wick",
                  "picture":"https://moacir.net/avatars/10.jpg",
                  "karma": 1
                },
                {
                  "userId": "222",
                  "userName": "Marta Wayne",
                  "picture":"https://moacir.net/avatars/77.jpg",
                  "karma": 2
                },
                {
                  "userId": "333",
                  "userName": "Peter Sulivan",
                  "picture":"https://moacir.net/avatars/34.jpg",
                  "karma": 3
                },
                {
                  "userId": "4444",
                  "userName": "Teresa Madre",
                  "picture":"https://moacir.net/avatars/none.png",
                  "karma": 12
                }
          ]
      }
      ''';

    final fakeJson = json.decode(fakeData);
    return SearchResultModel.fromMap(fakeJson);

    // List<String>? cookies = ShardPrefHelper.getCookie();
    // if (cookies == null || cookies.isEmpty) {
    //   throw const ServerException(message: 'No cookies found');
    // }
    // String cookieHeader = cookies.join('; ');
    // String url = '$kBaseUrl/wall/fetch-posts';
    // Map<String, dynamic> queryParameters = {'home': '$isHome'};

    // final response = await client.get(
    //   Uri.parse(url).replace(queryParameters: queryParameters),
    //   headers: <String, String>{
    //     'Cookie': cookieHeader,
    //   },
    // );

    // if (response.statusCode == 200) {
    //   final List<dynamic> jsonData = jsonDecode(response.body);
    //   return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    // } else {
    //   final message = jsonDecode(response.body)['msg'] ?? 'Unknown error';
    //   throw ServerException(message: message);
    // }
  } // getSearchHistoryAndTrends
}
