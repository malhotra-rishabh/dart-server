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
    for (final route in _routes) {
      if (route.method != req.method) continue;

      final match = route.regex.firstMatch(req.path);
      if (match != null) {
        // Extract path params
        for (int i = 0; i < route.paramNames.length; i++) {
          req.params[route.paramNames[i]] = match.group(i + 1)!;
        }

        route.handler(req, res);
        return;
      }
    }

    res.statusCode = 404;
    res.statusMessage = "Not Found";
    res.body = "Route not found";
  }
}
