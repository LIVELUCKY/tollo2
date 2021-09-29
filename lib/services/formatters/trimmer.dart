String trimTill(String string, String searched) {
  if (searched.length == 0) return string;
  List<String> x = string.split(searched);
  try {
    return searched + x[1];
  } catch (e) {
    return string;
  }
}
