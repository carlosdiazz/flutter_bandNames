import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bandnames/models/band_models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<BandModel> bands = [
    BandModel(id: "1", name: "demo1", votes: 1),
    BandModel(id: "2", name: "demo2", votes: 2),
    BandModel(id: "3", name: "demo3", votes: 3),
    BandModel(id: "4", name: "demo4", votes: 4),
    BandModel(id: "5", name: "demo5", votes: 5)
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BandNames"),
        backgroundColor: Colors.green,
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
      bands.add(BandModel(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }
    Navigator.pop(context);
  }
}
