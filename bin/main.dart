import 'package:my_http/my_http.dart';
import 'dart:io';
import 'dart:convert';

void main() {
  final router = Router();

  router.get('/', (req, res) {
    res.body = "GET working";
  });

  router.post('/user/:id', (req, res) {
    res.body = "POST body: ${req.body}, ${req.query}, ${req.params}";
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

  router.post('/upload', (req, res) {
    res.body = jsonEncode({
      "uploaded": req.files.length,
      "fields": req.fields,
    });
  });

  final server = MyHttpServer(router);
  server.listen(8080);
}
