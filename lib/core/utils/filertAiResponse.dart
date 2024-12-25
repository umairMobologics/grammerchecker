import 'dart:developer';

String filterResponse(String response) {
  // Remove lines containing only asterisks
  String filteredResponse = response.replaceAll('*', '').replaceAll("**", "");

  return filteredResponse;
}

String moreFilterResponse(String response) {
  // Remove lines containing only asterisks

  if (response.contains('Corrected')) {
    response = response
        .replaceAll('Corrected Text:', '')
        .replaceAll("Corrected text:", '')
        .replaceAll("corrected text:", '');
  }
  return response;
}

String filterTutorResponse(String response) {
  // Remove asterisks
  response = response.replaceAll('*', '');

  // // Remove emojis using emoji_regex package
  // response = response.replaceAll(emojiRegex, '');
  response = addPausesToText(response);
  log("response after pause :  $response");
  return response;
}

String addPausesToText(String text) {
  // Split the text into sentences using a period, exclamation mark, question mark, or colon followed by a space or newline
  List<String> sentences = text.split(RegExp(r'(?<=[.!?:])\s+'));

  // Join the sentences with a period followed by a space to introduce pauses
  String modifiedText = sentences.join('. ');

  return modifiedText;
}
