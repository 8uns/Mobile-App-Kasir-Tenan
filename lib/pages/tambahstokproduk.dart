// ignore_for_file: unnecessary_null_in_if_null_operators

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kasir_tenan_0_1/pages/inventaris.dart';
import '../config.dart';

List<String> listSelect = <String>['One', 'Two', 'Three', 'Four'];

// ignore: use_key_in_widget_constructors
class TambahStokProduk extends StatefulWidget {
  static const nameRoute = '/tambahstokproduk';

  @override
  State<TambahStokProduk> createState() => _TambahStokProdukState();
}

class _TambahStokProdukState extends State<TambahStokProduk> {
  String produkApi = "${baseurl}api/produk/$token";
  List dataProduct = [];
  String? _dropdownValue = null;

  Future<String> _transaksi() async {
    var result = await http.get(Uri.parse(produkApi));
    var data = json.decode(result.body)['data'];
    setState(() {
      dataProduct = data;
    });
    return "success";
  }

  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();

  String? quantity;
  String? product_id;

  // ignore: non_constant_identifier_names

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _transaksi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tambah Stok Produk"),
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
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                color: Colors.white,
                                width: MediaQuery.of(context).size.width * 1,
                                padding: EdgeInsets.only(
                                  left:
                                      MediaQuery.of(context).size.width * 0.15,
                                  top: 15,
                                  bottom: 15,
                                  right: 15,
                                ),
                                margin: const EdgeInsets.only(
                                  top: 5,
                                  bottom: 5,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: Text(
                                      "Pilih Product",
                                    ),
                                    // underline: Container(
                                    //   height: 1,
                                    //   color: Colors.grey,
                                    // ),
                                    items: dataProduct
                                        .map<DropdownMenuItem<String>>((item) {
                                      return DropdownMenuItem<String>(
                                        value: item['product_id'].toString(),
                                        child: Text(item['name']),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() {
                                        _dropdownValue = value!;
                                        product_id = _dropdownValue;
                                      });
                                      print(_dropdownValue);
                                    },
                                    value: _dropdownValue,
                                  ),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 35,
                                    left: MediaQuery.of(context).size.width *
                                        0.04),
                                child: Icon(
                                  Icons.inventory,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                  hintText: "0",
                                  labelText: "Stok",
                                  icon: Icon(Icons.playlist_add_outlined)),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan Stok Barang';
                                }
                                quantity = value;
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            color: Colors.transparent,
            height: 60,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: MediaQuery.of(context).size.width * 0.3,
                    ),
                  ),
                  onPressed: () async {
                    if (quantity != null &&
                        quantity != 0 &&
                        product_id != null) {
                      setState(() => isLoading = true);
                      await reqTambahStokProduk(context);
                    } else {
                      _formKey.currentState!.validate();
                    }
                  },
                  child: isLoading
                      ? CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Tambahkan',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> reqTambahStokProduk(BuildContext context) async {
    var url = Uri.parse('${baseurl}api/inventaris/$token/${product_id}');
    var response = await http.post(
      url,
      body: {
        'quantity': quantity,
      },
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Inventaris(''),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal Menyimpan Data! ulangi.')),
      );
    }
  }
}
