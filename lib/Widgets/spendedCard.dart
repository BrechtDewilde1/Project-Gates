import 'dart:async';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class spendedCard extends StatelessWidget {
  double spendedThisMonth = 0;
  int rollingAverage = 0;
  String roundedPercentage = "";
  double percentage = 0.0;

  spendedCard(this.spendedThisMonth, this.rollingAverage) {
    spendedThisMonth = spendedThisMonth;
    rollingAverage = rollingAverage;
    percentage = (spendedThisMonth / rollingAverage);
    roundedPercentage = (percentage * 100).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      elevation: 15.0,
      margin: EdgeInsets.all(15),
      color: Color(0xff3D75EF),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Spended this month",
                  style: TextStyle(color: Color(0xffCEE3FF)),
                ),
                Container(
                  width: 75,
                  height: 25,
                  decoration: BoxDecoration(
                    color: Color(0xff3664CC),
                    border: Border.all(color: Color(0xff3664CC)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      DateFormat.MMMM().format(DateTime.now()),
                      style: TextStyle(
                          color: Color(0xffCEE3FF),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Text(
                    "€" + "$spendedThisMonth",
                    style: TextStyle(
                        color: Color(0xffCEE3FF),
                        fontWeight: FontWeight.bold,
                        fontSize: 40),
                  ),
                  Text(
                    "/" + "$rollingAverage",
                    style: TextStyle(color: Color(0xff9AB9FF), fontSize: 30),
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 15.0),
              child: LinearPercentIndicator(
                animation: true,
                lineHeight: 20.0,
                animationDuration: 1500,
                percent: percentage,
                center: Text(
                  "$roundedPercentage" + "%",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                linearStrokeCap: LinearStrokeCap.roundAll,
                progressColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
