class Request {
  final String method;
  final String path;
  final Map<String, String> headers;
  final dynamic body;
  final Map<String, String> query;
  final Map<String, String> params; 

  Request(this.method, this.path, this.headers, this.body, this.query, this.params);
}