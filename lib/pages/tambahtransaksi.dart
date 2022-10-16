import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kasir_tenan_0_1/pages/kasir.dart';
import 'package:kasir_tenan_0_1/pages/notifkembalian.dart';

import '../config.dart';

// ignore: use_key_in_widget_constructors
class TambahTransaksi extends StatefulWidget {
  static const nameRoute = '/TambahTransaksi';

  var transaksiid;
  var totaltransaksi;
  TambahTransaksi(this.transaksiid, this.totaltransaksi);

  State<TambahTransaksi> createState() =>
      _TambahTransaksiState(transaksiid, totaltransaksi);
}

class _TambahTransaksiState extends State<TambahTransaksi> {
  var transid;
  var totaltrans;

  _TambahTransaksiState(this.transid, this.totaltrans);

  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();

  String? name;

  String? base64Img;

  String? pay;

  File? tmpImg;

  String filename = '';

  // ignore: non_constant_identifier_names
  String tenan_id = '1';

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        // ignore: unnecessary_this
        this.tmpImg = imageTemp;
        // print(imageTemp);
      });
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
      // print('Gagal pick image');
    }
  }

  Future tagImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        // ignore: unnecessary_this
        this.tmpImg = imageTemp;
        // print(imageTemp);
      });
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
      // print('Gagal pick image');
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Pembayaran $transid"),
        ),
        body: Form(
          key: _formKey,
          // ignore: sized_box_for_whitespace
          child: Container(
            height: MediaQuery.of(context).size.height * 1,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 1,
                          height: 100,
                          child: Card(
                            child: Center(
                                child: Text(
                              "Total : Rp. $totaltrans ",
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            )),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(15),
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              hintText: "Rp. ...",
                              labelText: "Nominal",
                              icon: Icon(Icons.price_change),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Masukan Nominal!!';
                              }
                              pay = value;
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            color: Colors.amber,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    await reqTambahTransaksi(context);
                  },
                  icon: const Icon(
                    Icons.payments_sharp,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Bayar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> reqTambahTransaksi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      int payn = int.parse(pay!);
      if (payn < totaltrans) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Total uang tidak mencukupi!')),
        );
      } else {
        var kembalian = payn - totaltrans;
        // print(kembalian);
        // print(pay.toString());
        // print(transid);
        // print('${baseurl}api/transaksi/$token/bayar/$transid');
        // print('${baseurl}api/transaksi/2222/bayar/$transid');
        var url = Uri.parse('${baseurl}api/transaksi/$token/bayar/$transid');
        var response = await http.get(url);

        if (response.statusCode == 200) {
          // print(response.body);

          //   // ignore: use_build_context_synchronously
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => NotifKembalian(kembalian.toString()),
            ),
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Gagal Melakukan Pembayaran! ulangi.')),
          );
        }
      }
    }
  }
}
