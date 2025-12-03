class UrlEncoded {
  parse(data) {
    final Map<String, String> result = {};
    final pairs = data.split('&');

    for (var pair in pairs) {
      final keyValue = pair.split('=');
      if (keyValue.length == 2) {
        final key = Uri.decodeComponent(keyValue[0]);
        final value = Uri.decodeComponent(keyValue[1]);
        result[key] = value;
      }
    }

    return result;
  }
}