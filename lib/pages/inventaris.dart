import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/itemtransaksi.dart';
import '../config.dart';
import './drawerApp.dart';
import './kasirproduk.dart';
import 'package:http/http.dart' as http;

import 'billing.dart';
import 'inventarisKeluar.dart';
import 'inventarisMasuk.dart';

class Inventaris extends StatelessWidget {
  static const nameRoute = '/kasir';
  int notifBil = 0;
  String dateTrans;
  int inout;
  Inventaris(this.dateTrans, this.inout);

  List<Tab> tabProduk = [
    Tab(
      text: 'Data Masuk',
    ),
    Tab(
      text: 'Data Keluar',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: inout,
      length: tabProduk.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          backgroundColor: Colors.amber[600],
          title: Text("Inventaris"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: tabProduk,
          ),
        ),
        drawer: DrawerApp(),
        body: TabBarView(
          children: [
            Center(
              child: InventarisMasuk(dateTrans),
            ),
            Center(
              child: InventarisKeluar(dateTrans),
            ),
          ],
        ),
        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: Colors.amber[600],
        //   onPressed: () {},
        //   child: Icon(Icons.shopping_cart_rounded),
        // ),
      ),
    );
  }
}
