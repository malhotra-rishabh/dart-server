import 'dart:convert';
import 'dart:typed_data';

import 'request.dart';
import 'parser/parser.factory.dart';
import 'uploaded_file.dart';

class HttpParser {
  static Request parse(String headerText, List<int> bodyBytes) {
    final lines = headerText.split('\r\n');

    // ---- Request line ----
    final requestLine = lines.first.split(' ');
    final method = requestLine[0];
    final path = requestLine[1];
    final uri = Uri.parse(path);

    // ---- Headers ----
    final headers = <String, String>{};
    int i = 1;

    for (; i < lines.length; i++) {
      if (lines[i].isEmpty) break;
      final split = lines[i].split(': ');
      if (split.length == 2) {
        headers[split[0]] = split[1];
      }
    }

    // ---- Select parser ----
    final parserFactory = ParserFactory();
    final contentType = headers['Content-Type'] ?? 'text/plain';
    final parser = parserFactory.intializeParser(contentType);

    dynamic parsedBody;
    List<UploadedFile> files = [];
    Map<String, String> fields = {};

    // ---- MULTIPART FORM DATA (file uploads) ----
    if (contentType.startsWith('multipart/form-data')) {
      // Multipart parser MUST accept raw bytes now
      final result = parser.parse(bodyBytes, contentType);

      files = result['files'] ?? [];
      fields = Map<String, String>.from(result['fields'] ?? {});
      parsedBody = {}; // keep body empty for multipart
    }

    // ---- OTHER BODY TYPES (JSON, URLEncoded, plaintext) ----
    else {
      final bodyString = utf8.decode(bodyBytes, allowMalformed: true);
      parsedBody = parser.parse(bodyString);
    }

    return Request(
      method,
      uri.path,
      headers,
      parsedBody,
      uri.queryParameters,
      {},       // router will fill path params
      files,
      fields,
    );
  }
}
