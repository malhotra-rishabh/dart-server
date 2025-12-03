import 'package:yaml/yaml.dart';
import 'dart:convert';

class YamlParser {
  parse(body) {
    final yaml = loadYaml(body);
    return yaml is YamlMap ? jsonDecode(jsonEncode(yaml)) : {};
  }
}