import 'dart:convert';
import 'dart:io';
import 'package:agencyreporting/payablefilter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Payable extends StatefulWidget {
  const Payable({Key? key}) : super(key: key);

  @override
  State<Payable> createState() => _PayableState();
}

class _PayableState extends State<Payable> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late ScrollController _controller;
  late SearchBar searchBar;
  late var startdate;
  late var enddate;
  bool isDataEmpty = false;
  DateFormat dateFormat = DateFormat("yyyy-MM-dd");

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    startdate = dateFormat.format(DateTime.now().subtract(Duration(days: 30)));
    enddate = dateFormat.format(DateTime.now());
    getData(startdate, enddate);
    super.initState();
  }

  Widget today(context) {
    return SimpleDialogOption(
      child: const Text('Today'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        getData(today, today);
        Navigator.pop(context);
      },
    );
  }

  Widget yesterday(context) {
    return SimpleDialogOption(
      child: const Text('Yesterday'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final yesterday = todaydatetime.subtract(Duration(days: 1));
        final yesterdayformat = dateFormat.format(yesterday);
        getData(yesterdayformat, yesterdayformat);
        Navigator.pop(context);
      },
    );
  }

  Widget last7days(context) {
    return SimpleDialogOption(
      child: const Text('Last 7 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final week = todaydatetime.subtract(Duration(days: 7));
        final weekformat = dateFormat.format(week);
        getData(weekformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget last30days(context) {
    return SimpleDialogOption(
      child: const Text('last 30 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final month = todaydatetime.subtract(Duration(days: 30));
        final monthformat = dateFormat.format(month);
        getData(monthformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget last365days(context) {
    return SimpleDialogOption(
      child: const Text('Last 365 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final year = todaydatetime.subtract(Duration(days: 365));
        final yearformat = dateFormat.format(year);
        getData(yearformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget customdate(context) {
    return SimpleDialogOption(
      child: const Text('Custom Date'),
      onPressed: () {
        Navigator.pop(context);
        customDateRange(context);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Payable"),
      actions: <Widget>[
        searchBar.getSearchAction(context),
        IconButton(
            onPressed: () {
              SimpleDialog dialog = SimpleDialog(
                title: const Text('SELECT ONE OPTION:-'),
                children: <Widget>[
                  today(context),
                  yesterday(context),
                  last7days(context),
                  last30days(context),
                  last365days(context),
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
            icon: const Icon(Icons.calendar_today)),
        IconButton(
            onPressed: () async {
              final pdf = pw.Document();
              pdf.addPage(pw.MultiPage(
                  pageFormat: PdfPageFormat.a4,
                  build: (pw.Context context) {
                    return <pw.Widget>[
                      pw.Center(
                        child:pw.Text("Payable"),
                      ),
                      pw.SizedBox(
                        height: 24,
                      ),
                      pw.Column(
                          children: apidata["data"].map<pw.Column>((result) {
                        return pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              "PARTY NAME : " + result['GROUPCODE'],
                              style: pw.TextStyle(
                                  color: PdfColors.blue,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("AREA : " + result['AREANAME']),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text(
                              "BALANCE : " + result['BILL_BAL_AMT'],
                              style: pw.TextStyle(
                                  color: PdfColors.red,
                                  fontWeight: pw.FontWeight.bold),
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("CASH BALANCE : " + result['CASH_BAL_AMT']),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Text("CHEQ BALANCE : " + result['CHEQ_BAL_AMT']),
                            pw.SizedBox(
                              height: 16,
                            ),
                            pw.Divider(color: PdfColors.black)
                          ],
                        );
                      }).toList())
                    ];
                  }));
              Directory appDocDir = await getApplicationDocumentsDirectory();
              String appDocPath = appDocDir.path;
              final file = File(appDocPath + '/example.pdf');
              await file.writeAsBytes(await pdf.save());
              Share.shareFiles([appDocPath + '/example.pdf'],
                  text: 'Great picture');
            },
            icon: Icon(Icons.share))
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
      "search": value.toString()
    });
    response = await dio.post(Constants.PAYABLE_SEARCH, data: formData);
    apidata = json.decode(response.data);
    loading = false;
    setState(() {});
  }

  _PayableState() {
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
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: searchBar.build(context),
        body: loading
            ? const CircularProgressIndicator()
            : isDataEmpty
                ? const Center(child: Text("No Data"))
                : ListView(
                    children: apidata["data"].map<Widget>((result) {
                    return InkWell(
                      child: Card(
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "PARTY NAME : " + result['GROUPCODE'],
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("AREA : " + result['AREANAME']),
                              const SizedBox(
                                height: 8,
                              ),
                              Text(
                                "BALANCE : " + result['BILL_BAL_AMT'],
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("CASH BALANCE : " + result['CASH_BAL_AMT']),
                              const SizedBox(
                                height: 8,
                              ),
                              Text("CHEQ BALANCE : " + result['CHEQ_BAL_AMT']),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PayableFilter(result['GROUPCODE'])));
                      },
                    );
                  }).toList()));
  }

  void getData(startdate, enddate) async {
    setState(() {
      loading = true; //make loading true to show progressindicator
      isDataEmpty = false;
    });
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "startdate": startdate,
      "enddate": enddate,
    });
    response = await dio.post(Constants.PAYABLE, data: formData);
    apidata = json.decode(response.data);
    if (apidata['response'] == 404) {
      setState(() {
        isDataEmpty = true;
      });
    }
    print(apidata['data']);
    loading = false;
    setState(() {});
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("Scroll to bottom");
    }
  }

  void customDateRange(context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange:
            DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    print(picked);
    var startdate = picked?.start;
    var formattedstartdate = dateFormat.format(startdate!);
    var enddate = picked?.end;
    var formattedenddate = dateFormat.format(enddate!);
    getData(formattedstartdate, formattedenddate);
  }
}
