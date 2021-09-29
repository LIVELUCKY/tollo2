DateTime buildParse(String path) {
  return DateTime.parse(path.substring(0, path.length - 4).split('/').last);
}
