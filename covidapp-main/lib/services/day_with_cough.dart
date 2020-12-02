import 'package:flutter/material.dart';

class DayWithCough extends StatelessWidget {
  final String day, cough, temp, taste, gorlo, diary, painHead, speedPain;
  DayWithCough({this.cough, this.day, this.temp, this.taste, this.gorlo, this.diary, this.painHead, this.speedPain});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: Colors.black),
          children: <TextSpan>[
            TextSpan(
                text: '$day\n', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '$cough\n'),
            TextSpan(text: 'Запахи/вкусы $taste\n'),
            TextSpan(text: 'Температура $temp\n'),
            TextSpan(text: 'Горло $gorlo\n'),
            TextSpan(text: 'Диарея $diary\n'),
            TextSpan(text: 'Головная боль $painHead\n'),
            TextSpan(text: 'Утомляемость $speedPain')
          ],
        ),
      ),
    );
  }
}
