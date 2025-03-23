// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/constants.dart';
import '../../../../../core/error/exception.dart';
import '../../../../../core/models/community_model.dart';
import '../../../../../core/models/post_model.dart';
import '../../../../../core/utils/set_auth.dart';
import '../../../../../core/utils/shared_preference.dart';
import '../../model/group_join_request_model.dart';
import '../../model/search_dash_model.dart';
import '../../model/search_model.dart';
import '../../model/search_result_model.dart';
import 'community_remote_data_source.dart';

class CommunityRemoteDataSourceImpl implements CommunityRemoteDataSource {
  final http.Client client;

  CommunityRemoteDataSourceImpl({required this.client});

  // CREATE COMMUNITY
  @override
  Future<String> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/create';
    Map<String, dynamic> queryParameters;

    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double long = ShardPrefHelper.getLng() ?? 0.0;
    queryParameters = {
      'latitude': '$lat',
      'longitude': '$long',
    };
    print('create group lat lng: $lat $long');

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url).replace(queryParameters: queryParameters),
    )
      ..headers['Cookie'] = cookies
      ..headers['Authorization'] = 'Bearer $accessToken'
      ..fields['name'] = community.name
      ..fields['isOpen'] = community.isPublic.toString()
      ..fields['description'] = community.description
      ..fields['radius'] = '${community.radius}'
      ..fields['karma'] = community.karma.toString();

    if (pictureFile != null) {
      request.files.add(
        http.MultipartFile(
          'file',
          pictureFile.readAsBytes().asStream(),
          pictureFile.lengthSync(),
          filename: pictureFile.path.split('/').last,
        ),
      );
    }

    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    print('CREATE COMMUNITY: $responseString');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(responseString)['group']['_id'];
    } else {
      final errorMessage = jsonDecode(responseString)['message'] ??
          jsonDecode(responseString)['msg'] ??
          jsonDecode(responseString)['error'] ??
          'oops omething went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GET ALL COMMUNITY
  @override
  Future<List<CommunityModel>> getAllCommunities() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/nearby-groups';
    Map<String, dynamic> queryParameters;

    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double lng = ShardPrefHelper.getLng() ?? 0.0;
    queryParameters = {
      'latitude': '$lat',
      'longitude': '$lng',
    };
    print('featch group lat lng: $lat $lng');

    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('GET ALL COMMUNITY: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  // GET USER'S COMMUNITY
  @override
  Future<List<CommunityModel>> getUserGroups() async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/user-groups';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('GET USER\'S COMMUNITY: ${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      final errorMessage = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          'oops omething went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // GET COMMUNITY DETAILS
  @override
  Future<CommunityModel> getCommunity({required String communityId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/fetch-group-details/$communityId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return CommunityModel.fromJson(jsonDecode(response.body));
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  ///get community join request api call
  @override
  Future<List<GroupJoinRequestModel>> getCommunityJoinRequest(
      {required String communityId}) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/get-requests/$communityId';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    ;
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map((data) => GroupJoinRequestModel.fromJson(data))
          .toList();
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  ///handleJoinRequest api call
  @override
  Future<String> handleJoinRequest({
    required String communityId,
    required String requestId,
    required String status,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/handle-requests/$communityId/$requestId';

    final response = await client.patch(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(<String, String>{
        "response": status,
      }),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      return jsonDecode(response.body)['message'] ?? "Success";
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  /// make admin api call
  @override
  Future<void> makeAdmin({
    required String communityId,
    required String userId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/add-admin';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
          'groupId': communityId,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  /// make admin api call
  @override
  Future<void> removeAdmin({
    required String communityId,
    required String userId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/remove-admin';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, String>{
          'adminId': userId,
          'groupId': communityId,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  // JOIN COMMUNITY
  @override
  Future<void> joinGroup({
    required String communityId,
    required String? userId,
  }) async {
    if (userId == null) {
      userId = ShardPrefHelper.getUserID() ?? '';
    }

    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/add-user';

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
          'groupId': communityId,
        },
      ),
    );
    print('JOIN GROUP RESPONSE:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // LEAVE COMMUNITY
  @override
  Future<void> leaveCommunity({
    required String communityId,
    required String? userId,
    required bool isRemove,
  }) async {
    if (userId == null) {
      userId = ShardPrefHelper.getUserID() ?? '';
    }

    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = "";
    if (isRemove) {
      url = '$kBaseUrl/group/remove-user/$communityId/$userId';
    } else {
      url = '$kBaseUrl/group/leave/$communityId';
    }

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'userId': userId,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  ///update group updateDisplayname
  @override
  Future<void> updateDisplayname({
    required String communityId,
    required String newDisplayname,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'displayname': newDisplayname,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///update group description
  @override
  Future<void> updateDescription({
    required String communityId,
    required String newDescription,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'description': newDescription,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  /// update type
  @override
  Future<void> updateType({
    required String communityId,
    required String newType,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    String isOpen = 'true';
    if (newType == 'private') {
      isOpen = 'false';
    }

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'isOpen': isOpen,
        },
      ),
    );
    print('UPDATE GROUP TYPE:${response.body}');
    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///update group icon
  @override
  Future<void> updateIcon({
    required String communityId,
    File? pictureFile,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    /// Create a multipart request
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(url),
    )
      ..headers['Cookie'] = cookies
      ..fields['groupId'] = communityId;

    if (pictureFile != null) {
      request.files.add(
        http.MultipartFile(
          'file',
          pictureFile.readAsBytes().asStream(),
          pictureFile.lengthSync(),
          filename: pictureFile.path.split('/').last,
        ),
      );
    }

    /// Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final errorMessage = jsonDecode(responseString)['msg'];
      throw ServerException(message: errorMessage);
    }
  }

  ///update group location
  @override
  Future<void> updateLocation({
    required String communityId,
    required String newLocation,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'newLocation': newLocation,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final jsonData = jsonDecode(response.body);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///update radius
  @override
  Future<void> updateRadius({
    required String communityId,
    required num newRadius,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/update-group-details';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'radius': newRadius,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final jsonData = jsonDecode(response.body);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  // UPDATE MUTE/UNMUTE
  @override
  Future<void> updateMute({
    required String communityId,
    required bool isMute,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseUrl/group/mute-group';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'mute': isMute,
        },
      ),
    );

    if (response.statusCode == 204) {
      handleAuthHeaders(response.headers);
    } else {
      final errorMessage = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  ///report group
  @override
  Future<void> reportCommunity({
    required String communityId,
    required String reason,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/report-group';
    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'reason': reason,
        },
      ),
    );
    print('REPORT RESPONSE:${response.body}');

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///delete Community
  @override
  Future<void> deleteCommunity({
    required String communityId,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/delete-group/$communityId';

    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
    } else {
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  // ignore: override_on_non_overriding_member
  Future<String> updateBlock({
    required String communityId,
    required String userId,
    required bool isBlock,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }
    //String cookieHeader = cookies.join('; ');

    String url = '$kBaseUrl/group/block-user';

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode(
        <String, dynamic>{
          'userId': userId,
          'groupId': communityId,
          'block': isBlock,
        },
      ),
    );

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final msg =
          jsonDecode(response.body)['message'] ?? 'oops omething went wrong';
      return msg;
    } else {
      final message =
          jsonDecode(response.body)['message'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<SearchDashModel> getSearchHistoryAndTrends() async {
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

    // String? cookies = ShardPrefHelper.getCookie();
    // if (cookies == null || cookies.isEmpty) {
    //   throw const ServerException(message: 'oops omething went wrong');
    // }
    // //String cookieHeader = cookies.join('; ');
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
    //   final message = jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
    //   throw ServerException(message: message);
    // }
  }

  @override
  Future<SearchResultModel> getSearchResults({
    required String searchTem,
    required bool isPreview,
  }) async {
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
    String fakeApiData = '''{
    "globalSearchData": [
        {
            "contentid": 197,
            "userid": "67b5c24bb1aeede9dad88f69",
            "username": "[deleted]",
            "title": "Hi",
            "body": "",
            "multimedia": [],
            "createdat": "2025-02-19T11:41:46.725Z",
            "cheers": 4,
            "boos": 0,
            "postlocation": "0101000020E6100000B003E78C289D3C40E8D9ACFA5C4D5340",
            "city": "New Delhi",
            "type": "poll",
            "poll_options": [
                {
                    "option": {
                        "option": "Hello 👋"
                    },
                    "optionId": 1
                },
                {
                    "option": {
                        "option": "Hy👋"
                    },
                    "optionId": 2
                }
            ],
            "allow_multiple_votes": false,
            "thumbnail": null,
            "quarantined": false
        },
        {
            "contentid": 321,
            "userid": "67b1e1551d776df4f3cc4cb0",
            "username": "part-timeundergarment6862",
            "title": "Hi",
            "body": "",
            "multimedia": [],
            "createdat": "2025-03-10T13:25:30.518Z",
            "cheers": 2,
            "boos": 1,
            "postlocation": "0101000020E6100000B003E78C289D3C40E8D9ACFA5C4D5340",
            "city": "New Delhi",
            "type": "post",
            "poll_options": null,
            "allow_multiple_votes": false,
            "thumbnail": null,
            "quarantined": false
        }
      
    ],
    "localSearchData": [
        {
            "contentid": 197,
            "userid": "67b5c24bb1aeede9dad88f69",
            "username": "[deleted]",
            "title": "Hi",
            "body": "",
            "multimedia": [],
            "createdat": "2025-02-19T11:41:46.725Z",
            "cheers": 4,
            "boos": 0,
            "postlocation": "0101000020E6100000B003E78C289D3C40E8D9ACFA5C4D5340",
            "city": "New Delhi",
            "type": "poll",
            "poll_options": [
                {
                    "option": {
                        "option": "Hello 👋"
                    },
                    "optionId": 1
                },
                {
                    "option": {
                        "option": "Hy👋"
                    },
                    "optionId": 2
                }
            ],
            "allow_multiple_votes": false,
            "thumbnail": null,
            "quarantined": false
        },
        {
            "contentid": 321,
            "userid": "67b1e1551d776df4f3cc4cb0",
            "username": "part-timeundergarment6862",
            "title": "Hi",
            "body": "",
            "multimedia": [],
            "createdat": "2025-03-10T13:25:30.518Z",
            "cheers": 2,
            "boos": 1,
            "postlocation": "0101000020E6100000B003E78C289D3C40E8D9ACFA5C4D5340",
            "city": "New Delhi",
            "type": "post",
            "poll_options": null,
            "allow_multiple_votes": false,
            "thumbnail": null,
            "quarantined": false
        }
        
    ]
}''';

    // final fakeJson = json.decode(fakeData);

    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();
    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'oops omething went wrong');
    }

    String url = '$kBaseSearchUrl/search/posts/$searchTem';

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );
    print('Search res: ${response.body}');
    if (response.statusCode == 200) {
      // final List<dynamic> jsonPostData = jsonDecode(response.body);
      // List<PostModel> data =
      //     jsonPostData.map((data) => PostModel.fromJson(data)).toList();
      // print('yes data: $data');
      // final List<dynamic> jsonData = jsonDecode(response.body);
      // final fakeJson = json.decode(fakeData);
      final fakeNewApiJson = json.decode(fakeApiData);
      print('before: $fakeNewApiJson');
      // return js
      // var res =
      //     fakeNewApiJson.map((data) => SearchModel.fromJson(data)).toList();
      // print('this si : $res');
      var res = SearchResultModel.fromMap(fakeNewApiJson);
      print('this si respo: $res');
      print('userpic: ${res.trendingPost[0].proPic}');
      print('username: ${res.trendingPost[0].userName}');
      print('posttime: ${res.trendingPost[0].createdAt}');
      print('cheer: ${res.trendingPost[0].cheers}');
      print('comments: ${res.trendingPost[0].commentCount}');
      print('awards: ${res.trendingPost[0].awardType.length}');
      print('title: ${res.trendingPost[0].title}');
      print('des: ${res.trendingPost[0].content}');
      print('multi: ${res.trendingPost[0].multimedia}');
      print('userpic: ${res.localPost[0].proPic}');
      print('username: ${res.localPost[0].userName}');
      print('posttime: ${res.localPost[0].createdAt}');
      print('cheer: ${res.localPost[0].cheers}');
      print('comments: ${res.localPost[0].commentCount}');
      print('awards: ${res.localPost[0].awardType.length}');
      print('title: ${res.localPost[0].title}');
      print('des: ${res.localPost[0].content}');
      print('multi: ${res.localPost[0].multimedia}');
      return res;
      // return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      final message = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  // @override
  // Future<String> handleJoinRequest({required String communityId, required String requestId, required String status}) {
  //   // TODO: implement handleJoinRequest
  //   throw UnimplementedError();
  // }

  // getSearchHistoryAndTrends
}
