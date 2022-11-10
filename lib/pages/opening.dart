import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import './login.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../config.dart';

import 'kasir.dart';

class Opening extends StatefulWidget {
  static const nameRoute = '/opening';

  const Opening({Key? key}) : super(key: key);

  @override
  State<Opening> createState() => _OpeningState();
}

class _OpeningState extends State<Opening> {
  void getPreferenceLogin() async {
    final pref = await SharedPreferences.getInstance();

    if (pref.containsKey('username') &&
        pref.containsKey('token') &&
        pref.containsKey('acount_id')) {
      fullname = pref.getString('fullname')!;
      username = pref.getString('username')!;
      token = pref.getString('token')!;
      acount_id = pref.getString('acount_id')!;
      imageTenan = pref.getString('imageTenan')!;
      nameTenan = pref.getString('nameTenan')!;
      tenan_id = pref.getString('tenan_id')!;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Kasir(),
        ),
      );
    } else {
      Navigator.of(context).pushNamed(Login.nameRoute);
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), () => getPreferenceLogin());
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
