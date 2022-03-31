import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'constants.dart';

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
                                Text("VCHNO: " + apidata['data']['VCHNO'],
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
                              Text("GROSS: " + apidata['data']['GROSS_AMT'],)
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
                                "DIS%: " + apidata['data']['DIS_PER']
                              ),
                              Text(
                                  "TAX: " + apidata['data']['TAX_AMT']
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
                              const Text(
                                ""
                              ),
                              Text(
                                "BILL AMT:" + apidata['data']['BILL_AMT'],
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  "TRANSPORT: " + apidata['data']['TRANSPORTNAME'],
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
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "id": id
    });
    response = await dio.post(Constants.DISPATCH_DETAIL, data: formData);
    apidata = json.decode(response.data);
    print(apidata);
    loading = false;
    setState(() {});
  }
}
