import 'package:flutter/material.dart';

import '../navigation/main_screen.dart';
import 'domain/models/content_onboarding.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  int currentIndex = 0;
  late PageController _controller;

  List<ContentOnboarding> contents = [
    ContentOnboarding(
        image: "assets/img/fitnessandsalud.png",
        text: "Fitness y Salud",
        descripcion:
            "Programas de entrenamiento, dieta personalizada, y seguimientos médicos"),
    ContentOnboarding(
        image: "assets/img/superacion.png",
        text: "Superación Personal",
        descripcion: "Artículos, videos, y ejercicios de desarrollo personal."),
    ContentOnboarding(
        image: "assets/img/financiero.png",
        text: "Asesoramiento Financiero",
        descripcion:
            "Herramientas de presupuesto, análisis de ingresos y gastos, y recomendaciones."),
    ContentOnboarding(
        image: "assets/img/liderazgo.png",
        text: "Relaciones y Liderazgo",
        descripcion:
            "Guías, ejercicios y contenido exclusivo sobre liderazgo y relaciones interpersonales."),
    ContentOnboarding(
        image: "assets/img/ventas.png",
        text: "Ventas y Marca Personal",
        descripcion: "Cursos y contenido sobre ventas y desarrollo de marca.")
  ];

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
                controller: _controller,
                itemCount: contents.length,
                onPageChanged: (int index) {
                  setState(() {
                    currentIndex = index;
                  });
                },
                itemBuilder: (_, i) {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(05),
                      child: Container(
                        decoration: const BoxDecoration(
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                              Colors.black12,
                              Colors.transparent
                            ])),
                        child: Column(
                          children: [
                            Image.asset(
                              contents[i].image,
                              fit: BoxFit.cover,
                              height: 300,
                              width: double.infinity,
                            ),
                            const SizedBox(
                              height: 100,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 30, right: 30),
                              child: Column(
                                children: [
                                  Text(
                                    contents[i].text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                  const SizedBox(
                                    height: 50,
                                  ),
                                  Text(
                                    contents[i].descripcion,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  contents.length, (index) => buildPage(index, context))),
          Container(
            height: 50,
            width: 300,
            margin: const EdgeInsets.all(40),
            child: MaterialButton(
              onPressed: () async {
                if (currentIndex == contents.length - 1) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MainScreen()),
                  );
                }
                _controller.nextPage(
                    duration: const Duration(seconds: 1),
                    curve: Curves.easeInOut);
              },
              color: const Color(0xff00408b),
              shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 0.4, color: Colors.white),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                currentIndex == contents.length - 1 ? "Continuar" : "Siguiente",
                style: const TextStyle(fontSize: 18),
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildPage(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 15 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: currentIndex == index
              ? Colors.white
              : const Color.fromARGB(255, 189, 189, 189)),
    );
  }
}
