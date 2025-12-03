import 'package:my_http/my_http.dart';

void main() {
  final router = Router();

  router.get('/', (req, res) {
    res.body = "GET working";
  });

  router.post('/user', (req, res) {
    res.body = "POST body: ${req.body}";
  });

  router.put('/user', (req, res) {
    res.body = "PUT body: ${req.body}";
  });

  router.patch('/user', (req, res) {
    res.body = "PATCH body: ${req.body}";
  });

  router.delete('/user', (req, res) {
    res.body = "DELETE working";
  });

  router.options('/user', (req, res) {
    res.setHeader("Allow", "GET,POST,PUT,PATCH,DELETE,OPTIONS");
    res.body = "";
  });

  final server = MyHttpServer(router);
  server.listen(8080);
}
