import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String apiUrl = dotenv.env['API_URL'] ?? '';
  final String apiAction = dotenv.env['API_ACTION'] ?? '';

  /// Login function to authenticate user with username and password.
  /// Throws an exception if the API call fails.
  Future<Map<String, dynamic>> login(String username, String password) async {
    // Validate inputs
    if (username.isEmpty) {
      throw ArgumentError("Username cannot be empty");
    }
    if (password.isEmpty) {
      throw ArgumentError("Password cannot be empty");
    }
    if (apiUrl.isEmpty || apiAction.isEmpty) {
      throw Exception("API configuration is missing. Check .env file.");
    }

    // Prepare the request body
    final body = {
      "API_Body": [
        {"Unique_Id": "", "Pw": password}
      ],
      "Api_Action": apiAction,
      "Company_Code": username,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['Status_Code'] != 200) {
          throw Exception("API error: ${responseBody['Message']}");
        }
        return responseBody;
      } else {
        _handleHttpError(response);
      }
    } catch (error) {
      throw Exception("An error occurred while logging in: $error");
    }

    return {}; // Unreachable, but required for Dart's return type
  }

  /// Handles HTTP errors based on the response code.
  void _handleHttpError(http.Response response) {
    switch (response.statusCode) {
      case 400:
        throw Exception("Bad Request: ${response.body}");
      case 401:
        throw Exception("Unauthorized: Invalid credentials");
      case 403:
        throw Exception("Forbidden: Access denied");
      case 404:
        throw Exception("Not Found: API endpoint not available");
      case 500:
        throw Exception("Internal Server Error: Please try again later");
      default:
        throw Exception("Unexpected error: ${response.statusCode} - ${response.body}");
    }
  }
}
