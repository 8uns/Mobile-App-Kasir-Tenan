import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kasir_tenan_0_1/pages/pdfview.dart';
import 'package:kasir_tenan_0_1/pages/uploadslip.dart';
import 'package:kasir_tenan_0_1/pages/viewslipbayar.dart';
import './drawerApp.dart';
import 'package:http/http.dart' as http;
import '../config.dart';

class Billing extends StatelessWidget {
  static const nameRoute = '/billing';

  final String ambilTahun;
  Billing(this.ambilTahun);

  String billingApi = "${baseurl}api/billing/$token/tahun/";

  Future<List<dynamic>> _billing() async {
    var result = await http.get(Uri.parse(billingApi + ambilTahun));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    List<String> years = [
      for (var i =
              int.parse(DateFormat('yyyy').format(DateTime.now()).toString());
          i >= 2019;
          i--)
        i.toString()
    ];

    Size size = MediaQuery.of(context).size;
    String showTahun = ambilTahun != ''
        ? ': ' + ambilTahun.toString()
        : ': ' + DateFormat('yyyy').format(DateTime.now()).toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("Tagihan & Billing " + showTahun),
        actions: [
          Container(
            // width: 1,
            margin: EdgeInsets.only(
              right: 15,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(
                  Icons.calendar_month_sharp,
                  color: Colors.black,
                ),
                // hint: Text(
                //   "Year",
                // ),
                items: years.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? value) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => Billing(value.toString()),
                    ),
                  );
                },
                value: null,
              ),
            ),
          ),
        ],
      ),
      drawer: DrawerApp(),
      body: futureTransaksi(),
    );
  }

  FutureBuilder<List<dynamic>> futureTransaksi() {
    return FutureBuilder<List<dynamic>>(
        future: _billing(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var imageView = snapshot.data![index]['validation'] == 1
                    ? Icon(
                        Icons.verified,
                        color: Colors.teal[300],
                        size: 30,
                      )
                    : Icon(
                        Icons.circle_notifications,
                        color: Colors.deepOrange[900],
                        size: 30,
                      );
                final item = index.toString();
                return Column(
                  children: [
                    Card(
                      child: ListTile(
                        leading: imageView,
                        title: Row(
                          children: [
                            Text(
                              snapshot.data![index]['month']
                                      .toString()
                                      .toUpperCase() +
                                  " " +
                                  snapshot.data![index]['year'].toString(),
                            ),
                          ],
                        ),
                        subtitle: snapshot.data![index]['validation'] == 1
                            ? Text(
                                "Konfirmasi Pembayaran : ${snapshot.data![index]['validationdate']}")
                            : Text(
                                "Batas Waktu Bayar : 7 ${snapshot.data![index]['month']} 2022"),
                        trailing: TextButton(
                          child: const Icon(Icons.more_vert),
                          onPressed: () {
                            lihatSlip(context, snapshot, index);
                          },
                        ),
                      ),
                    ),
                    // const Divider(height: 10, thickness: 1),
                  ],
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<dynamic> lihatSlip(
      BuildContext context, AsyncSnapshot<List<dynamic>> snapshot, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
                "Tagihan & Billing ${snapshot.data![index]['month'].toString().toUpperCase()} ${snapshot.data![index]['year']}"),
          ),
          content: Container(
            // height: MediaQuery.of(context).size.height * 0.8,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PdfViewer(
                                  colorbase: 'blue',
                                  title:
                                      "Tagihan Konsesi ${snapshot.data![index]['month'].toString().toUpperCase()} ${snapshot.data![index]['year']}",
                                  doc:
                                      "${baseurl}file/billing/${tenan_id}/${snapshot.data![index]['file_konsesi']}",
                                )),
                      );
                    },
                    leading: const Icon(
                      Icons.request_quote,
                      size: 35,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      "Tagihan Konsesi",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PdfViewer(
                                  colorbase: 'yellow',
                                  title:
                                      "Tagihan Listrik ${snapshot.data![index]['month'].toString().toUpperCase()} ${snapshot.data![index]['year']}",
                                  doc:
                                      "${baseurl}file/billing/${tenan_id}/${snapshot.data![index]['file_listrik']}",
                                )),
                      );
                    },
                    leading: const Icon(
                      Icons.request_quote,
                      size: 35,
                      color: Colors.amberAccent,
                    ),
                    title: const Text(
                      "Tagihan Listrik",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => PdfViewer(
                                  colorbase: 'orange',
                                  title:
                                      "Tagihan Lapak ${snapshot.data![index]['month'].toString().toUpperCase()} ${snapshot.data![index]['year']}",
                                  doc:
                                      "${baseurl}file/billing/${tenan_id}/${snapshot.data![index]['file_sewatempat']}",
                                )),
                      );
                    },
                    leading: const Icon(
                      Icons.request_quote,
                      size: 35,
                      color: Colors.orange,
                    ),
                    title: const Text(
                      "Tagihan Lapak",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                (snapshot.data![index]['file_billing'] == '' ||
                        snapshot.data![index]['file_billing'] == null)
                    ? SizedBox()
                    : Card(
                        child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => PdfViewer(
                                        colorbase: 'red',
                                        title:
                                            "Billing ${snapshot.data![index]['month'].toString().toUpperCase()} ${snapshot.data![index]['year']}",
                                        doc:
                                            "${baseurl}file/billing/${tenan_id}/${snapshot.data![index]['file_billing']}",
                                      )),
                            );
                          },
                          leading: const Icon(
                            Icons.request_quote,
                            size: 35,
                            color: Colors.red,
                          ),
                          title: const Text(
                            "Billing",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                Divider(height: 25, thickness: 1),
                Divider(height: 25, thickness: 1),
                (snapshot.data![index]['file_billing'] == '' ||
                        snapshot.data![index]['file_billing'] == null)
                    ? SizedBox()
                    : Card(
                        child: ListTile(
                          onTap: () {
                            if (snapshot.data![index]['payment_konsesi'] ==
                                    '' ||
                                snapshot.data![index]['payment_konsesi'] ==
                                    null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UploadSlip(
                                    tipedoc: 'konsesi',
                                    idbilling: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewSlipBayar(
                                    tipedoc: 'konsesi',
                                    valid: snapshot.data![index]['validation']
                                        .toString(),
                                    img: snapshot.data![index]
                                            ['payment_konsesi']
                                        .toString(),
                                    billingid: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                    month: snapshot.data![index]['month']
                                        .toString(),
                                    year: snapshot.data![index]['year']
                                        .toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          leading: const Icon(
                            Icons.receipt_long,
                            size: 35,
                            color: Colors.blue,
                          ),
                          title: const Text(
                            "Bukti Tagihan Konsesi",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                (snapshot.data![index]['file_billing'] == '' ||
                        snapshot.data![index]['file_billing'] == null)
                    ? SizedBox()
                    : Card(
                        child: ListTile(
                          onTap: () {
                            if (snapshot.data![index]['payment_listrik'] ==
                                    '' ||
                                snapshot.data![index]['payment_listrik'] ==
                                    null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UploadSlip(
                                    tipedoc: 'listrik',
                                    idbilling: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewSlipBayar(
                                    tipedoc: 'listrik',
                                    valid: snapshot.data![index]['validation']
                                        .toString(),
                                    img: snapshot.data![index]
                                            ['payment_listrik']
                                        .toString(),
                                    billingid: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                    month: snapshot.data![index]['month']
                                        .toString(),
                                    year: snapshot.data![index]['year']
                                        .toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          leading: const Icon(
                            Icons.receipt_long,
                            size: 35,
                            color: Colors.amberAccent,
                          ),
                          title: const Text(
                            "Bukti Tagihan Listrik",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
                (snapshot.data![index]['file_billing'] == '' ||
                        snapshot.data![index]['file_billing'] == null)
                    ? SizedBox()
                    : Card(
                        child: ListTile(
                          onTap: () {
                            if (snapshot.data![index]['payment_sewatempat'] ==
                                    '' ||
                                snapshot.data![index]['payment_sewatempat'] ==
                                    null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UploadSlip(
                                    tipedoc: 'lapak',
                                    idbilling: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                  ),
                                ),
                              );
                            } else {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ViewSlipBayar(
                                    tipedoc: 'lapak',
                                    valid: snapshot.data![index]['validation']
                                        .toString(),
                                    img: snapshot.data![index]
                                            ['payment_sewatempat']
                                        .toString(),
                                    billingid: snapshot.data![index]
                                            ['billing_id']
                                        .toString(),
                                    month: snapshot.data![index]['month']
                                        .toString(),
                                    year: snapshot.data![index]['year']
                                        .toString(),
                                  ),
                                ),
                              );
                            }
                          },
                          leading: const Icon(
                            Icons.receipt_long,
                            size: 35,
                            color: Colors.orange,
                          ),
                          title: const Text(
                            "Bukti Tagihan Lapak",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}
