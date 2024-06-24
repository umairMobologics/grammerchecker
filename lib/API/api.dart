import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:grammer_checker_app/API/Api_Key.dart';
import 'package:grammer_checker_app/utils/snackbar.dart';
import 'package:http/http.dart' as http;

class APIs {
 
  static Future<String> makeGeminiRequest(String promt) async {
   
    String apiUrl =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

    // Replace the following JSON with your actual request payload
    Map<String, dynamic> requestBody = {
      "contents": [
        {
          "parts": [
            {"text": promt}
          ]
        }
      ]
    };

    try {
      // Make a POST request
      // log("sending responsee");
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(requestBody),
      );
      log(response.body);
      if (response.statusCode == 200) {
        log("status ok");
        var jsonResponse = jsonDecode(response.body);

        // Check if the 'candidates' array is present and not empty
        if (jsonResponse.containsKey('candidates') &&
            jsonResponse['candidates'].isNotEmpty) {
          var content = jsonResponse['candidates'][0]['content'];

          // Check if the 'parts' array is present and not empty
          if (content.containsKey('parts') && content['parts'].isNotEmpty) {
            var generatedContent = content['parts'][0]['text'];
            return (generatedContent);
          } else {
            return ('');
          }
        } else {
          return ('');
        }
      } else {
        // Handle error
        // print('Response: ${response.body}');
        return ('');
      }
    } catch (e) {
      // Handle exceptions
      log("$e");
      CustomSnackbar.showSnackbar("Something went wrong, please try again!" , SnackPosition.BOTTOM );
      return ('');
    }
  }
}
