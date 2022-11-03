import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:kasir_tenan_0_1/pages/billing.dart';

import '../config.dart';

// ignore: use_key_in_widget_constructors
class UploadSlip extends StatefulWidget {
  static const nameRoute = '/UploadSlip';
  String idbilling;
  String tipedoc;
  UploadSlip({required this.idbilling, required this.tipedoc});
  @override
  State<UploadSlip> createState() => _UploadSlipState(idbilling, tipedoc);
}

class _UploadSlipState extends State<UploadSlip> {
  String idbilling;
  String tipedoc;

  _UploadSlipState(this.idbilling, this.tipedoc);
  // ignore: unused_field
  final ImagePicker _picker = ImagePicker();

  String? base64Img;

  File? tmpImg;

  String filename = '';

  // ignore: non_constant_identifier_names

  Future pickImage() async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 50);

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
      final image = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);

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
        title: Text(
          "Bukti Bayar ${tipedoc.toUpperCase()}",
          style: TextStyle(
            fontSize: 14,
          ),
        ),
        backgroundColor: tipedoc == 'konsesi'
            ? Colors.blue
            : tipedoc == 'listrik'
                ? Colors.amberAccent
                : Colors.orange,
      ),
      body: Form(
        key: _formKey,
        // ignore: sized_box_for_whitespace
        child: Center(
          // height: MediaQuery.of(context).size.height * 1,
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
                        color: Colors.white,
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.only(
                          top: 2,
                          bottom: 30,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: tipedoc == 'konsesi'
                      ? Colors.blue
                      : tipedoc == 'listrik'
                          ? Colors.amberAccent
                          : Colors.orange,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 30,
                  ),
                ),
                onPressed: () async {
                  if (!isLoading) {
                    setState(() => isLoading = true);
                    await reqUploadSlip(context);
                  }
                },
                icon: const Icon(
                  Icons.upload,
                  color: Colors.white,
                ),
                label: isLoading
                    ? CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Upload Bukti Bayar',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cekImage() {
    final tmpImg = this.tmpImg;
    if (tmpImg != null) {
      filename = tmpImg.path.split('/').last;
      base64Img = base64Encode(tmpImg.readAsBytesSync());
    } else {
      base64Img = '';
    }

    return tmpImg != null
        ? Image.file(tmpImg)
        : const Text('Bukti bayar belum ada silahkan diupload!');
  }

  Future<void> reqUploadSlip(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      var url = Uri.parse('${baseurl}api/billing/$token/${idbilling}');
      var response = await http.post(
        url,
        body: {
          'filepaymantName': filename,
          'filepaymant': base64Img,
          'filetipe': tipedoc,
          'tenan_id': tenan_id,
        },
      );

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Billing(''),
          ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal Upload! Ulangi.')),
        );
      }
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
                    pickImage();
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
