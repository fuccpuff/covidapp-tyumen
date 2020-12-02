import 'package:flutter/material.dart';

class DetailCard extends StatelessWidget {
  const DetailCard(
      {this.imageLocation,
      this.size,
      this.subject,
      this.totalCases,
      this.newCases});
  final String imageLocation, subject;
  final Size size;
  final int totalCases, newCases;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width * 0.45,
      height: size.height * 0.35,
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: Offset(0.0, 1.0), //(x,y)
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
            imageLocation,
            height: size.height * 0.15,
          ),
          RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              children: <TextSpan>[
                TextSpan(text: 'Всего $subject: '),
                TextSpan(text: '$totalCases\n', style: TextStyle(fontSize: 15)),
                newCases != null
                    ? TextSpan(
                        text: 'Новых $subject:',
                      )
                    : TextSpan(),
                newCases != null
                    ? TextSpan(
                        text: '$newCases',
                        style: TextStyle(fontSize: 15),
                      )
                    : TextSpan()
              ],
            ),
          )
        ],
      ),
    );
  }
}
