import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:grammar_checker_app_updated/Controllers/TTS_Controller.dart';
import 'package:grammar_checker_app_updated/core/databaseHelper/LocalDatabase.dart';
import 'package:grammar_checker_app_updated/core/utils/filertAiResponse.dart';

import '../../../../core/databaseHelper/HiveDatabase/SaveMessagesService.dart';
import '../../../../core/model/TutorModels/MessageModel.dart';
import '../../../../core/model/TutorModels/tutorModel.dart';
import '../../../../data/apiResponse.dart';

class ChatController extends GetxController {
  var messageCount = 0.obs;
  var spekingMsg = "".obs;
  List<SaveMessagesModel> messagesList = [];
  var isLoading = false.obs;
  var premiumMessage =
      "Hello, 🌟 Ready to take your English skills to the next level? Unlock our premium plan for exclusive lessons, personalized feedback, and more! Let's make learning fun and effective together. What do you say? 📚✨";

  var greetingMessage = ''.obs;

  getWelcomeMessage(TutorModel tutor) {
    String purposes = tutor.learningPurposes.join(", ");
    greetingMessage.value =
        "Hello ${tutor.userName} 👋 I'm ${tutor.tutorName}, your English learning tutor. I see that you're at the ${tutor.selectedLevel} level and your native language is ${tutor.nativeLanguage}. Your goals are to improve your learning for ${purposes} purposes. I'm here to help you achieve those goals and make learning fun and effective. Let's get started on this exciting journey together! 🌟";
  }

  String generateAiPrompt(
      TutorModel tutor, String userMessage, String conversationHistory) {
    String purposes = tutor.learningPurposes.join(", ");
    return '''
You are a highly skilled, patient, and engaging English and Grammar tutor specializing in personalized one-on-one text-based instruction. You adapt to each student's individual needs, learning pace, and goals. Your expertise encompasses all aspects of English language learning, from fundamental grammar to advanced writing techniques. **Your core responsibilities:** 1. **Diagnostic Assessment:** At the beginning of each interaction (or as needed), briefly assess the student's current understanding of the topic at hand. Ask clarifying questions to pinpoint specific areas of difficulty. 2. **Targeted Instruction:** Provide clear, concise, and engaging explanations of grammar rules, vocabulary, and writing concepts. Use real-world examples, analogies, and visual aids (if appropriate for text-based communication, such as using formatting for emphasis or creating simple diagrams with text characters) to enhance understanding. 3. **Interactive Practice:** Incorporate interactive exercises, quizzes, and writing prompts to reinforce learning and provide opportunities for students to apply their knowledge. Offer immediate feedback on their responses, explaining both correct and incorrect answers. 4. **Error Correction and Feedback:** When providing feedback on student writing or speaking, focus on specific areas for improvement, such as grammar, vocabulary, sentence structure, clarity, and coherence. Offer constructive criticism and suggest practical strategies for improvement. Avoid simply marking errors; explain *why* they are incorrect and how to correct them. 5. **Adaptive Learning:** Continuously monitor the student's progress and adjust your teaching approach as needed. If a student is struggling with a particular concept, provide additional explanations, examples, or practice exercises. If they are progressing quickly, introduce more challenging material. 6. **Motivational Support:** Foster a positive and encouraging learning environment. Offer praise and encouragement for effort and progress. Help students build confidence in their language abilities. 7. **Contextual Learning:** Connect grammar rules and vocabulary to real-world contexts, such as everyday conversations, academic writing, or professional communication. This helps students understand the practical application of their learning. 8. **Handling Specific Requests:** Be prepared to address specific student requests, such as help with essay writing, exam preparation, or business English. **Example Interaction (demonstrating diagnostic assessment and targeted instruction):** * **Student:** "I don't understand when to use 'who' and 'whom.'" * **Tutor:** "That's a great question! It's a common point of confusion. Let's break it down. First, can you tell me what you already know about these words?" (Diagnostic Assessment) * **(After student responds or if they say they don't know anything):** "Okay, 'who' is used as the subject of a verb, while 'whom' is used as the object of a verb or preposition. Think of it this way: 'who' is like 'he/she/they,' and 'whom' is like 'him/her/them.' For example, 'Who is going to the store?' (He is going). 'To whom did you give the book?' (You gave the book to him)." (Targeted Instruction with analogy) **Example of Error Correction with Explanation:** * **Student:** "Me and my friend went to the park." * **Tutor:** "That's close! In formal English, we usually say 'My friend and I went to the park.' When 'I' or 'me' is part of a compound subject (more than one person doing the action), it's generally polite to put the other person first. Also, to determine whether to use 'I' or 'me', try removing the other person. Would you say 'Me went to the park' or 'I went to the park'?" **Crucially:** Maintain a professional, respectful, and patient demeanor at all times. Prioritize clarity, accuracy, and student understanding.   
Your name is ${tutor.tutorName}. Your role is to teach and assist the user, ${tutor.userName}, in improving their English skills. The user is at the ${tutor.selectedLevel} level and their native language is ${tutor.nativeLanguage}. Their goals are to improve their ${purposes}.
Here is the last conversation with the user:
$conversationHistory

Now, continue the conversation accordingly with the flow. Always provide specific teaching content related to the user's learning purposes. For example, if the user wants to learn English for traveling purposes, teach them phrases and sentences they might need when interacting with foreign people, such as how to ask for directions, order food, or make small talk and do same for other purposes also.

User: $userMessage
${tutor.tutorName}:''';
  }

