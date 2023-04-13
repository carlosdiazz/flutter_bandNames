import 'package:flutter/material.dart';
import 'package:flutter_bandnames/router/app_router.dart';
import 'package:flutter_bandnames/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics:
                const BouncingScrollPhysics(), //Con esto hago un rebote en todos los dipositivos
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  const LogoLogin(titulo: "Messenger"),
                  _Form(),
                  const LabelsLogin(
                      ruta: AppRoute.registerScreen,
                      text1: "No tiene una cuenta?",
                      text2: "Crea una ahora!"),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(children: [
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
          onPressed: () {
            print(passwordCtrl.text);
          },
          text: "Ingresar",
        )
      ]),
    );
  }
}
