import '../http/request.dart';
import '../http/response.dart';

typedef Handler = void Function(Request req, Response res);

class Route {
  final String method;
  final String path;
  final Handler handler;

  Route(this.method, this.path, this.handler);
}
