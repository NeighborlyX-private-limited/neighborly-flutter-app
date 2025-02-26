class ApiEndpoints {
  // PROD BASE URL
  static const String prodBaseUrl = 'https://prod.neighborly.in/api';
  static const String prodNotificationBaseUrl =
      'https://prod.neighborly.in/notification';
  static const String prodSocketBaseUrl = 'http://35.154.40.61:3001';

  // DEV BASE URL
  static const String devBaseUrl = 'https://dev.neighborly.in/api';
  static const String devNotificationBaseUrl =
      'https://dev.neighborly.in/notification';
  static const String devSocketBaseUrl = 'http://35.154.40.61:3002';

  static const String featchPost = '$devBaseUrl/wall/fetch-posts';
}
