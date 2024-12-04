// import 'dart:convert';
// import 'dart:developer';

// import 'package:grammer_checker_app/API/Api_Key.dart';
// import 'package:grammer_checker_app/API/aiPromt.dart';
// import 'package:grammer_checker_app/model/CourseModel.dart';
// import 'package:http/http.dart' as http;

// class CourseAPI {
//   CourseAPI();

//   static String _apiUrl =
//       'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey';

//   static Future<List<CourseModel>> fetchourseResponse() async {
//     log("sendig resquest");
//     Map<String, dynamic> requestBody = {
//       "contents": [
//         {
//           "parts": [
//             {
//               "text": coursePrompt,
//             }
//           ]
//         }
//       ]
//     };

//     try {
//       var response = await http.post(
//         Uri.parse(_apiUrl),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestBody),
//       );

//       if (response.statusCode == 200) {
//         var jsonResponse = jsonDecode(response.body);

//         if (jsonResponse is Map) {
//           log('jsonResponse is a Map');

//           if (jsonResponse.containsKey('candidates') &&
//               jsonResponse['candidates'].isNotEmpty) {
//             var content = jsonResponse['candidates'][0]['content'];

//             if (content is Map) {
//               log('content is a Map');

//               if (content.containsKey('parts') && content['parts'].isNotEmpty) {
//                 var parts = content['parts'];

//                 if (parts is List) {
//                   log('parts is a List');

//                   var generatedContent = parts[0]['text'];
//                   log("Generated content is $generatedContent");
//                   // Parse the JSON and get a list of QuizModel
//                   List<CourseModel> quizList = parseQuizData(generatedContent);

//                   log("data is $quizList");
//                   // Save each word detail to the database
//                   if (quizList[0].correctAnswer == "A" ||
//                       quizList[0].correctAnswer == "B" ||
//                       quizList[0].correctAnswer == "C" ||
//                       quizList[0].correctAnswer == "D") {
//                     //it means answers are not correct call api again
//                     return [];
//                   } else {
//                     // _saveWordToDatabase(quizList);

//                     return quizList;
//                   }
//                 } else {
//                   log('Unexpected type for parts, expected List.');
//                 }
//               } else {
//                 log('No parts found or parts is empty.');
//               }
//             } else {
//               log('Unexpected type for content, expected Map.');
//             }
//           } else {
//             log('No candidates found or candidates is empty.');
//           }
//         } else {
//           log('Unexpected type for jsonResponse, expected Map.');
//         }
//       } else {
//         log('Something went wrong, please try again!');
//         log(response.body);
//       }
//     } catch (e) {
//       log('Error: $e');
//     }
//     return []; // Return an empty list if data could not be fetched
//   }

//   // // static Future<void> _saveWordToDatabase(List<QuizModel> wordsDetsils) async {
//   // //   await DatabaseHelper().saveWordToDatabase(wordsDetsils);
//   // // }

//   // Function to convert JSON data to a list of QuizModel instances
//   static List<CourseModel> parseQuizData(dynamic jsonData) {
//     // Check if jsonData is a string and decode it if necessary
//     if (jsonData is String) {
//       jsonData = json.decode(jsonData);
//     }

//     List<CourseModel> quizList = [];

//     // Parse the data if it's in map form
//     if (jsonData['data'] != null) {
//       for (var item in jsonData['data']) {
//         quizList.add(CourseModel.fromJson(item));
//       }
//     }

//     return quizList;
//   }
// }
