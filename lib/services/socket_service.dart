import 'package:flutter/material.dart';
import 'package:flutter_bandnames/config/variables.dart';
import 'package:flutter_bandnames/services/auth_service.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket get socket => _socket;

  //SocketService() {
  //  _initConfig();
  //}

  connect() async {
    final token = await AuthService.getToken();

    // Dart client
    _socket = IO.io(
        Variables.socketUrl,
        IO.OptionBuilder()
            .setTransports(['websocket']) //1 for Flutter or Dart VM
            .enableAutoConnect()
            .enableForceNew() // disable auto-connection
            .setExtraHeaders({'Authorization': "Bearer $token"})
            .build());
    _socket.connect();

    //_socket.onConnect((_) {
    //  print('Se conecto');
    //  _socket.emit('message', 'test');
    //});
    //_socket.onDisconnect((_) => print('Se Desconecto'));

    _socket.on('disconnect', (data) {
      print('Se Desconecto');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('connect', (data) {
      print("SE CONECTO");
      _serverStatus = ServerStatus.online;
      notifyListeners();
      _socket.emit("nuevo_mensaje");
    });

    _socket.on('nuevo_mensaje', (data) {
      print('nuevo-mensaje: $data');
    });
  }

  void disconect() {
    _socket.disconnect();
  }
}
