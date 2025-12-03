import 'dart:io';
import 'connection.dart';
import '../router/router.dart';

class MyHttpServer {
  final Router router;

  MyHttpServer(this.router);

  Future<void> listen(int port) async {
    final server = await ServerSocket.bind(InternetAddress.anyIPv4, port);
    print('Server listening on port $port');

    await for (final socket in server) {
      ConnectionHandler(socket, router).handle();
    }
  }
}
