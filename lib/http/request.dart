class Request {
  final String method;
  final String path;
  final Map<String, String> headers;
  final dynamic body;

  Request(this.method, this.path, this.headers, this.body);
}