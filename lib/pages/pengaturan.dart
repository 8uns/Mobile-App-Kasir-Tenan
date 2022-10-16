import 'package:flutter/material.dart';

import 'drawerApp.dart';

class Pengaturan extends StatelessWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: DrawerApp(),
      body: Center(
        child: Text("Dalam pengembangan"),
      ),
    );
  }
}
