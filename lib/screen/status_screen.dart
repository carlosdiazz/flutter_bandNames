import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_bandnames/services/socket_service.dart';

class StatusScreen extends StatelessWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('SevrSatuts: ${socketService.serverStatus}')],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          socketService.socket.emit('nuevo_mensaje', {"name": "carlos"});
        },
        child: const Icon(Icons.message),
      ),
    );
  }
}
