import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kasir_tenan_0_1/pages/inventaris.dart';
import 'package:kasir_tenan_0_1/pages/kasir.dart';
import '../config.dart';

class KasirProduk extends StatefulWidget {
  @override
  State<KasirProduk> createState() => _KasirProdukState();
}

class _KasirProdukState extends State<KasirProduk> {
  final String produkApi = "${baseurl}api/produk/$token";
  int qty = 1;
  Future<List<dynamic>> _produkData() async {
    var result = await http.get(Uri.parse(produkApi));
    return json.decode(result.body)['data'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<List<dynamic>>(
        future: _produkData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                crossAxisCount: 3,
              ),
              itemBuilder: (context, index) {
                // var img = snapshot.data![index]['picture'].toString();

                return GridTile(
                  // ignore: sort_child_properties_last
                  child: InkResponse(
                    onTap: () {
                      setState(() {
                        qty = 1;
                      });
                      if (snapshot.data![index]['quantity'] == 0) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        "Stok ${snapshot.data![index]['name']} Kosong"),
                                  ),
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Tambah Stok ${snapshot.data![index]['name']} terlebih dahulu !!!",
                                        style:
                                            TextStyle(color: Colors.amber[800]),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.amber,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 50,
                                                  vertical: 15,
                                                )),
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pushReplacement(
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      Inventaris(''),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(Icons.inventory),
                                                Text(
                                                  'Inventory',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    )
                                  ],
                                );
                              });
                            });
                      } else {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                return AlertDialog(
                                  title: Center(
                                    child: Text(
                                        "Tambahkan ${snapshot.data![index]['name']}"),
                                  ),
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Card(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              // vertical: 5,
                                              // horizontal: 5,
                                              ),
                                          child: IconButton(
                                            onPressed: () {
                                              // print('kurang 1');
                                              if (qty > 1) {
                                                setState(() {
                                                  qty -= 1;
                                                });
                                              }
                                            },
                                            icon: Icon(Icons.remove_circle),
                                            color: Colors.grey,
                                            iconSize: 50,
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                            vertical: 15,
                                            horizontal: 20,
                                          ),
                                          child: Text(
                                            qty.toString(),
                                            style: TextStyle(fontSize: 35),
                                          ),
                                        ),
                                      ),
                                      Card(
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              // vertical: 5,
                                              // horizontal: 5,
                                              ),
                                          child: IconButton(
                                            onPressed: () {
                                              // print('tambah 1');
                                              setState(() {
                                                qty += 1;
                                              });
                                            },
                                            icon: Icon(Icons.add_circle),
                                            iconSize: 50,
                                            color: Colors.blue[300],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.amber,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                  horizontal: 50,
                                                  vertical: 15,
                                                )),
                                            onPressed: () async {
                                              // print(
                                              //     '${baseurl}api/item/$token/$acount_id');
                                              // print(
                                              //     snapshot.data![index]['name']);
                                              // print(
                                              //     snapshot.data![index]['price']);
                                              // print(qty);

                                              var url = Uri.parse(
                                                  '${baseurl}api/item/$token/$acount_id');
                                              var response = await http.post(
                                                url,
                                                body: {
                                                  'name': snapshot.data![index]
                                                          ['name']
                                                      .toString(),
                                                  'product_id': snapshot
                                                      .data![index]
                                                          ['product_id']
                                                      .toString(),
                                                  'price': snapshot.data![index]
                                                          ['price']
                                                      .toString(),
                                                  'quantity': qty.toString(),
                                                },
                                              );

                                              if (response.statusCode == 200) {
                                                // print(response.body);
                                                Navigator.of(context)
                                                    .pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        Kasir(),
                                                  ),
                                                );
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  const SnackBar(
                                                      content: Text(
                                                          'Gagal Melakukan Transaksi! ulangi.')),
                                                );
                                              }
                                            },
                                            child: Row(
                                              children: const [
                                                Icon(Icons
                                                    .shopping_cart_checkout_outlined),
                                                Text(
                                                  'Tambah Transaksi',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ],
                                            ))
                                      ],
                                    )
                                  ],
                                );
                              });
                            });
                      }
                    },
                    child: Container(
                      color: Colors.amber[200],
                      child: snapshot.data![index]['picture'] == "" ||
                              snapshot.data![index]['picture'] == null
                          ? const Icon(
                              Icons.image,
                              size: 45,
                            )
                          : Image.network(
                              "${baseurl}img/produk/$tenan_id/${snapshot.data![index]['picture']}",
                              // loadingBuilder: (context, child, loadingProgress) =>
                              //     (loadingProgress == null)
                              //      /   ? child
                              //         : CircularProgressIndicator(),
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.image_not_supported_sharp,
                                size: 45,
                              ),
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  footer: Container(
                    padding: const EdgeInsets.all(5),
                    color: const Color.fromARGB(138, 0, 0, 0),
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          snapshot.data![index]['name'].toString(),
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Qty: ${snapshot.data![index]['quantity'].toString()}",
                          textAlign: TextAlign.end,
                          maxLines: 2,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          "Rp. " + snapshot.data![index]['price'].toString(),
                          style: const TextStyle(
                            color: Colors.amber,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: snapshot.data!.length,
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
