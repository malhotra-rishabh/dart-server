import 'package:xml2json/xml2json.dart';
import 'dart:convert';

class XmlParser {
  parse(data) {
    final xml2Json = Xml2Json();
    xml2Json.parse(data);

    final jsonString = xml2Json.toParker();
    return jsonDecode(jsonString);
  }
}