import 'dart:convert';
import '../uploaded_file.dart';

class MultipartParser {
  Map<String, dynamic> parse(List<int> bodyBytes, String contentType) {
    final boundary = _extractBoundary(contentType);
    final boundaryBytes = ascii.encode("--$boundary");
    final closingBoundaryBytes = ascii.encode("--$boundary--");

    final files = <UploadedFile>[];
    final fields = <String, String>{};

    int index = 0;

    while (true) {
      // Find next boundary start
      final start = _indexOf(bodyBytes, boundaryBytes, index);
      if (start == -1) break;

      // Check closing boundary
      final isClosing = _indexOf(bodyBytes, closingBoundaryBytes, start) == start;
      if (isClosing) break;

      // Find header end (\r\n\r\n)
      final headerEnd = _indexOf(bodyBytes, ascii.encode("\r\n\r\n"), start);
      if (headerEnd == -1) break;

      final headerBytes = bodyBytes.sublist(start + boundaryBytes.length + 2, headerEnd);
      final headerText = utf8.decode(headerBytes);

      // Find next boundary to get content end
      final nextBoundary = _indexOf(bodyBytes, boundaryBytes, headerEnd + 4);
      if (nextBoundary == -1) break;

      final contentStart = headerEnd + 4;
      final contentEnd = nextBoundary - 2; // remove trailing CRLF

      final partBytes = bodyBytes.sublist(contentStart, contentEnd);

      final nameMatch = RegExp(r'name="([^"]+)"').firstMatch(headerText);
      final filenameMatch = RegExp(r'filename="([^"]+)"').firstMatch(headerText);

      if (nameMatch == null) {
        index = nextBoundary;
        continue;
      }

      final fieldName = nameMatch.group(1)!;

      // ----- FILE PART -----
      if (filenameMatch != null) {
        final filename = filenameMatch.group(1)!;
        final contentTypeMatch =
            RegExp(r'Content-Type: ([^\r\n]+)').firstMatch(headerText);

        final mime = contentTypeMatch?.group(1) ?? "application/octet-stream";

        files.add(UploadedFile(
          filename: filename,
          contentType: mime,
          bytes: partBytes,
        ));
      }
      // ----- TEXT FIELD -----
      else {
        fields[fieldName] = utf8.decode(partBytes);
      }

      index = nextBoundary;
    }

    return {
      "files": files,
      "fields": fields,
    };
  }

  // Safely find byte sequence in byte list
  int _indexOf(List<int> bytes, List<int> pattern, int start) {
    for (int i = start; i <= bytes.length - pattern.length; i++) {
      bool found = true;
      for (int j = 0; j < pattern.length; j++) {
        if (bytes[i + j] != pattern[j]) {
          found = false;
          break;
        }
      }
      if (found) return i;
    }
    return -1;
  }

  String _extractBoundary(String contentType) {
    final match = RegExp(r'boundary=([^;]+)').firstMatch(contentType);
    return match?.group(1) ?? "";
  }
}
