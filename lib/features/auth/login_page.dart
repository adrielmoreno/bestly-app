import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/presentation/common/widgets/inputs/custom_text_field.dart';
import '../home/home_page.dart';
import 'widgets/branding_image.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  static const String route = '/login';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordVisible = true;
  String? email;
  String? password;

  @override
  void initState() {
    super.initState();
  }

  void toggleIconPassword() {
    setState(() {
      isPasswordVisible = !isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            spacing: 24,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0, bottom: 44),
                child: BrandingImage(),
              ),
              Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    spacing: 16,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CustomTextField(
                        onChanged: (value) => email = value,
                        inputType: TextInputType.emailAddress,
                        icon: Icons.email,
                        label: 'Correo',
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Campo requerido';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value)) {
                            return 'Correo no válido';
                          }
                          return null;
                        },
                      ),
                      CustomTextField(
                        onChanged: (value) => password = value,
                        isPassword: true,
                        isPasswordVisible: isPasswordVisible,
                        toggleIconPassword: toggleIconPassword,
                        inputType: TextInputType.visiblePassword,
                        icon: Icons.vpn_key,
                        label: 'Contraseña',
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          TextButton(
                            isSemanticButton: true,
                            onPressed: () {
                              context.go(HomePage.route);
                            },
                            child: const Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                '¿Olvidé mi contraseña?',
                              ),
                            ),
                          ),
                        ],
                      ),
                      MaterialButton(
                        minWidth: double.infinity,
                        onPressed: () {},
                        color: const Color(0xff00408b),
                        shape: RoundedRectangleBorder(
                            side: const BorderSide(
                                width: 0.4, color: Colors.white),
                            borderRadius: BorderRadius.circular(10)),
                        child: const Text('INICIAR SESION'),
                      ),
                      const Row(
                        children: [
                          Expanded(child: Divider()),
                          Text(
                            " o ",
                          ),
                          Expanded(
                            child: Divider(),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  spacing: 24,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () async {},
                        label: const Text(
                          'Iniciar con Google',
                        ),
                        icon: const Image(
                          image: AssetImage(
                            'assets/icons/google.png',
                          ),
                          height: 34,
                        ),
                      ),
                    ),
                    if (Platform.isIOS)
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          onPressed: () {},
                          icon: const Image(
                            image: AssetImage(
                              'assets/icons/apple.png',
                            ),
                            height: 34,
                          ),
                          label: const Text(
                            'Iniciar con Apple',
                          ),
                        ),
                      )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
