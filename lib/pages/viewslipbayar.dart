import 'package:flutter/material.dart';
import 'package:kasir_tenan_0_1/config.dart';
import 'package:kasir_tenan_0_1/pages/uploadslip.dart';

class ViewSlipBayar extends StatelessWidget {
  String img;
  String valid;
  String billingid;
  String month;
  String year;
  String tipedoc;
  ViewSlipBayar({
    required String this.img,
    required String this.valid,
    required String this.billingid,
    required String this.month,
    required String this.year,
    required String this.tipedoc,
  });
  static const nameRoute = '/billing';

  @override
  Widget build(BuildContext context) {
    // print("${baseurl}file/payment/$tenan_id/$img");
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bukti Bayar ${tipedoc.toUpperCase()} {month.toUpperCase()} $year',
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
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Image(
                image: NetworkImage("${baseurl}file/payment/$tenan_id/$img"),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Container(
          color: tipedoc == 'konsesi'
              ? Colors.blue
              : tipedoc == 'listrik'
                  ? Colors.amberAccent
                  : Colors.orange,
          height: 60,
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: valid == '0'
                  ? [
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          primary: tipedoc == 'konsesi'
                              ? Colors.blue
                              : tipedoc == 'listrik'
                                  ? Colors.amberAccent
                                  : Colors.orange,
                        ),
                        onPressed: () async {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => UploadSlip(
                                tipedoc: tipedoc,
                                idbilling: billingid,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.upgrade,
                          color: Colors.white,
                        ),
                        label: const Text(
                          'Perbarui Bukti bayar',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]
                  : []),
        ),
      ),
    );
  }
}
