import 'dart:io';
import 'dart:convert';
import '../router/router.dart';
import '../http/parser.dart';
import '../http/response.dart';

class ConnectionHandler {
  final Socket socket;
  final Router router;

  ConnectionHandler(this.socket, this.router);

  Future<void> handle() async {
    final buffer = StringBuffer();

    await for (final data in socket) {
      buffer.write(utf8.decode(data));

      // Stop reading when end of headers is reached
      if (buffer.toString().contains('\r\n\r\n')) break;
    }

    final raw = buffer.toString();

    if (raw.trim().isEmpty) {
      await socket.close();
      return;
    }

    final req = HttpParser.parse(raw);
    final res = Response();

    router.handle(req, res);

    socket.add(res.build());
    await socket.flush();
    await socket.close(); // We close the connection for now
  }
}
