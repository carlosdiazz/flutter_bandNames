import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

//PROPIO
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/services/services.dart';
import 'package:flutter_bandnames/models/usuarios_response.dart';

class UsuariosScreen extends StatefulWidget {
  const UsuariosScreen({super.key});

  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  final usuarioService = UsuariosService();

  List<UsuarioModel> usuarios = [];

  @override
  void initState() {
    super.initState();
    _connectSocket();
    _cargarUsuarios();
  }

  Future<void> _connectSocket() async {
    final socketServiceSinListen =
        Provider.of<SocketService>(context, listen: false);
    await socketServiceSinListen.connect();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            usuario?.name.toUpperCase() ?? "",
            style: const TextStyle(color: Colors.black87),
          ),
          elevation: 1,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                socketService.disconect();
                Navigator.pushReplacementNamed(context, AppRoute.loginScreen);
                AuthService.deleteToken();
              },
              icon: const Icon(
                Icons.exit_to_app_outlined,
                color: Colors.black87,
              )),
          actions: [
            Container(
                margin: const EdgeInsets.only(right: 10),
                child: socketService.serverStatus == ServerStatus.online
                    ? Icon(
                        Icons.check_circle_outline,
                        color: Colors.blue[400],
                      )
                    : Icon(
                        Icons.offline_bolt_outlined,
                        color: Colors.red[400],
                      ))
          ],
        ),
        body: SmartRefresher(
          controller: refreshController,
          enablePullDown: true,
          onRefresh: _cargarUsuarios,
          header: WaterDropHeader(
            complete: Icon(
              Icons.check,
              color: Colors.blue[400],
            ),
            waterDropColor: Colors.blue,
          ),
          child: _listViewUsuarios(),
        ));
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) =>
            _usuarioListTile(usuario: usuarios[index]),
        separatorBuilder: (context, index) => const Divider(),
        itemCount: usuarios.length);
  }

  void _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    refreshController.refreshCompleted();
  }
}

class _usuarioListTile extends StatelessWidget {
  const _usuarioListTile({
    //super.key,
    required this.usuario,
  });

  final UsuarioModel usuario;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(usuario.name),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(usuario.name.substring(0, 2)),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)),
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, AppRoute.chatScreen);
      },
    );
  }
}
