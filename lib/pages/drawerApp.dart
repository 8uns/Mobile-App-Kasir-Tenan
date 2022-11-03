import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/billing.dart';
import 'package:kasir_tenan_0_1/pages/kelolaproduk.dart';
import 'package:kasir_tenan_0_1/pages/pengaturan.dart';
import '../config.dart';
import './kasir.dart';
import './login.dart';
import './transaksi.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'inventaris.dart';
import 'inventarisMasuk.dart';

class DrawerApp extends StatelessWidget {
  String billingApi = "${baseurl}api/billing/$token/notif";
  Future<dynamic> _billing() async {
    var result = await http.get(Uri.parse(billingApi));
    return json.decode(result.body);
  }

  void clearPref() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const drawerHeader(),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Aktifitas",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Kasir(),
                ),
              );
            },
            leading: Icon(
              Icons.point_of_sale,
              size: 35,
            ),
            title: const Text(
              "Penjualan",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Billing(''),
                ),
              );
            },
            leading: Icon(
              Icons.request_quote,
              size: 35,
            ),
            title: Row(
              children: [
                const Text(
                  "Tagihan & Billing",
                  style: TextStyle(fontSize: 15),
                ),
                FutureBuilder<dynamic>(
                  future: _billing(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data['id'] != 0) {
                      return Container(
                          // margin: EdgeInsets.all(10),
                          // padding: EdgeInsets.symmetric(
                          //   horizontal: 15,
                          // ),
                          child: Icon(
                        Icons.circle_notifications,
                        color: Colors.deepOrange[900],
                        size: 20,
                      ));
                    } else {
                      return Center(
                        child: Text(''),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          Divider(height: 25, thickness: 1),
          const Padding(
            padding: EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Katalog",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => KelolaProduk(),
                ),
              );
            },
            leading: Icon(
              Icons.view_in_ar_rounded,
              size: 35,
            ),
            title: const Text(
              "Kelola Produk",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Inventaris('', 0),
                ),
              );
            },
            leading: Icon(
              Icons.inventory,
              size: 35,
            ),
            title: const Text(
              "Inventaris",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Transaksi(''),
                ),
              );
            },
            leading: Icon(
              Icons.receipt_long,
              size: 35,
            ),
            title: const Text(
              "Riwayat Transaksi",
              style: TextStyle(fontSize: 15),
            ),
          ),
          Divider(height: 25, thickness: 1),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Text("Kelola",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                )),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Pengaturan(),
                ),
              );
            },
            leading: Icon(
              Icons.manage_accounts,
              size: 35,
            ),
            title: const Text(
              "Pengaturan Akun",
              style: TextStyle(fontSize: 15),
            ),
          ),
          ListTile(
            onTap: () {
              clearPref();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => Login(),
                ),
              );
            },
            leading: Icon(
              color: Colors.deepOrange[900],
              Icons.logout,
              size: 35,
            ),
            title: const Text(
              "Keluar",
              style: TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class drawerHeader extends StatelessWidget {
  const drawerHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(color: Colors.amber[600]),
      currentAccountPicture: const CircleAvatar(
        child: Icon(
          color: Colors.orange,
          Icons.storefront_outlined,
          size: 60,
        ),
      ),
      accountName: Text(nameTenan),
      accountEmail: Text("$fullname"),
    );
  }
}
