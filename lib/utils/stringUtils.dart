/// Returns true if input contains any number
bool containsNumber(String input) {
  return RegExp(r"[0-9]").allMatches(input).length > 0;
}

/// Returns true if input contains any (english) letter
bool containsLetter(String input) {
  return RegExp(r"[a-zA-Z]").allMatches(input).length > 0;
}