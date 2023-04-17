import "dart:io";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bandnames/widgets/widgets.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _estaEscribeindo = false;

  final List<ChatMessage> _messages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: const Text(
                'CA',
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              "Carlos Diaz",
              style: TextStyle(color: Colors.black87, fontSize: 14),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(children: [
          Flexible(
              child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _messages.length,
            itemBuilder: (context, index) => _messages[index],
            reverse: true,
          )),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ]),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(children: [
        Flexible(
            child: TextField(
          controller: _textController,
          onSubmitted: _handleSubmit,
          onChanged: (value) {
            //TODO: cuando hay un valor, poder postear
            setState(() {
              if (value.trim().isNotEmpty) {
                _estaEscribeindo = true;
              } else {
                _estaEscribeindo = false;
              }
            });
          },
          focusNode: _focusNode,
          decoration:
              const InputDecoration.collapsed(hintText: "Enviar mensaje"),
        )),
        Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: Platform.isIOS
                ? CupertinoButton(
                    onPressed: _estaEscribeindo
                        ? () => _handleSubmit(_textController.text.trim())
                        : null,
                    child: const Text("Enviar"),
                  )
                : Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    child: IconTheme(
                      data: IconThemeData(
                        color: Colors.blue[400],
                      ),
                      child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onPressed: _estaEscribeindo
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                          icon: const Icon(
                            Icons.send,
                          )),
                    ),
                  ))
      ]),
    ));
  }

  _handleSubmit(String texto) {
    final String textoSinEspacio = texto.trim();
    if (textoSinEspacio.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      texto: texto,
      uid: "123",
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward(); //Para disparar la animacion

    setState(() {
      _estaEscribeindo = false;
    });
  }

  //Al momento de cerrar la pantalla limpiar
  @override
  void dispose() {
    // TODO: off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
  }
}
