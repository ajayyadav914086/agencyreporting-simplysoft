import 'dart:convert';
import 'package:agencyreporting/outstandingmodel.dart';
import 'package:agencyreporting/receivabledetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'constants.dart';

class ReceivableFilter extends StatefulWidget {
  String groupcode;

  ReceivableFilter(this.groupcode, {Key? key}) : super(key: key);

  @override
  State<ReceivableFilter> createState() => _ReceivableFilterState(groupcode);
}

class _ReceivableFilterState extends State<ReceivableFilter> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  String groupcode;
  late SearchBar searchBar;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget today = SimpleDialogOption(
    child: const Text('Today'),
    onPressed: () {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now());
      print(today);
    },
  );
  Widget yesterday = SimpleDialogOption(
    child: const Text('Yesterday'),
    onPressed: () {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now());
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 1));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last7days = SimpleDialogOption(
    child: const Text('Last 7 Days'),
    onPressed: () {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now());
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 7));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last30days = SimpleDialogOption(
    child: const Text('last 30 Days'),
    onPressed: () {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now());
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 30));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last365days = SimpleDialogOption(
    child: const Text('Last 365 Days'),
    onPressed: () {
      DateFormat dateFormat = DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now());
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 365));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );

  Widget customdate(context) {
    return SimpleDialogOption(
      child: const Text('Custom Date'),
      onPressed: () {
        customDateRange(context);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Receivable"),
      actions: <Widget>[
        searchBar.getSearchAction(context),
        IconButton(
            onPressed: () {
              SimpleDialog dialog = SimpleDialog(
                title: const Text('SELECT ONE OPTION:-'),
                children: <Widget>[
                  today,
                  yesterday,
                  last7days,
                  last30days,
                  last365days,
                  customdate(context),
                ],
              );
              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog;
                },
              );
            },
            icon: const Icon(Icons.calendar_today))
      ],
    );
  }

  void onSubmitted(String value) async {
    apidata = [];
    setState(() {
      loading = true;
    });
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "group": groupcode,
      "search": value.toString()
    });
    response =
        await dio.post(Constants.RECEIVABLEFILTER_SEARCH, data: formData);
    apidata = json.decode(response.data);
    loading = false;
    setState(() {});
  }

  _ReceivableFilterState(this.groupcode) {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        buildDefaultAppBar: buildAppBar,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchBar.build(context),
        body: loading
            ? const CircularProgressIndicator()
            : ListView(
                children: apidata["data"].map<Widget>((result) {
                return InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("VCH NO: " + result['VCHNO']),
                              Text("BILL AMT: " + result['BILL_AMT'])
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("VCH DATE: " + result['VCHDT']),
                              Text(
                                "BALANCE: " + result['BILL_BAL_AMT'],
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
                              Text("PARTY: " + result['GROUPCODE']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("SUPPLIER: " + result['SUPPLIER_NAME']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("AREA: " + result['AREANAME']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("CASH BALANCE: " + result['CASH_BAL_AMT']),
                              Text("CHEQ BALANCE: " + result['CHEQ_BAL_AMT']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("NARRATION: " + result['NARRATION']),
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceivableDetail(
                                result['WONO'].toString(),
                                new Outstanding(
                                    result['VCHNO'],
                                    result['VCHDT'],
                                    result['BILL_AMT'],
                                    result['BILL_BAL_AMT'],
                                    result['GROUPCODE'],
                                    result['SUPPLIER_NAME'],
                                    result['AREANAME'],
                                    result['CASH_BAL_AMT'],
                                    result['CHEQ_BAL_AMT'],
                                    result['NARRATION']))));
                  },
                );
              }).toList()));
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
      "group": groupcode,
    });
    response = await dio.post(Constants.RECEIVABLE_FILTER, data: formData);
    apidata = json.decode(response.data);
    print(apidata['data']);
    loading = false;
    setState(() {});
  }

  void customDateRange(context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange:
            DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    print(picked);
  }
}
