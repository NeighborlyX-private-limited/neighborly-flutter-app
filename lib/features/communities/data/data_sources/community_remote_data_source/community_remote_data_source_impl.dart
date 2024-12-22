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

  /// create community api call
  @override
  Future<String> createCommunity({
    required CommunityModel community,
    File? pictureFile,
  }) async {
    print('... createCommunity start with');
    print('community=$community');
    print('pictureFile=${pictureFile?.path}');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');
    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in createCommunity');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/create';
    print('url=$url');

    Map<String, dynamic> queryParameters;

    bool isHome = true;
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    isHome = isLocationOn ? false : true;
    print('isHome:$isHome');

    if (isHome) {
      List<double> location = ShardPrefHelper.getHomeLocation();
      double lat = location[0];
      double long = location[1];
      print('lat in create group ==> $lat');
      print('long in create group ==> $long');
      queryParameters = {
        'latitude': '$lat',
        'longitude': '$long',
      };
    } else {
      List<double> location = ShardPrefHelper.getLocation();
      double lat = location[0];
      double long = location[1];

      print('lat in create group ==> $lat');
      print('long in create group ==> $long');
      queryParameters = {
        'latitude': '$lat',
        'longitude': '$long',
      };
    }

    /// Create a multipart request
    final request = http.MultipartRequest(
      'POST',
      Uri.parse(url).replace(queryParameters: queryParameters),
    )
      ..headers['Cookie'] = cookieHeader
      ..fields['name'] = community.name
      ..fields['isOpen'] = community.isPublic.toString()
      ..fields['description'] = community.description
      ..fields['radius'] = '${community.radius}'
      ..fields['karma'] = community.karma.toString();

    /// Add multimedia file if available
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

    // Send the request and handle the response
    final response = await request.send();
    final responseString = await response.stream.bytesToString();
    print('createCommunity status code: ${response.statusCode}');
    print('createCommunity response: $responseString');
    if (response.statusCode == 200) {
      return jsonDecode(responseString)['group']['_id'];
    } else {
      print(
          'else error in createCommunity: ${jsonDecode(responseString)['error'] ?? jsonDecode(responseString)['msg'] ?? 'oops omething went wrong'}');
      final errorMessage = jsonDecode(responseString)['error'] ??
          jsonDecode(responseString)['msg'] ??
          'oops omething went wrong';
      throw ServerException(message: errorMessage);
    }
  }

  /// get all community api call
  @override
  Future<List<CommunityModel>> getAllCommunities() async {
    print('... getAllCommunities start with');
    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in getAllCommunities');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/nearby-groups';
    print('url=$url');

    Map<String, dynamic> queryParameters;

    bool isHome = true;
    var isLocationOn = ShardPrefHelper.getIsLocationOn();
    isHome = isLocationOn ? false : true;
    print('isHome:$isHome');

    if (isHome) {
      List<double> location = ShardPrefHelper.getHomeLocation();
      double lat = location[0];
      double long = location[1];
      print('lat in getAllCommunities ==> $lat');
      print('long in getAllCommunities ==> $long');
      queryParameters = {
        'latitude': '$lat',
        'longitude': '$long',
      };
    } else {
      List<double> location = ShardPrefHelper.getLocation();
      double lat = location[0];
      double long = location[1];

      print('lat in getAllCommunities ==> $lat');
      print('long in getAllCommunities ==> $long');
      queryParameters = {
        'latitude': '$lat',
        'longitude': '$long',
      };
    }
    final response = await client.get(
      Uri.parse(url).replace(queryParameters: queryParameters),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print('getAllCommunities status code: ${response.statusCode}');
    print('getAllCommunities response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      print(
          'else error in getAllCommunities: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  /// get user group api call
  @override
  Future<List<CommunityModel>> getUserGroups() async {
    print('... getUserGroups start with');
    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in getUserGroups');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/user-groups';
    print('url=$url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print('getUserGroups status code: ${response.statusCode}');
    print('getUserGroups response: ${response.body}');
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((data) => CommunityModel.fromJson(data)).toList();
    } else {
      print(
          'else error in getUserGroups: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///get community api call
  @override
  Future<CommunityModel> getCommunity({required String communityId}) async {
    print('....getCommunity start with');
    print('communityId=$communityId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in getCommunity');
      throw const ServerException(message: 'oops omething went wrong');
    }

    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/fetch-group-details/$communityId';
    print('url=$url');

    final response = await client.get(
      Uri.parse(url),
      headers: <String, String>{
        'Cookie': cookieHeader,
      },
    );
    print('getCommunity status code: ${response.statusCode}');
    print('getCommunity response: ${response.body}');
    if (response.statusCode == 200) {
      return CommunityModel.fromJson(jsonDecode(response.body));
    } else {
      print(
          'else error in getCommunity: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  /// make admin api call
  @override
  Future<void> makeAdmin({
    required String communityId,
    required String userId,
  }) async {
    print('... makeAdmin start with');
    print('communityId=$communityId ');
    print('userId=$userId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in makeAdmin');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/add-admin';
    print('url=$url');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
          'groupId': communityId,
        },
      ),
    );
    print('makeAdmin status code: ${response.statusCode}');
    print('makeAdmin response: ${response.body}');
    if (response.statusCode == 200) {
    } else {
      print(
          'else error in makeAdmin: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
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
    print('... removeAdmin start with');
    print('communityId=$communityId ');
    print('userId=$userId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('oops omething went wrong in removeAdmin');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/remove-admin';
    print('url=$url');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, String>{
          'adminId': userId,
          'groupId': communityId,
        },
      ),
    );
    print('removeAdmin status code: ${response.statusCode}');
    print('removeAdmin response: ${response.body}');
    if (response.statusCode == 200) {
    } else {
      print(
          'else error in removeAdmin: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///join/add-user in group api call
  @override
  Future<void> joinGroup({
    required String communityId,
    required String? userId,
  }) async {
    print('... joinGroup group start with');
    print('communityId=$communityId');
    print('userId=$userId');
    if (userId == null) {
      userId = ShardPrefHelper.getUserID() ?? '';
    }
    print('userId=$userId');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('coockies not found in joinGroup');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/add-user';
    print('url=$url');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, String>{
          'userId': userId,
          'groupId': communityId,
        },
      ),
    );
    print('joinGroup status code: ${response.statusCode}');
    print('joinGroup response: ${response.body}');
    if (response.statusCode == 200) {
      print('user added');
    } else {
      print(
          'else error in joinGroup: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///leave/remove-user group
  @override
  Future<void> leaveCommunity({
    required String communityId,
    required String? userId,
  }) async {
    print('... leaveCommunity start with');
    print('communityId=$communityId ');
    print('userId=$userId ');
    if (userId == null) {
      userId = ShardPrefHelper.getUserID() ?? '';
    }
    print('userId=$userId ');
    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in leaveCommunity');
      throw const ServerException(message: 'oops omething went wrong');
    }

    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/remove-user';
    print('url=$url ');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'userId': userId,
        },
      ),
    );
    print('leaveCommunity status code: ${response.statusCode}');
    print('leaveCommunity response: ${response.body}');
    if (response.statusCode == 200) {
      print('user leave');
    } else {
      print(
          'else error in leaveCommunity: ${jsonDecode(response.body)['message'] ?? 'oops omething went wrong'}');
      final message = jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'oops something went wrong';
      throw ServerException(message: message);
    }
  }

  ///update group updateDisplayname
  @override
  Future<void> updateDisplayname({
    required String communityId,
    required String newDisplayname,
  }) async {
    print('... updateDisplayname start with');
    print('communityId=$communityId ');
    print('newDisplayname=$newDisplayname ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateDisplayname');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'displayname': newDisplayname,
        },
      ),
    );
    print('updateDisplayname status code: ${response.statusCode}');
    print('updateDisplayname response: ${response.body}');
    if (response.statusCode == 200) {
      print('display name updated!');
    } else {
      print(
          'else error in updateDisplayname: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

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
    print('... updateDescription start with');
    print('communityId=$communityId ');
    print('newDescription=$newDescription ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateDescription');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'description': newDescription,
        },
      ),
    );
    print('updateDescription status code: ${response.statusCode}');
    print('updateDescription response: ${response.body}');
    if (response.statusCode == 200) {
      print('description updated!');
    } else {
      print(
          'else error in updateDescription: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

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
    print('... updateType start with');
    print('communityId=$communityId ');
    print('newType=$newType ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateType');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    String isOpen = 'true';
    if (newType == 'private') {
      isOpen = 'false';
    }

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'isOpen': isOpen,
        },
      ),
    );
    print('updateType status code: ${response.statusCode}');
    print('updateType response: ${response.body}');
    if (response.statusCode == 200) {
      print('group type changed!');
    } else {
      print(
          'else error in updateType: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

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
    print('... updateIcon start with');
    print('communityId=$communityId ');
    print('pictureFile=$pictureFile');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateIcon');
      throw const ServerException(message: 'oops omething went wrong');
    }

    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    /// Create a multipart request
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse(url),
    )
      ..headers['Cookie'] = cookieHeader
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
    print('updateIcon status code1: ${response.statusCode}');
    print('updateIcon response: $responseString');
    if (response.statusCode == 200) {
      print('icon updated!');
    } else {
      print(
          'else error in updateIcon: ${jsonDecode(responseString)['msg'] ?? 'oops omething went wrong'}');

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
    print('... updateLocation start with');
    print('communityId=$communityId ');
    print('newLocation=$newLocation ');
    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateLocation');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'newLocation': newLocation,
        },
      ),
    );
    print('updateLocation status code: ${response.statusCode}');
    print('updateLocation response: ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      print(
          'else error in updateLocation: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
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
    print('... updateRadius start with');
    print('communityId=$communityId ');
    print('newRadius=$newRadius ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateRadius');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/update-group-details';
    print('url=$url ');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'radius': newRadius,
        },
      ),
    );
    print('updateRadius status code: ${response.statusCode}');
    print('updateRadius response: ${response.body}');
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
    } else {
      print(
          'else error in updateRadius: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///update mute

  @override
  Future<void> updateMute({
    required String communityId,
    required bool isMute,
  }) async {
    print('... updateMute start with');
    print('communityId=$communityId ');
    print('isMute=$isMute ');
    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies ');
    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateMute');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/mute-group';
    print('url=$url ');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'mute': isMute,
        },
      ),
    );
    print('updateMute status code: ${response.statusCode}');
    print('updateMute response: ${response.body.toString()}');

    if (response.statusCode == 204) {
    } else {
      print(
          'else error in updateMute: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

      final message = jsonDecode(response.body)['msg'] ??
          jsonDecode(response.body)['message'] ??
          'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  ///report group
  @override
  Future<void> reportCommunity({
    required String communityId,
    required String reason,
  }) async {
    print('... reportCommunity start with');
    print('communityId=$communityId ');
    print('reason=$reason ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in reportCommunity');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/report-group';
    print('url=$url ');

    final response = await client.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'groupId': communityId,
          'reason': reason,
        },
      ),
    );
    print('reportCommunity status code: ${response.statusCode}');
    print('reportCommunity response: ${response.body}');
    if (response.statusCode == 200) {
    } else {
      print(
          'else error in reportCommunity: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');

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
    print('... deleteCommunity start with');
    print('communityId=$communityId ');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in deleteCommunity');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader ');

    String url = '$kBaseUrl/group/delete-group/$communityId';
    print('url=$url ');

    final response = await client.delete(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
    );
    print('deleteCommunity status code: ${response.statusCode}');
    print('deleteCommunity response: ${response.body}');
    if (response.statusCode == 200) {
      print('Group deleted!');
    } else {
      print(
          'else error in deleteCommunity: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
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
    print('... updateBlock start with');
    print('userId=$userId ');
    print('communityId=$communityId');
    print('isBlock=$isBlock');

    List<String>? cookies = ShardPrefHelper.getCookie();
    print('cookies=$cookies');

    if (cookies == null || cookies.isEmpty) {
      print('cookies not found in updateBlock');
      throw const ServerException(message: 'oops omething went wrong');
    }
    String cookieHeader = cookies.join('; ');
    print('cookieHeader=$cookieHeader');

    String url = '$kBaseUrl/group/block-user';
    print('url=$url');

    final response = await client.put(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Cookie': cookieHeader,
      },
      body: jsonEncode(
        <String, dynamic>{
          'userId': userId,
          'groupId': communityId,
          'block': isBlock,
        },
      ),
    );
    print('updateBlock status code: ${response.statusCode}');
    print('updateBlock response: ${response.body}');
    if (response.statusCode == 200) {
      final msg = jsonDecode(response.body)['msg'] ??
          'check what msg is comming from backend';
      return msg;
    } else {
      print(
          'else error in updateBlock: ${jsonDecode(response.body)['msg'] ?? 'oops omething went wrong'}');
      final message =
          jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
      throw ServerException(message: message);
    }
  }

  @override
  Future<SearchDashModel> getSearchHistoryAndTrends() async {
    print('... getSearchHistoryAndTrends  ');
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
    //   throw const ServerException(message: 'oops omething went wrong');
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
    //   final message = jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
    //   throw ServerException(message: message);
    // }
  }

  @override
  Future<SearchResultModel> getSearchResults({
    required String searchTem,
    required bool isPreview,
  }) async {
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
    //   throw const ServerException(message: 'oops omething went wrong');
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
    //   final message = jsonDecode(response.body)['msg'] ?? 'oops omething went wrong';
    //   throw ServerException(message: message);
    // }
  }

  // getSearchHistoryAndTrends
}
