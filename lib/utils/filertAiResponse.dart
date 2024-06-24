String filterResponse(String response)  {
  // Remove lines containing only asterisks
  String filteredResponse = response.replaceAll('*', '');

  return filteredResponse;
}
