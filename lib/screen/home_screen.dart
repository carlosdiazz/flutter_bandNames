import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bandnames/models/band_models.dart';
import 'package:flutter_bandnames/services/socket_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BandModel> bands = [];

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.off("active-bands");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //provider
    final socketService = Provider.of<SocketService>(context);
    socketService.socket.on('active_bands', (data) {
      final List dataDecode = jsonDecode(data);
      bands = dataDecode.map((band) => BandModel.fromMap(band)).toList();
      setState(() {});
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BandNames",
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.online
                ? Icon(
                    Icons.check_circle,
                    color: Colors.blue[300],
                  )
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
                  ),
          )
        ],
      ),
      body: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, index) => _bandTile(bands[index])),
      floatingActionButton: FloatingActionButton(
        onPressed: addNewBand,
        child: const Icon(Icons.add),
      ),
    );
  }

  Dismissible _bandTile(BandModel bandModel) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        //TODO llamar el borrado del server
        print("ID: ${bandModel.id}");
      },
      background: Container(
        color: Colors.red,
        padding: const EdgeInsets.all(10),
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Delete Band",
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(bandModel.name.substring(0, 2)),
        ),
        title: Text(bandModel.name),
        trailing: Text(
          '${bandModel.votes}',
          style: const TextStyle(fontSize: 15),
        ),
        onTap: () {
          print(bandModel.name);
        },
      ),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("New Band Name"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: TextField(
              controller: textController,
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.red),
                  )),
              MaterialButton(
                onPressed: () {
                  return addBandToList(textController.text);
                },
                child: const Text('Add'),
              )
            ],
          );
        },
      );
    }

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("New Band Name"),
          content: CupertinoTextField(controller: textController),
          actions: [
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: const Text("Cerrar"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            CupertinoDialogAction(
              isDefaultAction: true,
              child: const Text("Add"),
              onPressed: () {
                return addBandToList(textController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      //bands.add(BandModel(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
