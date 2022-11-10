import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:kasir_tenan_0_1/pages/pendapatan.dart';
import '../config.dart';
import 'package:month_year_picker/month_year_picker.dart';

class pendapatanBulanan extends StatefulWidget {
  static const nameRoute = '/pendapatanBulanan';
  String bulan;
  String tahun;

  pendapatanBulanan(this.bulan, this.tahun);
  @override
  State<pendapatanBulanan> createState() =>
      _pendapatanBulananState(bulan, tahun);
}

class _pendapatanBulananState extends State<pendapatanBulanan> {
  _pendapatanBulananState(this.bulan, this.tahun);
  String bulan;
  String tahun;

  String produkApi = "${baseurl}api/pendapatan/$token/bulanan";
  Future<List<dynamic>> _pendatapanDetail() async {
    var result = await http.post(
      Uri.parse(produkApi),
      body: {
        'bulan': bulan,
        'tahun': tahun,
        'tenan_id': tenan_id,
      },
    );
    return json.decode(result.body)['data'];
  }

  Future<dynamic> _pendapatanTotal() async {
    var result = await http.post(
      Uri.parse(produkApi + "/total"),
      body: {
        'bulan': bulan,
        'tahun': tahun,
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
              final selectedMonth = await showMonthYearPicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(2019),
                lastDate: DateTime(2035),
              );

              if (selectedMonth != null) {
                String bulan = DateFormat('MM').format(selectedMonth);
                String tahun = DateFormat('yyyy').format(selectedMonth);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => Pendatapan(bulan, tahun, '', 1),
                  ),
                );
              } else {
                print("Month is not selected");
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

  String namaBulan(String bul) {
    if (bul == '1') {
      return 'Januari';
    } else if (bul == '2') {
      return 'Februari';
    } else if (bul == '3') {
      return 'Maret';
    } else if (bul == '4') {
      return 'April';
    } else if (bul == '5') {
      return 'Mei';
    } else if (bul == '6') {
      return 'Juni';
    } else if (bul == '7') {
      return 'Juli';
    } else if (bul == '8') {
      return 'Agustus';
    } else if (bul == '9') {
      return 'September';
    } else if (bul == '10') {
      return 'Oktober';
    } else if (bul == '11') {
      return 'November';
    } else if (bul == '12') {
      return 'Desember';
    }
    return "";
  }

  FutureBuilder<dynamic> futureTotalHarian() {
    return FutureBuilder<dynamic>(
        future: _pendapatanTotal(),
        builder: (context, snapshot) {
          try {
            return Text('Total: Rp. ${snapshot.data![0]['total_bulan']} ');
          } catch (_) {
            return const Text('');
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
                      title: Text("${snapshot.data![index]['date']}"),
                      subtitle: Text(
                          namaBulan("${snapshot.data![index]['bulan']}") +
                              " ${snapshot.data![index]['tahun']} "),
                      trailing:
                          Text("Rp. ${snapshot.data![index]['total_bulan']}"),
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
