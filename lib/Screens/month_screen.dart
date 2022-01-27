import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/spendedCard.dart';
import 'package:flutter_application_1/Widgets/spendingsCard.dart';

class monthScreen extends StatelessWidget {
  Map accountData = {};
  int month_target;

  monthScreen(this.accountData, this.month_target);

  List<Widget> generate_spendings_list(List dataList, List keyList) {
    List<Widget> outputList = [];

    for (int i = 0; i < dataList.length; i++) {
      outputList.add(spendingsCard(dataList[i]["Naam"], dataList[i]["Datum"],
          dataList[i]["Bedrag"], dataList[i]["Logo"], keyList[i]));
    }

    return outputList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Column(
          children: [
            spendedCard(accountData["totaal_deze_maand"], month_target),
            Container(
              padding: EdgeInsets.only(left: 17, top: 20),
              alignment: Alignment.centerLeft,
              child: Text(
                "Spendings",
                style: TextStyle(
                    color: Colors.black87,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Oswald"),
              ),
            ),
            Expanded(
              child: GridView.count(
                  crossAxisCount: 1,
                  crossAxisSpacing: 25,
                  mainAxisSpacing: 25,
                  childAspectRatio: 5,
                  padding: EdgeInsets.only(top: 15),
                  children: generate_spendings_list(
                    accountData["transacties_deze_maand"]["data"],
                    accountData["transacties_deze_maand"]["keys"],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
