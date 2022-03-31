import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class ReceiptPaymentDetail extends StatefulWidget {
  late String title;
  late String id;
  late String amt;

  ReceiptPaymentDetail(this.title, this.id, this.amt, {Key? key})
      : super(key: key);

  @override
  State<ReceiptPaymentDetail> createState() =>
      _ReceiptPaymentDetailState(title, id, amt);
}

class _ReceiptPaymentDetailState extends State<ReceiptPaymentDetail> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late String title;
  late String id;
  late String amt;

  _ReceiptPaymentDetailState(this.title, this.id, this.amt);

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: loading
            ? const CircularProgressIndicator()
            : Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.lightBlue,
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("VCHNO: " + apidata['data'][0]['VCHNO'],
                                  style: const TextStyle(color: Colors.white)),
                              Text(
                                "TOTAL AMT:" + amt,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "VCH DATE: " + apidata['data'][0]['VCHDT'],
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text("NARRATION: ",
                                  style: TextStyle(color: Colors.white)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.grey,
                    padding: const EdgeInsets.all(10),
                    child: Text("ITEMS (TOTAL ITEMS: " +
                        apidata['data'].length.toString() +
                        ")"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.red[200],
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [Text("ACCOUNT"), Text("DR"), Text("CR")],
                    ),
                  ),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.red[200],
                      padding: const EdgeInsets.only(left: 10,right: 10,bottom: 10),
                      child: Column(
                          children: apidata["data"].map<Widget>(
                        (result) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(result['GROUPNAME']),
                                Text(result['DR_AMT']),
                                Text(result['CR_AMT']),
                              ],
                            ),
                          );
                        },
                      ).toList()))
                ],
              ));
  }

  void getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "id": id
    });
    response = await dio.post(Constants.RECEIPT_PAYMENT_DETAIL, data: formData);
    apidata = json.decode(response.data);
    print(apidata);
    loading = false;
    setState(() {});
  }
}
