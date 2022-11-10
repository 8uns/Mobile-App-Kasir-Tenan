import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'inventaris.dart';
import 'kelolaproduk.dart';

class InventarisKeluar extends StatefulWidget {
  static const nameRoute = '/InventarisKeluar';
  String dateTrans;

  InventarisKeluar(this.dateTrans);
  @override
  State<InventarisKeluar> createState() => _InventarisKeluarState(dateTrans);
}

class _InventarisKeluarState extends State<InventarisKeluar> {
  _InventarisKeluarState(this.dateTrans);
  String dateTrans;

  String produkApi = "${baseurl}api/inventaris/$token";
  Future<List<dynamic>> _transaksi() async {
    var result = await http.post(
      Uri.parse(produkApi),
      body: {
        'date': dateTrans,
        'in_out': 'keluar',
      },
    );
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    String dates = dateTrans != '' ? '${dateTrans}' : 'Terbaru';

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.amber[600],
        title: Text("${dates}"),
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
                    builder: (context) => Inventaris(formattedDate, 1),
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

  String lengthDecodebase64(String bytes) {
    if (bytes.length % 4 > 0) {
      bytes += '=' * (4 - bytes.length % 4);
    }
    return bytes;
  }

  FutureBuilder<List<dynamic>> futureTransaksi() {
    return FutureBuilder<List<dynamic>>(
        future: _transaksi(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String bytes = snapshot.data![index]['picture'].toString();
                bytes = lengthDecodebase64(bytes);
                final _byteImage = Base64Decoder().convert(bytes);
                const icon2 = Icon(
                  Icons.image_not_supported_sharp,
                  size: 45,
                );
                const icon1 = Icon(
                  Icons.image,
                  size: 50,
                );
                var imageView = snapshot.data![index]['picture'] == ""
                    ? icon1
                    : Image.memory(
                        _byteImage,
                        // loadingBuilder: (context, child, loadingProgress) =>
                        //     (loadingProgress == null)
                        //         ? child
                        //         : CircularProgressIndicator(),
                        errorBuilder: (context, error, stackTrace) => icon2,
                        fit: BoxFit.cover,
                        width: 50,
                      );
                final item = index.toString();
                return Column(
                  children: [
                    ListTile(
                      leading: imageView,
                      onTap: () {},
                      title: Text("${snapshot.data![index]['name_product']} "),
                      subtitle: Text(
                          "${snapshot.data![index]['date']} | ${snapshot.data![index]['time']}"),
                      trailing: Text(
                          "Stok Keluar: ${snapshot.data![index]['qtytrans']}"),
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

  Future<dynamic> konfirmasiHapus(
      BuildContext context, AsyncSnapshot<List<dynamic>> snapshot, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmari Hapus Produk'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text(
                    "Yakin menghapus ${snapshot.data![index]['name_product']} ?"),
              ],
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.deepOrange[900],
              ),
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                var url = Uri.parse(
                    '${baseurl}api/produk/$token/${snapshot.data![index]['product_id']}');
                var response = await http.delete(url);
                if (response.statusCode == 200) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => KelolaProduk(),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Gagal Menghapus Data!')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}
