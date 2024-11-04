// const String instruction = """
// Generate a list of quiz questions categorized by difficulty. Provide exactly 10 questions for each difficulty level: Easy, Intermediate, and Hard. Each question should have the following details, formatted exactly as specified:

// 1. **Difficulty Level:** <Easy, Intermediate, Hard>
// 2. **Quiz Question:** <quiz question>
// 3. **Multiple Choice A:** <choice A>
// 4. **Multiple Choice B:** <choice B>
// 5. **Multiple Choice C:** <choice C>
// 6. **Multiple Choice D:** <choice D>
// 7. **Correct Answer:** When providing the Correct Answer for each quiz question, do not include any option labels (A, B, C, or D). Instead, write only the exact answer text as the Correct Answer (e.g., if the correct answer is "YOU," only respond with "YOU" and not with any labels). This Correct Answer text will be compared directly in the app's UI.

// Example:

// **Quiz Question:** Which of the following actions is NOT synonymous with abrogate -----?
// **Difficulty Level:** Intermediate
// **Multiple Choice A:** Annul
// **Multiple Choice B:** Enact
// **Multiple Choice C:** Rescind
// **Multiple Choice D:** Repeal
// **Correct Answer:** Enact

// all the above feilds should be in every question.
// Ensure that each question and its details are clearly separated and formatted exactly as shown in the example above, without any extra characters or numbering.
// """;
const String instruction = """
Generate a JSON object containing exactly 21 quiz questions of (English Grammar only), divided into 7 questions for each difficulty level: Easy, Intermediate, and Hard. Format the response as a JSON object beginning with { "data": [...]} and nothing else. Each question should have the following fields:

1. **Difficulty Level:** <Easy, Intermediate, Hard>
2. **Quiz Question:** <quiz question>
3. **Multiple Choice A:** <choice A>
4. **Multiple Choice B:** <choice B>
5. **Multiple Choice C:** <choice C>
6. **Multiple Choice D:** <choice D>
7. **Correct Answer:** Provide only the exact answer text without any option labels (A, B, C, or D).

Example JSON format: Map<String, dynamic>
{
  "data": [
    {
      "Difficulty Level": "Intermediate",
      "Quiz Question": "Which of the following actions is NOT synonymous with abrogate?",
      "Multiple Choice A": "Annul",
      "Multiple Choice B": "Enact",
      "Multiple Choice C": "Rescind",
      "Multiple Choice D": "Repeal",
      "Correct Answer": "Enact"
    },
    
  ]
}
Important!: Make Sure all the questions are related to English Grammar only!!!
Important!: Make sure that question are 21 in total and 7 questions for each difficulty level: Easy, Intermediate, and Hard.
Ensure each question in the list includes all fields exactly as shown, and structure the JSON response as specified. Do not add any extra characters, explanations, or notes.
your response should  strictly contain this santax. no other extra word or character or any other information. 

{
  "data": [

]
}

""";



  // static List<QuizModel> parseGeneratedContent(String generatedContent) {
  //   var lines = generatedContent.split('\n');
  //   var quizList = <QuizModel>[]; // Changed to List<QuizModel>
  //   var currentQuizData = <String, dynamic>{};
  //   var requiredKeys = [
  //     "Difficulty Level",
  //     "Quiz Question",
  //     "Multiple Choice A",
  //     "Multiple Choice B",
  //     "Multiple Choice C",
  //     "Multiple Choice D",
  //     "Correct Answer"
  //   ];

  //   for (var line in lines) {
  //     if (line.trim().isNotEmpty) {
  //       if (line.startsWith('**')) {
  //         var parts = line.split('**');
  //         if (parts.length >= 3) {
  //           var key = parts[1].replaceAll(':', '').trim();
  //           var value = parts[2].trim();

  //           // Start a new question entry if "Difficulty Level" is found and currentDataMap is not empty
  //           if (key == "Difficulty Level" && currentQuizData.isNotEmpty) {
  //             // Ensure all required keys are present before adding the question
  //             if (requiredKeys.every((k) =>
  //                 currentQuizData.containsKey(k) &&
  //                 currentQuizData[k].isNotEmpty)) {
  //               quizList.add(QuizModel(
  //                 difficultyLevel: currentQuizData["Difficulty Level"],
  //                 quizQuestion: currentQuizData["Quiz Question"],
  //                 multipleChoiceA: currentQuizData["Multiple Choice A"],
  //                 multipleChoiceB: currentQuizData["Multiple Choice B"],
  //                 multipleChoiceC: currentQuizData["Multiple Choice C"],
  //                 multipleChoiceD: currentQuizData["Multiple Choice D"],
  //                 correctAnswer: currentQuizData["Correct Answer"],
  //               ));
  //             }
  //             // Reset currentQuizData for the next question
  //             currentQuizData = <String, dynamic>{};
  //           }

  //           // Only add keys if they are in the required keys list
  //           if (requiredKeys.contains(key)) {
  //             currentQuizData[key] = value;
  //           }
  //         }
  //       }
  //     }
  //   }

  //   // Check the last question in the list
  //   if (currentQuizData.isNotEmpty &&
  //       requiredKeys.every((k) =>
  //           currentQuizData.containsKey(k) && currentQuizData[k].isNotEmpty)) {
  //     quizList.add(QuizModel(
  //       difficultyLevel: currentQuizData["Difficulty Level"],
  //       quizQuestion: currentQuizData["Quiz Question"],
  //       multipleChoiceA: currentQuizData["Multiple Choice A"],
  //       multipleChoiceB: currentQuizData["Multiple Choice B"],
  //       multipleChoiceC: currentQuizData["Multiple Choice C"],
  //       multipleChoiceD: currentQuizData["Multiple Choice D"],
  //       correctAnswer: currentQuizData["Correct Answer"],
  //     ));
  //   }

  //   log("Parsed data: $quizList");
  //   return quizList;
  // }