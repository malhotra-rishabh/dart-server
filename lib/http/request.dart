import 'uploaded_file.dart';

class Request {
  final String method;
  final String path;
  final Map<String, String> headers;
  final dynamic body;
  final Map<String, String> query;
  final Map<String, String> params;
  final List<UploadedFile> files;
  final Map<String, String> fields;

  Request(this.method, this.path, this.headers, this.body, this.query, this.params, this.files, this.fields);
}