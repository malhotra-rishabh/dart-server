import '../http/request.dart';
import '../http/response.dart';

typedef Handler = void Function(Request req, Response res);

class Route {
  final String method;
  final String pattern;
  late final RegExp regex;
  late final List<String> paramNames;
  final Handler handler;

  Route(this.method, this.pattern, this.handler) {
    paramNames = [];

    final regexPattern = pattern.replaceAllMapped(
      RegExp(r':(\w+)'),
      (match) {
        paramNames.add(match.group(1)!);
        return '([^/]+)';
      },
    );

    regex = RegExp("^$regexPattern\$");
  }
}
