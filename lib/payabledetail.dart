import 'dart:convert';
import 'dart:io';

import 'package:agencyreporting/outstandingmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PayableDetail extends StatefulWidget {
  late String id;
  Outstanding outstanding;

  PayableDetail(this.id, this.outstanding, {Key? key}) : super(key: key);

  @override
  State<PayableDetail> createState() => _PayableDetailState(id, outstanding);
}

class _PayableDetailState extends State<PayableDetail> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late String id;
  Outstanding outstanding;
  late SharedPreferences pref;

  @override
  void initState() {
    getData();
    super.initState();
  }

  _PayableDetailState(this.id, this.outstanding);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Payable"),
          actions: [IconButton(onPressed: () async {
            final pdf = pw.Document();
            pdf.addPage(pw.Page(
                pageFormat: PdfPageFormat.a4,
                build: (pw.Context context) {
                  return pw.Column(
                    children: [
                      pw.Center(
                        child:pw.Text("Payable"),
                      ),
                      pw.SizedBox(
                        height: 24,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("VCH NO: " + outstanding.vchno),
                          pw.Text("BILL AMT: " + outstanding.billamt)
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("VCH DATE: " + outstanding.vchdt),
                          pw.Text(
                            "BALANCE: " + outstanding.balance,
                            style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.red),
                          )
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("PARTY: " + outstanding.party,),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("SUPPLIER: " + outstanding.supplier),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("AREA: " + outstanding.area,),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("CASH BALANCE: " + outstanding.cashbal),
                          pw.Text("CHEQ BALANCE: " + outstanding.cheqbal),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("NARRATION: " + outstanding.narration),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Divider(
                        color: PdfColors.black
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "PAY NO: " + apidata['data']['PAYNO'],
                          ),
                          pw.Text(
                            "PAYMENT AMT: " +
                                apidata['data']['PAYMENT_AMT'],
                          )
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("PAY DATE: " + apidata['data']['PAYDT']),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text("CHEQ NO: " + apidata['data']['CHEQ_NO']),
                          pw.Text("CHEQ DATE: " +
                              checknull(apidata['data']['CHEQ_DT'])),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                      pw.Row(
                        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text("REMARK: " + apidata['data']['REMARKS']),
                        ],
                      ),
                      pw.SizedBox(
                        height: 8,
                      ),
                    ]
                  );
                }));
            Directory appDocDir = await getApplicationDocumentsDirectory();
            String appDocPath = appDocDir.path;
            final file = File(appDocPath + '/example.pdf');
            await file.writeAsBytes(await pdf.save());
            Share.shareFiles([appDocPath + '/example.pdf'],
            text: 'Great picture');
          }, icon: Icon(Icons.share))],
        ),
        body: loading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.lightBlue,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("VCH NO: " + outstanding.vchno,
                                    style: TextStyle(color: Colors.white)),
                                Text("BILL AMT: " + outstanding.billamt,
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("VCH DATE: " + outstanding.vchdt,
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                  "BALANCE: " + outstanding.balance,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("PARTY: " + outstanding.party,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("SUPPLIER: " + outstanding.supplier,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("AREA: " + outstanding.area,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("CASH BALANCE: " + outstanding.cashbal,
                                    style: TextStyle(color: Colors.white)),
                                Text("CHEQ BALANCE: " + outstanding.cheqbal,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("NARRATION: " + outstanding.narration,
                                    style: TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                          ],
                        ),
                      )),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "PAY NO: " + apidata['data']['PAYNO'],
                              ),
                              Text(
                                "PAYMENT AMT: " +
                                    apidata['data']['PAYMENT_AMT'],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("PAY DATE: " + apidata['data']['PAYDT']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("CHEQ NO: " + apidata['data']['CHEQ_NO']),
                              Text("CHEQ DATE: " +
                                  checknull(apidata['data']['CHEQ_DT'])),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("REMARK: " + apidata['data']['REMARKS']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ));
  }

  void getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    pref = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "server": pref.get("ip"),
      "username": pref.get("username"),
      "password": pref.get("password"),
      "database": pref.get("database"),
      "id": id
    });
    response = await dio.post(Constants.OUTSTANDING_DETAIL, data: formData);
    apidata = json.decode(response.data);
    // print(apidata);
    loading = false;
    setState(() {});
  }

  String checknull(data) {
    if (data == null) {
      return "";
    }
    return data;
  }
}
