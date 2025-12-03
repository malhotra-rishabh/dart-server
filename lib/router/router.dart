import 'route.dart';
import '../http/request.dart';
import '../http/response.dart';

class Router {
  final List<Route> _routes = [];

  void get(String path, Handler handler) {
    _routes.add(Route("GET", path, handler));
  }

  void post(String path, Handler handler) {
    _routes.add(Route("POST", path, handler));
  }

  void put(String path, Handler handler) {
    _routes.add(Route("PUT", path, handler));
  } 

  void delete(String path, Handler handler) {
    _routes.add(Route("DELETE", path, handler));
  }

  void patch(String path, Handler handler) {
    _routes.add(Route("PATCH", path, handler));
  }

  void options(String path, Handler handler) {
    _routes.add(Route("OPTIONS", path, handler));
  }

  void head(String path, Handler handler) {
    _routes.add(Route("HEAD", path, handler));
  }

  void handle(Request req, Response res) {
    final route = _routes.firstWhere(
      (r) => r.method == req.method && r.path == req.path,
      orElse: () => Route(req.method, "", (req, res) {
        res.statusCode = 404;
        res.statusMessage = "Not Found";
        res.body = "Route not found";
      }),
    );

    route.handler(req, res);
  }
}
