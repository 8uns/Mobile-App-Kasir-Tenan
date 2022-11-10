import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './drawerApp.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class Transaksi extends StatefulWidget {
  static const nameRoute = '/transaksi';
  String dateTrans;

  Transaksi(this.dateTrans);

  @override
  State<Transaksi> createState() => _TransaksiState(dateTrans);
}

TextEditingController dateinput = TextEditingController();

class _TransaksiState extends State<Transaksi> {
  _TransaksiState(this.dateTrans);
  String dateTrans;

  String transaksiApi = "${baseurl}api/transaksi/$token";
  Future<List<dynamic>> _transaksi() async {
    var result = await http.post(
      Uri.parse(transaksiApi),
      body: {
        'date': dateTrans,
      },
    );

    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    String dates = dateTrans != '' ? ': ${dateTrans}' : 'Terbaru';
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("Transaksi ${dates}"),
        actions: [
          IconButton(
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(
                    2000), //DateTime.now() - not to allow to choose before today.
                lastDate: DateTime(2101),
              );

              if (pickedDate != null) {
                String formattedDate =
                    DateFormat('yyyy-MM-dd').format(pickedDate);

                dateTrans = formattedDate; //set output date to TextField value.

                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Transaksi(formattedDate),
                  ),
                );
              } else {
                print("Date is not selected");
              }
            },
            icon: const Icon(
              Icons.calendar_month_sharp,
            ),
          )
        ],
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
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.grey[50],
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
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
        });
      },
    );
  }
}
