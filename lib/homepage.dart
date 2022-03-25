import 'package:agencyreporting/dispatch.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // style
    // ignore: unused_local_variable
    var cardTextStyle = const TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/top_header.png')),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          width: 16,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: <Widget>[
                            const Text(
                              'John Richardo',
                              style: TextStyle(
                                  fontFamily: "Montserrat Medium",
                                  color: Colors.white,
                                  fontSize: 20),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          child:Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset("assets/growth.png",height: 70,width: 70,),
                                const Text(
                                  'Dispatch',
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  'Total ',
                                  style: cardTextStyle,
                                )
                              ],
                            ),
                          ),
                          onTap: (){
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dispatch()));
                          },
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/receipt.png",height: 70,width: 70,),
                              const Text(
                                'Receipt',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Total ',
                                style: cardTextStyle,
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/credit-card.png",height: 70,width: 70,),
                              const Text(
                                'Payment',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Total ',
                                style: cardTextStyle,
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/save-money.png",height: 70,width: 70,),
                              const Text(
                                'Receivable',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Total ',
                                style: cardTextStyle,
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/payment.png",height: 70,width: 70,),
                              const Text(
                                'Payable',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                'Total ',
                                style: cardTextStyle,
                              )
                            ],
                          ),
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset("assets/rent.png",height: 70,width: 70,),
                              const Text(
                                'Interest',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Report ',
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
