import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/itemtransaksi.dart';
import '../config.dart';
import './drawerApp.dart';
import './kasirproduk.dart';
import 'package:http/http.dart' as http;

import 'billing.dart';

class Kasir extends StatelessWidget {
  String billingApi = "${baseurl}api/billing/$token/notif";
  String transaksiApiStatus = "${baseurl}api/transaksi/$token/status";
  static const nameRoute = '/kasir';
  int notifBil = 0;

  List<Tab> tabProduk = [
    Tab(
      text: 'Produk',
    ),
    Tab(
      text: 'Transaksi',
    ),
  ];

  Future<dynamic> _billing() async {
    var result = await http.get(Uri.parse(billingApi));
    return json.decode(result.body);
  }

  Future<dynamic> _transaksiStatus() async {
    var result = await http.get(Uri.parse(transaksiApiStatus));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: tabProduk.length,
      child: Scaffold(
        appBar: AppBar(
          actions: [
            Container(
              child: FutureBuilder<dynamic>(
                future: _billing(),
                builder: (context, snapshot) {
                  if (snapshot.hasData &&
                      snapshot.data['id'] != 0 &&
                      (snapshot.data['data']['file_billing'] == '' ||
                          snapshot.data['data']['file_billing'] == null)) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.orange[900],
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Billing(''),
                              ),
                            );
                          },
                          child: Text(
                            "Tagihan Bulan ${snapshot.data['data']['month'].toString().toUpperCase()} !!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.hasData &&
                      snapshot.data['id'] != 0 &&
                      (snapshot.data['data']['file_billing'] != '' ||
                          snapshot.data['data']['file_billing'] != null)) {
                    return Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.red[900],
                      ),
                      child: Center(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Billing(''),
                              ),
                            );
                          },
                          child: Text(
                            "Billing Bulan ${snapshot.data['data']['month'].toString().toUpperCase()} !!",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(''),
                    );
                  }
                },
              ),
            ),
          ],
          flexibleSpace: Stack(
            children: [
              Positioned(
                right: 30,
                top: 85,
                child: Container(
                  child: FutureBuilder<dynamic>(
                    future: _transaksiStatus(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData && snapshot.data['id'] != 0) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.deepOrange[800],
                          ),
                          // margin: const EdgeInsets.all(10),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 5,
                          ),
                          child: Center(
                            child: Text(
                              snapshot.data['data'][0]['totalproduk']
                                  .toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ),
                        );
                      } else {
                        return Center(
                          child: Text(''),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.amber[600],
          title: Text("Penjualan"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: tabProduk,
          ),
        ),
        drawer: DrawerApp(),
        body: TabBarView(
          children: [
            Center(
              child: KasirProduk(),
            ),
            Center(
              child: ItemTransaksi(),
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
