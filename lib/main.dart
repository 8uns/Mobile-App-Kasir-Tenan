import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kasir_tenan_0_1/pages/kelolaproduk.dart';
import 'package:kasir_tenan_0_1/pages/opening.dart';
import './pages/login.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // home: Kasir(),
      debugShowCheckedModeBanner: false,
      initialRoute: Opening.nameRoute,
      routes: {
        Opening.nameRoute: (context) => Opening(),
        Login.nameRoute: (context) => Login(),
        KelolaProduk.nameRoute: (context) => KelolaProduk(),
      },
    );
  }
}
