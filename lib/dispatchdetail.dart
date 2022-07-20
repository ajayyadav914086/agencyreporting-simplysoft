import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class DispatchDetail extends StatefulWidget {
  late String id;

  DispatchDetail(this.id, {Key? key}) : super(key: key);

  @override
  State<DispatchDetail> createState() => _DispatchDetailState(id);
}

class _DispatchDetailState extends State<DispatchDetail> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late String id;
  late SharedPreferences pref;

  _DispatchDetailState(this.id);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dispatch"),
          actions: [
            IconButton(
                onPressed: () async {
                  final pdf = pw.Document();
                  pdf.addPage(pw.Page(
                      pageFormat: PdfPageFormat.a4,
                      build: (pw.Context context) {
                        return pw.Column(
                          children: [
                            pw.Center(
                              child:pw.Text("Dispatch"),
                            ),
                            pw.SizedBox(
                              height: 24,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "VCH DATE: " + apidata['data']['VCHDT'],
                                ),
                                pw.Text("VCHNO: " + apidata['data']['VCHNO'])
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "CUSTOMER: " + apidata['data']['CUSTOMER'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold),
                                ),
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text("SUPPLIER: " + apidata['data']['SUPPLIER']),
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "BILL DATE: " + apidata['data']['BILLDT'],
                                ),
                                pw.Text(
                                  "BILL NO: " + apidata['data']['BILLNO'],
                                )
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "QTY: " + apidata['data']['QTY'],
                                ),
                                pw.Text(
                                  "BILL AMT:" + apidata['data']['BILL_AMT'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.red),
                                )
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Divider(
                                color: PdfColors.black
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text(
                                  "QTY: " + apidata['data']['QTY'],
                                ),
                                pw.Text(
                                  "GROSS: " + apidata['data']['GROSS_AMT'],
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
                                pw.Text("DIS%: " + apidata['data']['DIS_PER']),
                                pw.Text("TAX: " + apidata['data']['TAX_AMT']),
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text("FRIGHT: " + apidata['data']['FREIGHT']),
                                pw.Text("OTHER: " + apidata['data']['OTHER_AMT']),
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "LR PAID: " + apidata['data']['LR_PAID'],
                                ),
                                pw.Text(
                                  "COMM: " + apidata['data']['COMM_AMT'],
                                )
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(""),
                                pw.Text(
                                  "BILL AMT:" + apidata['data']['BILL_AMT'],
                                )
                              ],
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "TRANSPORT: " +
                                      apidata['data']['TRANSPORTNAME'],
                                ),
                                pw.Text(
                                  "",
                                )
                              ],
                            ),
                            pw.Row(
                              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "LR NO: " + apidata['data']['LRNO'],
                                ),
                                pw.Text(
                                  "LR DATE" + apidata['data']['LRDT'],
                                )
                              ],
                            ),
                          ],
                        );
                      }));
                  Directory appDocDir =
                      await getApplicationDocumentsDirectory();
                  String appDocPath = appDocDir.path;
                  final file = File(appDocPath + '/example.pdf');
                  await file.writeAsBytes(await pdf.save());
                  Share.shareFiles([appDocPath + '/example.pdf'],
                      text: 'Great picture');
                },
                icon: Icon(Icons.share))
          ],
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
                                Text(
                                  "VCH DATE: " + apidata['data']['VCHDT'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text("VCHNO: " + apidata['data']['VCHNO'].toString(),
                                    style: TextStyle(color: Colors.white))
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "CUSTOMER: " + apidata['data']['CUSTOMER'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("SUPPLIER: " + apidata['data']['SUPPLIER'],
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "BILL DATE: " + apidata['data']['BILLDT'],
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "BILL NO: " + apidata['data']['BILLNO'],
                                  style: const TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "QTY: " + apidata['data']['QTY'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                                Text(
                                  "BILL AMT:" + apidata['data']['BILL_AMT'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.red),
                                )
                              ],
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
                                "QTY: " + apidata['data']['QTY'],
                              ),
                              Text(
                                "GROSS: " + apidata['data']['GROSS_AMT'],
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
                              Text("DIS%: " + apidata['data']['DIS_PER']),
                              Text("TAX: " + apidata['data']['TAX_AMT']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("FRIGHT: " + apidata['data']['FREIGHT']),
                              Text("OTHER: " + apidata['data']['OTHER_AMT']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LR PAID: " + apidata['data']['LR_PAID'],
                              ),
                              Text(
                                "COMM: " + apidata['data']['COMM_AMT'],
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(""),
                              Text(
                                "BILL AMT:" + apidata['data']['BILL_AMT'],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "TRANSPORT: " +
                                    apidata['data']['TRANSPORTNAME'],
                              ),
                              const Text(
                                "",
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "LR NO: " + apidata['data']['LRNO'],
                              ),
                              Text(
                                "LR DATE" + apidata['data']['LRDT'],
                              )
                            ],
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
    response = await dio.post(Constants.DISPATCH_DETAIL, data: formData);
    apidata = json.decode(response.data);
    print(apidata);
    loading = false;
    setState(() {});
  }
}
