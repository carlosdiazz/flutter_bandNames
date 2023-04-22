import 'package:flutter/material.dart';
import 'package:flutter_bandnames/config/variables.dart';
import 'package:flutter_bandnames/interfaces/interfaces.dart';
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

    _socket.on('disconnect', (data) {
      print('SE DESCONECTO DEL WS');
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });

    _socket.on('connect', (data) {
      print("SE CONECTO AL WS");
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });
  }

  void disconect() {
    print("SE MANDO A DESCONECTAR DEL WS");
    _socket.disconnect();
  }

  void sendMensages(
      {required String de, required String para, required String texto}) {
    _socket.emit("nuevo_mensaje", {"de": de, "para": para, "texto": texto});
  }

  //_socket.onConnect((_) {
  //  print('Se conecto');
  //  _socket.emit('message', 'test');
  //});
  //_socket.onDisconnect((_) => print('Se Desconecto'));
}
