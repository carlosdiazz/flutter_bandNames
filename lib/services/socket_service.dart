import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  SocketService() {
    _initConfig();
  }

  _initConfig() {
    // Dart client

    // Dart client
    _socket = IO.io(
        'http://localhost:4000',
        IO.OptionBuilder()
            .setTransports(['websocket']) //1 for Flutter or Dart VM
            .disableAutoConnect() // disable auto-connection
            //.setExtraHeaders({'foo': 'bar'}) // optional
            .build());
    _socket.connect();

    _socket.onConnect((_) {
      print('Se conecto');
      _socket.emit('message', 'test');
    });
    _socket.onDisconnect((_) => print('Se Desconecto'));

    _socket.on('disconnect', (data) {
      print('Disconect');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('connect', (data) {
      print("Conne");
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('nuevo_mensaje', (data) {
      print('nuevo-mensaje: $data');
    });
  }
}
