import 'urlencoded.dart';
import 'application.dart';
import 'text.dart';
import 'yaml.dart';
import 'xml.dart';
import 'multipart.dart';

class ParserFactory {
  final List<String> supportedContentTypes = [
    'application/json',
    'application/x-www-form-urlencoded',
    'text/plain',
    'text/yaml',
    'application/xml',
    'multipart/form-data'
  ];

  intializeParser(parserType) {
    if (supportedContentTypes.contains(parserType) || supportedContentTypes.any((type) => parserType.startsWith(type))) {
      if (parserType == 'application/x-www-form-urlencoded') {
        return new UrlEncoded();
      } else if (parserType == 'application/json') {
        return new ApplicationJSON();
      } else if (parserType.startsWith('text/plain')) {
        return new TextPlain();
      } else if (parserType.startsWith('text/yaml')) {
        return new YamlParser();
      } else if (parserType.startsWith('application/xml')) {
        return new XmlParser();
      } else if (parserType.startsWith('multipart/form-data')) {
        return new MultipartParser();
      }
    } else {
      throw Exception('Unsupported parser type: $parserType');
    }
  }
}