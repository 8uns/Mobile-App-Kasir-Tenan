import 'dart:async';

import 'package:flutter/material.dart';
import './login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Opening extends StatefulWidget {
  static const nameRoute = '/opening';

  const Opening({Key? key}) : super(key: key);

  @override
  State<Opening> createState() => _OpeningState();
}

class _OpeningState extends State<Opening> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),
        () => Navigator.of(context).pushNamed(Login.nameRoute));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width * 1,
        height: MediaQuery.of(context).size.height * 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedTextKit(
              pause: const Duration(milliseconds: 5000),
              animatedTexts: [
                FadeAnimatedText(
                  "S I M P E L",
                  textStyle: const TextStyle(
                    fontSize: 50,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            AnimatedTextKit(
              pause: const Duration(milliseconds: 5000),
              animatedTexts: [
                FadeAnimatedText(
                  "Sistem Informasi Pelaporan \n Pendatapan dan E-Billing",
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                    // fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            AnimatedTextKit(
              pause: const Duration(milliseconds: 5000),
              animatedTexts: [
                FadeAnimatedText(
                  "UPBU Sultan Babullah Ternate",
                  textStyle: const TextStyle(
                    fontSize: 20,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
