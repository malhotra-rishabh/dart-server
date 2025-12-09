import 'route.dart';
import '../http/request.dart';
import '../http/response.dart';

class Router {
  final List<Route> _routes = [];

  void get(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("GET", path, handler, middleware));
  }

  void post(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("POST", path, handler, middleware));
  }

  void put(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("PUT", path, handler, middleware));
  } 

  void delete(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("DELETE", path, handler, middleware));
  }

  void patch(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("PATCH", path, handler, middleware));
  }

  void options(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("OPTIONS", path, handler, middleware));
  }

  void head(String path, Handler handler, [List<Middleware>? middleware]) {
    _routes.add(Route("HEAD", path, handler, middleware));
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

        // Execute middleware if any
        if (route.middleware != null) {
          for (final mw in route.middleware!) {
            mw(req, res);
          }
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
