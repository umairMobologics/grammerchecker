String filterResponse(String response) {
  // Remove lines containing only asterisks
  String filteredResponse = response.replaceAll('*', '');

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
