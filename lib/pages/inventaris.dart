import 'dart:convert';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/pages/tambahstokproduk.dart';
import './drawerApp.dart';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'kelolaproduk.dart';
// import 'package:crypto/crypto.dart';

class Inventaris extends StatelessWidget {
  String produkApi = "${baseurl}api/inventaris/$token";

  static const nameRoute = '/inventaris';

  Future<List<dynamic>> _transaksi() async {
    var result = await http.get(Uri.parse(produkApi));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amber[600],
        title: Text("Inventaris"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => TambahStokProduk(),
                ),
              );
            },
            icon: const Icon(
              Icons.add_circle,
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
                    : Image.network(
                        "${baseurl}img/produk/$tenan_id/${snapshot.data![index]['picture']}",
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
                          "Stok Masuk: ${snapshot.data![index]['qtytrans']}"),
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
                // print("${snapshot.data![index]['name']}");
                // print("id : ${snapshot.data![index]['product_id']}");

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

                // print(
                //     '${baseurl}api/produk/2222/${snapshot.data![index]['product_id']}');
              },
            ),
          ],
        );
      },
    );
  }
}
