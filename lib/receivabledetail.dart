import 'dart:convert';
import 'package:agencyreporting/outstandingmodel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

class ReceivableDetail extends StatefulWidget {
  late String id;
  Outstanding outstanding;

  ReceivableDetail(this.id,this.outstanding,{Key? key}) : super(key: key);

  @override
  State<ReceivableDetail> createState() => _ReceivableDetailState(id,outstanding);
}

class _ReceivableDetailState extends State<ReceivableDetail> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late String id;
  Outstanding outstanding;

  @override
  void initState() {
    getData();
    super.initState();
  }

  _ReceivableDetailState(this.id,this.outstanding);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Receivable"),
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
                          Text("VCH NO: "+ outstanding.vchno,style: TextStyle(color: Colors.white),),
                          Text("BILL AMT: " + outstanding.billamt,style: TextStyle(color: Colors.white))
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("VCH DATE: "+ outstanding.vchno,style: TextStyle(color: Colors.white)),
                          Text(
                            "BALANCE: "+ outstanding.balance ,
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
                          Text("PARTY: " + outstanding.party,style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("SUPPLIER: "+ outstanding.supplier,style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("AREA: "+ outstanding.area,style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("CASH BALANCE: "+ outstanding.cashbal,style: TextStyle(color: Colors.white)),
                          Text("CHEQ BALANCE: "+ outstanding.cheqbal,style: TextStyle(color: Colors.white)),
                        ],
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text("NARRATION: "+ outstanding.narration,style: TextStyle(color: Colors.white)),
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
                          "PAY NO: "+apidata['data']['PAYNO'],
                        ),
                        Text(
                          "PAYMENT AMT: "+apidata['data']['PAYMENT_AMT'],
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
                        Text("PAY DATE: "+apidata['data']['PAYDT']),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("CHEQ NO: "+apidata['data']['CHEQ_NO']),
                        Text("CHEQ DATE: "+checknull(apidata['data']['CHEQ_DT'])),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                            "REMARK: "+apidata['data']['REMARKS']
                        ),
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
     FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "id": id
    });
    response = await dio.post(Constants.OUTSTANDING_DETAIL, data: formData);
    apidata = json.decode(response.data);
    print(apidata);
    loading = false;
    setState(() {});
  }
  String checknull(data) {
    if(data == null){
      return "";
    }
    return data;
  }
}
