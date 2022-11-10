import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_tenan_0_1/pages/pendapatan.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class pendapatanHarian extends StatefulWidget {
  static const nameRoute = '/pendapatanHarian';
  String tgl;

  pendapatanHarian(this.tgl);
  @override
  State<pendapatanHarian> createState() => _pendapatanHarianState(tgl);
}

class _pendapatanHarianState extends State<pendapatanHarian> {
  _pendapatanHarianState(this.tgl);
  String tgl;

  String produkApi = "${baseurl}api/pendapatan/$token/harian";
  Future<List<dynamic>> _pendatapanDetail() async {
    var result = await http.post(
      Uri.parse(produkApi),
      body: {
        'tgl': tgl,
        'tenan_id': tenan_id,
      },
    );
    return json.decode(result.body)['data'];
  }

  Future<dynamic> _pendapatanTotal() async {
    var result = await http.post(
      Uri.parse(produkApi + "/total"),
      body: {
        'tgl': tgl,
        'tenan_id': tenan_id,
      },
    );
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber[600],
        title: futureTotalHarian(),
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
                tgl = formattedDate; //set output date to TextField value.
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Pendatapan('', '', tgl, 0),
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
      body: futureTransaksi(),
    );
  }

  FutureBuilder<dynamic> futureTotalHarian() {
    return FutureBuilder<dynamic>(
        future: _pendapatanTotal(),
        builder: (context, totalPendapatan) {
          try {
            return Text(
                'Total: Rp. ${totalPendapatan.data![0]['total_harian']} ');
          } catch (_) {
            return Text('');
          }
        });
  }

  FutureBuilder<List<dynamic>> futureTransaksi() {
    return FutureBuilder<List<dynamic>>(
        future: _pendatapanDetail(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final item = index.toString();
                return Column(
                  children: [
                    ListTile(
                      onTap: () {},
                      title:
                          Text("${snapshot.data![index]['transaction_id']} "),
                      subtitle: Text(
                          "${snapshot.data![index]['date']} | ${snapshot.data![index]['time']}"),
                      trailing:
                          Text("Rp. ${snapshot.data![index]['total_harian']}"),
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
}
