import 'request.dart';
import 'parser/parser.factory.dart';

class HttpParser {
  static Request parse(String raw) {
    final lines = raw.split('\r\n');

    final requestLine = lines.first.split(' ');
    final method = requestLine[0];
    final path = requestLine[1];
    final uri = Uri.parse(path);

    final headers = <String, String>{};
    int i = 1;

    // Parse headers
    for (; i < lines.length; i++) {
      if (lines[i].isEmpty) break; // end of headers
      final split = lines[i].split(': ');
      if (split.length == 2) {
        headers[split[0]] = split[1];
      }
    }

    // Everything after headers is the body
    final body = lines.sublist(i + 1).join('\r\n');

    final parserFactory = ParserFactory();
    final contentType = headers['Content-Type'] ?? 'text/plain';
    final parser = parserFactory.intializeParser(contentType);
    final parsedBody = parser.parse(body);

    return Request(method, uri.path, headers, parsedBody, uri.queryParameters, {});
  }
}
