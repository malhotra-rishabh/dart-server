import 'dart:io';
import 'dart:convert';
import '../router/router.dart';
import '../http/parser.dart';
import '../http/response.dart';

class ConnectionHandler {
  final Socket socket;
  final Router router;

  ConnectionHandler(this.socket, this.router);

  Future<void> handle() async {
    // 1) Read headers only
    final headerBuffer = <int>[];
    int headerEndIndex = -1;

    await for (final chunk in socket) {
      headerBuffer.addAll(chunk);

      // Look for \r\n\r\n in bytes
      headerEndIndex = _findHeaderEnd(headerBuffer);
      if (headerEndIndex != -1) break;
    }

    if (headerEndIndex == -1) {
      socket.destroy();
      return;
    }

    // Convert ONLY headers to text
    final headerText = utf8.decode(
      headerBuffer.sublist(0, headerEndIndex),
      allowMalformed: true,
    );

    // 2) Parse content-length
    final headers = _parseHeaders(headerText);
    final contentLength = int.tryParse(headers['Content-Length'] ?? '0') ?? 0;

    // 3) Read remaining body bytes
    final bodyBytes = <int>[];

    // Add any leftover bytes from headerBuffer
    final leftoverStart = headerEndIndex + 4; // skip \r\n\r\n
    if (leftoverStart < headerBuffer.length) {
      bodyBytes.addAll(headerBuffer.sublist(leftoverStart));
    }

    while (bodyBytes.length < contentLength) {
      final chunk = await socket.first;
      bodyBytes.addAll(chunk);
    }

    // 4) Build request
    final req = HttpParser.parse(headerText, bodyBytes);
    final res = Response();

    router.handle(req, res);

    // 5) Send response
    socket.add(res.build());
    await socket.flush();
    await socket.close();
  }

  /// Find \r\n\r\n in byte list
  int _findHeaderEnd(List<int> bytes) {
    for (int i = 3; i < bytes.length; i++) {
      if (bytes[i - 3] == 13 && // \r
          bytes[i - 2] == 10 && // \n
          bytes[i - 1] == 13 && // \r
          bytes[i] == 10) {     // \n
        return i - 3;
      }
    }
    return -1;
  }

  /// Parse headers text into a Map
  Map<String, String> _parseHeaders(String headerText) {
    final lines = headerText.split('\r\n');
    final map = <String, String>{};

    for (var i = 1; i < lines.length; i++) {
      if (lines[i].trim().isEmpty) break;
      final parts = lines[i].split(': ');
      if (parts.length == 2) map[parts[0]] = parts[1];
    }

    return map;
  }
}