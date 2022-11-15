import 'package:flutter/material.dart';
import 'drawerApp.dart';

class Pengaturan extends StatelessWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        drawer: DrawerApp(),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // ignore: avoid_unnecessary_containers
                Container(
                  decoration: BoxDecoration(
                      // border: Border.all(color: Colors.amber),
                      borderRadius: BorderRadius.circular(100),
                      color: Colors.amber[50]),
                  margin: const EdgeInsets.only(
                    top: 50,
                    bottom: 50,
                  ),
                  padding: const EdgeInsets.all(10),
                  child: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.amber,
                    size: 100,
                  ),
                ),

                Container(
                  child: const Text(
                    'Nama Tenan',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Hanya Sampel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: const Text(''),
                ),

                Container(
                  child: const Text(
                    'Nama Pemilik',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Hanya Sampel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: const Text(''),
                ),

                Container(
                  child: const Text(
                    'Username',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    'Hanya Sampel',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: const Text(''),
                ),

                Container(
                  child: const Text(
                    'Masa Kontrak',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 15,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    '12/12/1212',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: const Text(''),
                ),

                Container(
                  margin: const EdgeInsets.only(
                    top: 50,
                  ),
                  child: const Text('Dalam Pengembangan'),
                ),
              ],
            ),
          ],
        ));
  }
}
