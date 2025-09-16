import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:neighborly_flutter_app/features/valuable/report_reason_model.dart';

import '../../core/constants/constants.dart';
import '../../core/error/exception.dart';
import '../../core/utils/set_auth.dart';
import '../../core/utils/shared_preference.dart';
import 'category_model.dart';

class InsightService {
  static const String baseUrl = "$kBaseUrl/insights";

  InsightService();

  Future<InsightsResponse> fetchInsights({
    required double lat,
    required double lon,
  }) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Oops, something went wrong');
    }
print('what is lat lng: $lat $lon');
    final url = Uri.parse("$baseUrl?lat=$lat&lon=$lon");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
    );

    debugPrint("FETCH INSIGHTS => ${response.body}");

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      final Map<String, dynamic> data = json.decode(response.body);

      return InsightsResponse.fromJson(data);
    } else {
      String errorMessage = jsonDecode(response.body)['error'] ??
          jsonDecode(response.body)['message'] ??
          jsonDecode(response.body)['msg'] ??
          'Oops, something went wrong';

      throw ServerException(message: errorMessage);
    }
  }

  // ✅ Vote API
  Future<bool> voteOnInsight(String insightId, String voteType) async {
    String? cookies = ShardPrefHelper.getCookie();
    String? accessToken = ShardPrefHelper.getAccessToken();

    if (cookies == null || cookies.isEmpty) {
      throw const ServerException(message: 'Missing credentials');
    }

    final url = Uri.parse("$baseUrl/$insightId/vote");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
        'Cookie': cookies,
      },
      body: jsonEncode({"vote": voteType}), // cheer or boo
    );

    debugPrint("VOTE => ${response.body}");

    if (response.statusCode == 200) {
      handleAuthHeaders(response.headers);
      print('data: ${response.body}');
      return true;
    } else {
      debugPrint("Vote failed: ${response.body}");
      return false;
    }
  }
  Future<List<ReportReason>> fetchReportReasons() async {
    final url = Uri.parse("$baseUrl/report-reasons");
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${ShardPrefHelper.getAccessToken()}',
      'Cookie': ShardPrefHelper.getCookie() ?? '',
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return  data.map((e)=>ReportReason.fromJson(e)).toList();
      // return data.map((e) => ReportReason.fromJson(e)).toList();
    } else {
      throw ServerException(message: 'Failed to load report reasons');
    }
  }

  Future<void> sendReport(String insightId, String reason) async {
    final url = Uri.parse("$baseUrl/$insightId/report");

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${ShardPrefHelper.getAccessToken()}',
        'Cookie': ShardPrefHelper.getCookie() ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({"reason": reason}),
    );

    if (response.statusCode != 202) {
      throw ServerException(message: 'Report not accepted');
    }
  }

  Future<void> addInsight({
    required String categoryId,
    required String title,
    required String summary,
  }) async {
    double lat = ShardPrefHelper.getLat() ?? 0.0;
    double lng = ShardPrefHelper.getLng() ?? 0.0;

    // Add query parameters to the URL
    final url = Uri.parse("$baseUrl").replace(
      queryParameters: {
        'lat': lat.toString(),
        'lon': lng.toString(),
      },
    );

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer ${ShardPrefHelper.getAccessToken()}',
        'Cookie': ShardPrefHelper.getCookie() ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "category_id": categoryId,
        "title": title,
        "summary": summary,
      }),
    );
if(response.statusCode==200 || response.statusCode==201){
  print('done ${response.body}');
}
    if (response.statusCode != 201 && response.statusCode != 200) {
      print('done ${response.body}');
      throw ServerException(message: 'Insight not added');
    }
  }

}
