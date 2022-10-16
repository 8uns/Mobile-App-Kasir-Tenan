import 'dart:convert';

import 'package:flutter/material.dart';
import './drawerApp.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
// import 'package:crypto/crypto.dart';

class Transaksi extends StatelessWidget {
  String transaksiApi = "${baseurl}api/transaksi/$token";

  static const nameRoute = '/transaksi';

  Future<List<dynamic>> _transaksi() async {
    var result = await http.get(Uri.parse(transaksiApi));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("Riwayat Transaksi"),
      ),
      drawer: DrawerApp(),
      body: futureTransaksi(),
    );
  }

  FutureBuilder<List<dynamic>> futureTransaksi() {
    return FutureBuilder<List<dynamic>>(
        future: _transaksi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        // print("tab transaksi");
                        showdialogTransaksiDetail(context, snapshot, index,
                            "${baseurl}api/item/$token/${snapshot.data![index]['transaction_id']}");
                      },
                      title: Text(
                          "Transaksi ${snapshot.data![index]['transaction_id']}"),
                      subtitle: Text(snapshot.data![index]['date'].toString()),
                      trailing: Text(snapshot.data![index]['time'].toString()),
                    ),
                    const Divider(height: 10, thickness: 1),
                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<dynamic> showdialogTransaksiDetail(BuildContext context,
      AsyncSnapshot<List<dynamic>> snapshot, int index, String apiDetTrans) {
    Future<List<dynamic>> _transaksiDetail() async {
      var result = await http.get(Uri.parse(apiDetTrans));
      return json.decode(result.body)['data'];
    }

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Transaksi",
                    style: TextStyle(
                      fontSize: 19,
                    ),
                  ),
                  Text(
                    snapshot.data![index]['transaction_id'].toString(),
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  )
                ],
              ),
              Text(
                snapshot.data![index]['date'],
                style: const TextStyle(
                  fontSize: 15,
                ),
              ),
            ],
          ),
          content: Container(
            width: double.minPositive,
            child: FutureBuilder<List<dynamic>>(
              future: _transaksiDetail(),
              builder: (context, snap) {
                if (snap.hasData) {
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: snap.data!.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(snap.data![index]['name']),
                        subtitle: Text("Rp. ${snap.data![index]['price']}"),
                        trailing: Text("${snap.data![index]['quantity']} X"),
                      );
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
          actions: [
            Container(
              child: ListTile(
                title: Text(
                  "Total : ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // subtitle:
                // Text("Rp. ${Random().nextInt(100000)}"),
                trailing: Text(
                  "Rp. ${snapshot.data![index]['total']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
