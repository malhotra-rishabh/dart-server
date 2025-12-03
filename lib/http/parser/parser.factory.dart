import 'urlencoded.dart';
import 'application.dart';
import 'text.dart';
import 'yaml.dart';
import 'xml.dart';

class ParserFactory {
  final List<String> supportedContentTypes = [
    'application/json',
    'application/x-www-form-urlencoded',
    'text/plain; charset=utf-8',
    'text/yaml; charset=utf-8',
    'application/xml; charset=utf-8'
  ];

  intializeParser(parserType) {
    if (supportedContentTypes.contains(parserType)) {
      if (parserType == 'application/x-www-form-urlencoded') {
        return new UrlEncoded();
      } else if (parserType == 'application/json') {
        return new ApplicationJSON();
      } else if (parserType == 'text/plain; charset=utf-8') {
        return new TextPlain();
      } else if (parserType == 'text/yaml; charset=utf-8') {
        return new YamlParser();
      } else if (parserType == 'application/xml; charset=utf-8') {
        return new XmlParser();
      }
    } else {
      throw Exception('Unsupported parser type: $parserType');
    }
  }
}