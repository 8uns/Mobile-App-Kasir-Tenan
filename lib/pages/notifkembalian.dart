import 'package:flutter/material.dart';

import 'kasir.dart';

class NotifKembalian extends StatelessWidget {
  String kemb;

  NotifKembalian(this.kemb);

  static const nameRoute = '/notifkembalian';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Pembayaran'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              vertical: 40,
            ),
            width: MediaQuery.of(context).size.width * 1,
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        size: 80,
                        color: Colors.teal[200],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: const Text(
                        "Berhasil",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text('Terimakasih telah menggunakan Kasir Tenan.'),
                    Container(
                      margin: EdgeInsets.symmetric(
                        vertical: 10,
                      ),
                      child: Text(
                        "Kembalian : Rp. $kemb",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.symmetric(
                          vertical: 20,
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => Kasir(),
                              ),
                            );
                          },
                          child: const Text(
                            'Kembali Ke Kasir',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