  void scrollToBottom(ScrollController scrollController) {
    if (scrollController.hasClients) {
      scrollController.animateTo(
        scrollController.position.extentTotal,
        duration: const Duration(milliseconds: 20),
        curve: Curves.fastEaseInToSlowEaseOut,
      );
    } else {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => scrollToBottom(scrollController));
    }
  }

  Future<void> askQuestion(
      BuildContext context,
      String text,
      String conversationID,
      TutorModel tutor,
      ScrollController scrollController,
      TTSController ttsController) async {
    if (text.isEmpty) {
      showSnackbar(context, 'Message cannot be empty');
      return;
    }

    isLoading.value = true;
    if (ttsController.isSpeaking.value) {
      await ttsController.stop();
    }
    spekingMsg.value = '';
    // String aiPrompt = generateAiPrompt(tutor) + text;
    // Retrieve the last three messages from the conversation
    List<SaveMessagesModel> lastMessages = messagesList.length > 3
        ? messagesList.sublist(messagesList.length - 3)
        : messagesList;

    // Format the last messages for the prompt
    String conversationHistory = lastMessages.map((message) {
      log("${message.sender}: ${message.message}");
      return "${message.sender}: ${message.message}";
    }).join("\n");

    // Generate the AI prompt with the conversation history
    String aiPrompt = generateAiPrompt(tutor, text, conversationHistory);

    String response = await APIs.makeGeminiRequest(aiPrompt);
    spekingMsg.value = await filterTutorResponse(response);

    if (response.isNotEmpty) {
      var message = createMessageObject(
          "Bot", response, true, TimeOfDay.now().format(context));
      saveMessageToConversation(message, conversationID);
      if (ttsController.isSpeaking.value) {
        await ttsController.stop();
        ttsController.speak(spekingMsg.value);
      } else {
        ttsController.speak(spekingMsg.value);
      }
    } else {
      print("Invalid response");
    }

    isLoading.value = false;
    scrollToBottom(scrollController);
  }

  // Future<void> askChatAIQuestion(BuildContext context, String text,
  //     String conversationID, ScrollController scrollController) async {
  //   if (text.isEmpty) {
  //     showSnackbar(context, 'Message cannot be empty');
  //     return;
  //   }

  //   isLoading.value = true;

  //   print("Final Prompt: $text");
  //   String response = await APIs.makeGeminiRequest(text);

  //   if (response.isNotEmpty) {
  //     var message = createMessageObject(
  //         "Bot", response, true, TimeOfDay.now().format(context));
  //     saveMessageToConversation(message, conversationID);
  //   } else {
  //     print("Invalid response");
  //   }

  //   isLoading.value = false;
  //   scrollToBottom(scrollController);
  // }

  SaveMessagesModel createMessageObject(
      String sender, String message, bool isSender, String time) {
    return SaveMessageService.saveMessageObject(
        sender, message, isSender, time);
  }

  void saveMessageToConversation(
      SaveMessagesModel message, String conversationID) {
    SaveMessageService.saveConversation(message, conversationID);
  }

  void clearConversation(String conversationID) {
    SaveMessageService.clearConversation(conversationID);
  }

  void deleteConversation(String conversationID) {
    SaveMessageService.deleteConversation(conversationID);
  }

  void deleteGirlfriend(String conversationID) async {
    int deletedCount = await DatabaseHelper().deleteTutor(conversationID);
    if (deletedCount > 0) {
      print("Girlfriend entry deleted from the database.");
    } else {
      print("No entry found for deletion.");
    }
  }

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
