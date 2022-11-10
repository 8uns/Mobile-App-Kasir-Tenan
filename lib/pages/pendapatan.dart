import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/pendapatanBulanan.dart';
import 'package:kasir_tenan_0_1/pages/pendapatanHarian.dart';
import './drawerApp.dart';

class Pendatapan extends StatelessWidget {
  static const nameRoute = '/kasir';
  int notifBil = 0;
  String bulan = '';
  String tahun = '';
  String tgl = '';
  int inout;
  Pendatapan(this.bulan, this.tahun, this.tgl, this.inout);

  List<Tab> tabProduk = [
    Tab(
      text: 'Harian',
    ),
    Tab(
      text: 'Bulanan',
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
          title: Text("Pendapatan"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: tabProduk,
          ),
        ),
        drawer: DrawerApp(),
        body: TabBarView(
          children: [
            Center(
              child: pendapatanHarian(tgl),
            ),
            Center(
              child: pendapatanBulanan(bulan, tahun),
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
