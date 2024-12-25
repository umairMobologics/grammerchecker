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

const String coursePrompt = """
Generate a JSON object containing exactly 5 English grammar questions focusing on **tenses**. Format the response as a JSON object beginning with { "data": [...] } and nothing else. Each question should have the following fields:

1. **Quiz Question**: The question text, covering a concept from **tenses** (e.g., fill-in-the-blank or multiple choice).
2. **Multiple Choice A**: Answer option A
3. **Multiple Choice B**: Answer option B
4. **Multiple Choice C**: Answer option C
5. **Multiple Choice D**: Answer option D
6. **Correct Answer**: Provide only the correct answer text without any option labels (A, B, C, or D).
7. **Explanation**: Provide a detailed explanation of why the correct answer is correct, focusing on the grammar rule involved.

Ensure each question in the list includes all fields exactly as shown, and structure the JSON response as specified. Do not add any extra characters, explanations, or notes.

Your response should strictly contain this syntax. No other extra words, characters, or information.

{
  "data": [

]
}
""";
