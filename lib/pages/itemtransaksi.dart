import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_tenan_0_1/pages/kasir.dart';
import 'package:kasir_tenan_0_1/pages/tambahtransaksi.dart';

import '../config.dart';

class ItemTransaksi extends StatelessWidget {
  final String produkApi = "${baseurl}api/item/$token/aktif";
  String transaksiApiStatus = "${baseurl}api/transaksi/$token/status";

  Future<List<dynamic>> _produkData() async {
    var result = await http.get(Uri.parse(produkApi));
    return json.decode(result.body)['data'];
  }

  Future<dynamic> _transaksiStatus() async {
    var result = await http.get(Uri.parse(transaksiApiStatus));
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: FutureBuilder<List<dynamic>>(
            future: _produkData(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        ListTile(
                          // leading: '',
                          onTap: () {},
                          title: Text("${snapshot.data![index]['name']}"),
                          subtitle:
                              Text("Rp. ${snapshot.data![index]['price']}"),
                          trailing:
                              Text("${snapshot.data![index]['quantity']} X"),
                        ),
                        const Divider(height: 5, thickness: 1),
                      ],
                    );
                  },
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
        Positioned(
          bottom: 0,
          // ignore: sized_box_for_whitespace
          child: Container(
            // decoration: BoxDecoration(
            //   color: Colors.amber,
            // ),
            // height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 1,
            // ignore: avoid_unnecessary_containers
            child: Container(
              child: FutureBuilder<dynamic>(
                future: _transaksiStatus(),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data['id'] != 0) {
                    return Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.15,
                          decoration: BoxDecoration(color: Colors.red[900]),
                          child: IconButton(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Center(
                                      child:
                                          Text("Ingin Membatalkan Transaksi?"),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary:
                                              Colors.red[900], // background
                                        ),
                                        onPressed: () async {
                                          // print('cancel');
                                          // print(snapshot.data!['data'][0]
                                          //     ['transaction_id']);
                                          // print(
                                          //     "${baseurl}api/transaksi/$token/${snapshot.data!['data'][0]['transaction_id']}");
                                          var url = Uri.parse(
                                              "${baseurl}api/transaksi/$token/${snapshot.data!['data'][0]['transaction_id']}");
                                          var response = await http.delete(url);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => Kasir(),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'Ya',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            color: Colors.white70,
                            icon: Icon(Icons.disabled_by_default),
                            iconSize: 30,
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.65,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                          child: Center(
                            child: Text(
                              "Rp. ${snapshot.data['data'][0]['total']}",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(color: Colors.teal),
                          child: IconButton(
                            onPressed: () {
                              // print(
                              //     snapshot.data!['data'][0]['transaction_id']);
                              // print(snapshot.data!['data'][0]['total']);

                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TambahTransaksi(
                                    snapshot.data!['data'][0]['transaction_id'],
                                    snapshot.data!['data'][0]['total'],
                                  ),
                                ),
                              );
                            },
                            color: Colors.white70,
                            icon: Icon(Icons.calculate),
                            iconSize: 50,
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.amber,
                          ),
                          child: Center(
                            child: Text(
                              "Rp. ...",
                              style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.grey[700],
                          ),
                          child: IconButton(
                            onPressed: () {
                              // print('mati');
                            },
                            color: Colors.white70,
                            icon: Icon(Icons.calculate),
                            iconSize: 50,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
