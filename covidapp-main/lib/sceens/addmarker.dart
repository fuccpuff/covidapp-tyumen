import 'package:covidapp/sceens/treatment_centers_screen.dart';
import 'package:covidapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'history_screen.dart';

class AddMarker extends StatefulWidget {
  @override
  _AddMarkerState createState() => _AddMarkerState();
}

class _AddMarkerState extends State<AddMarker> {
  bool mask = false;
  bool noMask = false;
  String status;
  DateTime date = DateTime.now();
  User user = FirebaseAuth.instance.currentUser;
  DatabaseService myDataBase;

  @override
  void initState() {
    super.initState();
    myDataBase = DatabaseService(userEmail: user.email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Добавление локации местонахождения'),
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
                  'Результат положительный',
                  'Результат отрицательный',
                  'Ожидание результатов тестирования',
                  'Был в контакте с подтвержденным случаем',
                  'Был в контакте с потенциальным носителем вируса',
                  'У меня симптомы связанные с вирусом',
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    child: Text(value),
                    value: value,
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    status = value;
                  });
                },
                isExpanded: true,
                value: status,
                hint: Text('Какие у вас результаты??'),
              ),
            ),
            SizedBox(height: 50),
            Row(
              children: [
                Text('Вы были в маске?'),
                Spacer(),
                Column(
                  children: [
                    Text('Да'),
                    Checkbox(
                        value: mask,
                        onChanged: (value) {
                          setState(() {
                            mask = value;
                            noMask = !mask;
                          });
                        }),
                  ],
                ),
                Column(
                  children: [
                    Text('Нет'),
                    Checkbox(
                        value: noMask,
                        onChanged: (value) {
                          setState(() {
                            mask = value;
                            mask = !noMask;
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
    if (status == null || mask == null) {
    Fluttertoast.showToast(
    msg: "Пожалуйста выберите статус и были ли вы в маске",
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0);
    } else if (mask == false && noMask == false) {
    Fluttertoast.showToast(
    msg: "Вы ничего не ответили насчет маски",
    gravity: ToastGravity.TOP,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0);
    };
    },
      ),
    ])));
  }
}