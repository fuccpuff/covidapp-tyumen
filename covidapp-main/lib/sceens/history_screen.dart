import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covidapp/services/day_with_cough.dart';
import 'package:covidapp/widgets/line_graph.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy ');
  final String formatted = formatter.format(now);
  CollectionReference collectionReference;
  DocumentReference documentReference;
  List<double> temps = [];
  List<FlSpot> mySpot = [];
  int length;
  User user = FirebaseAuth.instance.currentUser;

  get() async {
    temps = [];
    await collectionReference.get().then((QuerySnapshot querySnapshot) => {
          querySnapshot.docs.forEach((doc) {
            //print(doc['Temperature'].substring(0, 4));
            temps.add(double.parse(doc['Temperature'].substring(0, 4)));
          })
        });
    length = temps.length;
    setValues();
  }

  setValues() {
    print(length);
    for (int x = 0; x < length; x++) {
      setState(() {
        mySpot.add(
          FlSpot(x.toDouble(), temps[x] == null ? 35 : temps[x]),
        );
      });
    }
  }

  @override
  void initState() {
    collectionReference = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('Symptoms');
    documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(user.email)
        .collection('Symptoms')
        .doc();
    get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: GestureDetector(
              onTap: () {
                print(temps.length);
                get();
              },
              child: Text('История ваших симптомов')),
        ),
        body: collectionReference != null
            ? ListView(
                physics: BouncingScrollPhysics(),
                children: [
                  SizedBox(height: 20),
                  Container(
                    height: size.height * 0.5,
                    decoration: BoxDecoration(),
                    child: Column(
                      children: [
                        Column(
                          children: [
                            Text(
                              'Последние 7 измерений температуры',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            Container(
                                padding: EdgeInsets.only(left: 10, right: 20),
                                width: double.infinity,
                                height: size.height * 0.4,
                                child: LineChartSample2(
                                  mySpot: mySpot,
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  StreamBuilder(
                      stream: collectionReference.snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.data == null) {
                          return Column(
                            children: [
                              SizedBox(height: size.height * 0.25),
                              SpinKitWave(
                                color: Colors.brown,
                                size: 80,
                              ),
                            ],
                          );
                        } else {
                          return Container(
                            height: 200,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  var doc = snapshot.data.docs[index].data();
                                  return Padding(
                                    padding: EdgeInsets.all(5.0),
                                    child: DayWithCough(
                                      status: doc['Status'],
                                      cough: doc['Cough Type'],
                                      day: doc['date'],
                                      taste: doc['Smell']
                                          ? 'чувствуете'
                                          : 'не чувствуете',
                                      gorlo: doc['Gorlo']
                                          ? 'болит'
                                          : 'не болит',
                                      diary: doc['Diary']
                                      ? 'беспокоит'
                                      : 'не беспокоит',
                                      painHead: doc['PainHead']
                                      ? 'беспокоит'
                                      : 'не беспокоит',
                                      speedPain: doc['speedPain']
                                      ? 'быстро'
                                      : 'медленная',
                                      temp: doc['Temperature'],
                                    ),
                                  );
                                }),
                          );
                        }
                      }),
                ],
              )
            : Center(
                child: SpinKitWave(
                  color: Colors.red[200],
                  size: 80.0,
                ),
              ));
  }
}
