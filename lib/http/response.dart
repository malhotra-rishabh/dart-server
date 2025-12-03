import 'dart:convert';

class Response {
  int statusCode = 200;
  String statusMessage = "OK";
  Map<String, String> headers = {};
  String body = "";

  void setHeader(String k, String v) => headers[k] = v;

  List<int> build() {
    headers['Content-Length'] = utf8.encode(body).length.toString();
    headers['Content-Type'] = headers['Content-Type'] ?? 'text/plain';

    final buffer = StringBuffer();
    buffer.write("HTTP/1.1 $statusCode $statusMessage\r\n");

    headers.forEach((k, v) => buffer.write("$k: $v\r\n"));
    buffer.write("\r\n");
    buffer.write(body);

    return utf8.encode(buffer.toString());
  }
}
