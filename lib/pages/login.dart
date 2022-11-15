import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import 'kasir.dart';

class Login extends StatefulWidget {
  static const nameRoute = '/login';

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  void setPreferenseLogin(data) async {
    final pref = await SharedPreferences.getInstance();
    if (pref.containsKey('username')) {
      pref.clear();
    }

    pref.setString('fullname', data['name']);
    pref.setString('username', data['username']);
    pref.setString('nameTenan', data['tenan'].toString());
    pref.setString('imageTenan', data['image']);
    pref.setString('token', data['token'].toString());
    pref.setString('acount_id', data['acount_id'].toString());
    pref.setString('tenan_id', data['tenan_id'].toString());
    pref.setString('masa_kontrak', data['contract_period'].toString());

    fullname = pref.getString('fullname')!;
    username = pref.getString('username')!;
    token = pref.getString('token')!;
    acount_id = pref.getString('acount_id')!;
    imageTenan = pref.getString('imageTenan')!;
    nameTenan = pref.getString('nameTenan')!;
    tenan_id = pref.getString('tenan_id')!;
    masa_kontrak = pref.getString('masa_kontrak')!;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => Kasir(),
      ),
    );
  }

  void clearPref() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
  }

  void getPreferenceLogin() async {
    final pref = await SharedPreferences.getInstance();

    if (pref.containsKey('username') &&
        pref.containsKey('token') &&
        pref.containsKey('acount_id')) {
      fullname = pref.getString('fullname')!;
      username = pref.getString('username')!;
      token = pref.getString('token')!;
      acount_id = pref.getString('acount_id')!;
      imageTenan = pref.getString('imageTenan')!;
      nameTenan = pref.getString('nameTenan')!;
      tenan_id = pref.getString('tenan_id')!;
      masa_kontrak = pref.getString('masa_kontrak')!;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Kasir(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // getPreferenceLogin();

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
          height: MediaQuery.of(context).size.height * 1,
          color: Colors.grey[60],
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.19,
                ),
                Container(
                  width: 250,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(5),
                  child: const Text(
                    "S I M P E L",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.w500,
                      color: Colors.amber,
                    ),
                  ),
                ),
                Container(
                  // height: MediaQuery.of(context).size.height * 0.7,
                  height: 400,
                  padding: const EdgeInsets.all(10.0),
                  // color: Colors.amber,
                  child: Card(
                    color: Colors.grey[100],
                    elevation: 10.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      // color: Colors.amber,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.all(0),
                            child: const Text(
                              "Kasir Tenan",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            padding: EdgeInsets.all(15),
                            child: TextFormField(
                              decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.people),
                                focusColor: Colors.amber,
                                hintText: "username",
                                labelText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Username tidak boleh kosong';
                                }
                                username = value;
                                return null;
                              },
                            ),
                          ),
                          Container(
                            // color: Colors.amber,
                            padding: EdgeInsets.all(15),
                            margin: EdgeInsets.only(
                              top: 5,
                              bottom: 20,
                            ),
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.password,
                                ),
                                hintText: "******",
                                labelText: "Password",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password tidak boleh kosong';
                                }
                                password = value;
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 60,
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  primary: Colors.amber,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 20,
                                    horizontal: 20,
                                  )),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  var url = Uri.parse('${baseurl}api/login/');
                                  var response = await http.post(
                                    url,
                                    body: {
                                      'username': username,
                                      'password': password,
                                    },
                                  );

                                  if (response.statusCode == 200) {
                                    var hasil = jsonDecode(response.body);
                                    if (hasil['condition']) {
                                      setPreferenseLogin(hasil['data']);
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Username atau Password Salah !!!')),
                                      );
                                    }
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Gagal Login! Kesalahan System')),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(
                                Icons.login,
                                color: Colors.black,
                                size: 18,
                              ),
                              label: Text(
                                'Masuk',
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 20),
                  child: Text(
                    'Copyright @ 2022 | Supported by Tifa Malut',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
