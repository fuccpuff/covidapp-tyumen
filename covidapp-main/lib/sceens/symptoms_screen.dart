import 'package:covidapp/sceens/treatment_centers_screen.dart';
import 'package:covidapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'history_screen.dart';

class SymptomScreen extends StatefulWidget {
  @override
  _SymptomScreenState createState() => _SymptomScreenState();
}

class _SymptomScreenState extends State<SymptomScreen> {
  bool smell = false;
  bool noSmell = false;
  bool gorlo = false;
  bool noGorlo = false;
  bool diary = false;
  bool noDiary = false;
  bool painHead = false;
  bool nopainHead = false;
  bool speedPain = false;
  bool nospeedPain = false;
  String temp, day, cough;
  DateTime date = DateTime.now();
  User user = FirebaseAuth.instance.currentUser;
  DatabaseService myDataBase;

  @override
  void initState() {
    super.initState();
    day = DateFormat('EEEE').format(date);
    myDataBase = DatabaseService(userEmail: user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Какие симптомы вы чувствуете?'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: ListView(
          children: [
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                items: <String>[
                  '35.0°C',
                  '35.5°C',
                  '36.0°C',
                  '36.5°C',
                  '37.0°C',
                  '37.5°C',
                  '38.0°C',
                  '38.5°C',
                  '39.0°C',
                  '39.5°C >',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    temp = value;
                  });
                },
                isExpanded: true,
                value: temp,
                hint: Text('Какая у вас температура?'),
              ),
            ),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: DropdownButton<String>(
                items: <String>[
                  'Кашля нет',
                  'Сухой кашель',
                  'Влажный кашель',
                  'Легкий кашель'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    cough = value;
                  });
                },
                isExpanded: true,
                value: cough,
                hint: Text('Тип кашля'),
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Чувствуете ли вы запахи?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: smell,
                        onChanged: (value) {
                          setState(() {
                            smell = value;
                            noSmell = !smell;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: noSmell,
                        onChanged: (value) {
                          setState(() {
                            noSmell = value;
                            smell = !noSmell;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Болит ли у вас горло?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: gorlo,
                        onChanged: (value) {
                          setState(() {
                            gorlo = value;
                            noGorlo = !gorlo;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: noGorlo,
                        onChanged: (value) {
                          setState(() {
                            noGorlo = value;
                            gorlo = !noGorlo;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Вас беспокоит диарея?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: diary,
                        onChanged: (value) {
                          setState(() {
                            diary = value;
                            noDiary = !diary;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: noDiary,
                        onChanged: (value) {
                          setState(() {
                            noDiary = value;
                            diary = !noDiary;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Головные боли присутствуют?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: painHead,
                        onChanged: (value) {
                          setState(() {
                            painHead = value;
                            nopainHead = !painHead;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: nopainHead,
                        onChanged: (value) {
                          setState(() {
                            nopainHead = value;
                            painHead = !nopainHead;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Быстро ли вы утомляетесь?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: speedPain,
                        onChanged: (value) {
                          setState(() {
                            speedPain = value;
                            nospeedPain = !speedPain;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: nospeedPain,
                        onChanged: (value) {
                          setState(() {
                            nospeedPain = value;
                            speedPain = !nospeedPain;
                          });
                        }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 50),
            MaterialButton(
                color: Colors.amber,
                elevation: 2,
                child: Text(
                  'Подтвердить',
                  style: TextStyle(
                      color: Colors.white, letterSpacing: 1, fontSize: 18),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                onPressed: () {
                  if (temp == null || cough == null) {
                    Fluttertoast.showToast(
                        msg: "Пожалуйста введите вашу температуру и выберите тип кашля",
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else if (smell == false && noSmell == false) {
                    Fluttertoast.showToast(
                        msg: "Вы ничего не ответили насчет запаха",
                        gravity: ToastGravity.TOP,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  } else {
                    myDataBase
                        .setUserSymptoms(temp, day, cough, smell, gorlo, diary, painHead, speedPain)
                        .then((value) {
                      if (temp == '38.0°C' || temp == '38.5°C') {
                        Fluttertoast.showToast(
                            msg: "Вам необходимо обратиться в больницу",
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TreatmentCentersScreen()));
                      } else if (temp == '39.0°C' || temp == '39.5°C >') {
                        Fluttertoast.showToast(
                            msg:
                                "Ваша температура очень высока, немедленно обратитесь к врачу",
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TreatmentCentersScreen()));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HistoryScreen()));
                      }
                    });
                  }
                }),
          ],
        ),
      ),
    );
  }
}
