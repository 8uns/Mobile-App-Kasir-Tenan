import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../config.dart';
import 'kelolaproduk.dart';

// ignore: use_key_in_widget_constructors
class TambahProduk extends StatefulWidget {
  static const nameRoute = '/tambahproduk';

  @override
  State<TambahProduk> createState() => _TambahProdukState();
}

class _TambahProdukState extends State<TambahProduk> {
  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();

  String? name;

  String? quantity;

  String? base64Img;

  String? price;

  File? tmpImg;

  // String filename = '';

  // ignore: non_constant_identifier_names

  Future getImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.gallery, imageQuality: 55, maxWidth: 300);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        // ignore: unnecessary_this
        this.tmpImg = imageTemp;
      });
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
    }
  }

  Future tagImage() async {
    try {
      final image = await ImagePicker().pickImage(
          source: ImageSource.camera, imageQuality: 55, maxWidth: 300);

      if (image == null) return;

      final imageTemp = File(image.path);

      setState(() {
        // ignore: unnecessary_this
        this.tmpImg = imageTemp;
      });
      // ignore: unused_catch_clause
    } on PlatformException catch (e) {
      // ignore: avoid_print
    }
  }

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Tambah Produk Baru"),
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
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(15),
                            child: TextFormField(
                              decoration: const InputDecoration(
                                hintText: "masukan nama barang",
                                labelText: "Nama Barang",
                                icon: Icon(Icons.inventory),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Nama Barang Kosong!';
                                }
                                name = value;
                                return null;
                              },
                            ),
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
                                icon: Icon(Icons.price_change),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Masukan Stok Barang';
                                }
                                quantity = value;
                                return null;
                              },
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
                                labelText: "Harga Barang",
                                icon: Icon(Icons.price_change),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Harga Barang Kosong!';
                                }
                                price = value;
                                return null;
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 1,
                            color: Colors.white,
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(
                              top: 2,
                              bottom: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 20,
                                  ),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      showDialogUpload(context);
                                    },
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                        ),
                                        Text(
                                          'Upload Gambar',
                                          style: TextStyle(
                                            fontSize: 15,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            margin: const EdgeInsets.only(bottom: 30),
                            child: cekImage(),
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
                    if (name != null && quantity != null && price != null) {
                      setState(() => isLoading = true);
                      await reqTambahProduk(context);
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

  Widget cekImage() {
    final tmpImg = this.tmpImg;
    if (tmpImg != null) {
      // filename = tmpImg.path.split('/').last;
      base64Img = base64Encode(tmpImg.readAsBytesSync());
    } else {
      base64Img = '';
    }

    return tmpImg != null
        ? Image.file(tmpImg)
        : const Text('Tidak ada gambar barang');
  }

  Future<void> reqTambahProduk(BuildContext context) async {
    var url = Uri.parse('${baseurl}api/produk/$token');
    var response = await http.post(
      url,
      body: {
        'name': name,
        'quantity': quantity,
        'price': price,
        'tenan_id': tenan_id,
        // 'picture_name': filename,
        'picture': base64Img,
      },
    );

    if (response.statusCode == 200) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => KelolaProduk(),
        ),
      );
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal Menyimpan Data! ulangi.')),
      );
    }
  }

  Future<dynamic> showDialogUpload(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[50],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'Pilih media upload',
              ),
            ],
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () {
                    getImage();
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.image,
                        color: Colors.grey,
                      ),
                      Text(
                        'Dari Galery',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                OutlinedButton(
                  onPressed: () {
                    tagImage();
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(
                        Icons.camera_alt,
                        color: Colors.grey,
                      ),
                      Text(
                        'Dari Camera',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        );
      },
    );
  }
}
