import 'package:flutter/material.dart';
import 'package:flutter_bandnames/helpers/mostrar_alerta.dart';
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/services/auth_service.dart';
import 'package:flutter_bandnames/widgets/widgets.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), //Con esto hago un rebote en todos los dipositivos
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LogoLogin(
                    titulo: "Registrar",
                  ),
                  _Form(),
                  const LabelsLogin(
                    ruta: AppRoute.loginScreen,
                    text1: "Ya tienes uan cuenta",
                    text2: "Ingresa con su cuenta",
                  ),
                  const Text(
                    "Terminos y condiciones de uso @carlosdiazz08",
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  //const _Form({super.key});

  @override
  State<_Form> createState() => _FormState();
}

class _FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final nombreCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
        CustomInput(
            icon: Icons.perm_identity_outlined,
            isPassword: false,
            keyboardType: TextInputType.name,
            placeholder: "Nombre",
            textController: nombreCtrl),
        CustomInput(
            icon: Icons.email_outlined,
            isPassword: false,
            keyboardType: TextInputType.emailAddress,
            placeholder: "Email",
            textController: emailCtrl),
        CustomInput(
            icon: Icons.lock_outline,
            isPassword: true,
            keyboardType: TextInputType.name,
            placeholder: "Password",
            textController: passwordCtrl),
        //TextField(),
        BtnAzul(
          onPressed: authService.autenticando
              ? null
              : () async {
                  FocusScope.of(context).unfocus();
                  final registerOk = await authService.register(
                      nombreCtrl.text.trim(),
                      emailCtrl.text.trim(),
                      passwordCtrl.text.trim());
                  print(registerOk);
                  if (registerOk) {
                    Navigator.pushReplacementNamed(
                        context, AppRoute.usuariosScreen);
                  } else {
                    mostrarAlerta(
                        context: context,
                        titulo: "Regsitro Fallido",
                        subtitulo: "Revise sus credenciales");
                  }
                },
          text: "Registrar",
        )
      ]),
    );
  }
}
