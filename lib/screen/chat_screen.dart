import "dart:io";
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bandnames/interfaces/interfaces.dart';
import 'package:flutter_bandnames/models/mensaje_response.dart';
import 'package:provider/provider.dart';

//PROPIO
import 'package:flutter_bandnames/services/services.dart';
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

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje_personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.id);
  }

  void _cargarHistorial(String usuarioId) async {
    List<Mensaje> chat = await chatService.getChat(usuarioId);
    final history = chat.map((m) => ChatMessage(
        texto: m.texto,
        uid: m.de,
        //uso el forward para que lanze la animacion de una vez
        animationController:
            AnimationController(vsync: this, duration: Duration.zero)
              ..forward()));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic data) {
    ChatMessage message = ChatMessage(
        texto: data['texto'],
        uid: data['de'],
        animationController: AnimationController(
            vsync: this, duration: const Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    //Cone sto mando hacer la animacion
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final usuarioPara = chatService.usuarioPara;

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
              child: Text(
                usuarioPara?.name.substring(0, 2) ?? "",
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              usuarioPara?.name ?? "",
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
      uid: authService.usuario.id,
      animationController: AnimationController(
          vsync: this, duration: const Duration(milliseconds: 200)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward(); //Para disparar la animacion

    setState(() {
      _estaEscribeindo = false;
    });

    socketService.sendMensages(
        de: authService.usuario.id,
        para: chatService.usuarioPara.id,
        texto: textoSinEspacio);
  }

  //Al momento de cerrar la pantalla limpiar
  @override
  void dispose() {
    // TODO: off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off("mensaje_personal");
    super.dispose();
  }
}
