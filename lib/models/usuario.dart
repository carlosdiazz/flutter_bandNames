class UsuarioModel {
  bool online;
  String email;
  String nombre;
  String uid;

  UsuarioModel(
      {required this.email,
      required this.nombre,
      required this.online,
      required this.uid});
}
