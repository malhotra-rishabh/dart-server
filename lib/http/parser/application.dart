import 'dart:convert';

class ApplicationJSON {
  parse(body) {
    return body.isNotEmpty ? jsonDecode(body) : {};
  }
}