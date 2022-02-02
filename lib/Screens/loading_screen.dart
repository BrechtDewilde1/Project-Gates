import 'package:flutter/material.dart';
import 'package:flutter_application_1/Services/account_information.dart';
import 'package:flutter_application_1/Services/monthly_target.dart';
import 'package:flutter_application_1/Screens/home_screen.dart';
import 'package:loading_animations/loading_animations.dart';

class loadingScreen extends StatefulWidget {
  @override
  _loadingScreenState createState() => _loadingScreenState();
}

class _loadingScreenState extends State<loadingScreen> {
  // Calculate total savings and monthly savings
  // Saving of a particular month is: 2950 - total month expense
  Map totalAndMonthlySavings(transactions) {
    Map monthlySpended = {};
    Map monthlySaved = {};

    for (int i = 0; i < transactions.length; i++) {
      Map currentTransaction = transactions[i];
      int currentMonth = DateTime.parse(currentTransaction["Datum"]).month;

      if (monthlySpended.containsKey(currentMonth)) {
        monthlySpended[currentMonth] +=
            double.parse(currentTransaction["Bedrag"]);
      } else {
        monthlySpended[currentMonth] =
            double.parse(currentTransaction["Bedrag"]);
      }
    }

    monthlySpended.forEach((key, value) {
      monthlySaved[key] = 2950 - value;
    });

    Map monthlySavedReturn = {};
    Map fullMonthName = {};
    fullMonthName[1] = "January";
    fullMonthName[2] = "February";
    fullMonthName[3] = "March";
    fullMonthName[4] = "April";
    fullMonthName[5] = "May";
    fullMonthName[6] = "June";
    fullMonthName[7] = "July";
    fullMonthName[8] = "August";
    fullMonthName[9] = "September";
    fullMonthName[10] = "October";
    fullMonthName[11] = "November";
    fullMonthName[12] = "December";

    double totalSaved = 0.0;
    monthlySaved.forEach((key, value) {
      if (key < DateTime.now().month && key > 1) {
        monthlySavedReturn[fullMonthName[key]] = value;
        totalSaved += value;
      }
    });

    return {"monthlySaved": monthlySavedReturn, "totalSaved": totalSaved};
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future.wait([
          AccountInformation().getAccountData(),
          monthly_target_computer().calculate_monthly_target_fut()
        ]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Scaffold(
              body: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 15.0),
                    child: Text(
                      "Welcome to project Gates 👋!",
                      style: TextStyle(fontSize: 25),
                    ),
                  ),
                  LoadingDoubleFlipping.square(
                    backgroundColor: Colors.white,
                    borderColor: Colors.cyan,
                    size: 50.0,
                  ),
                ],
              ),
            );
          } else {
            List snapList = snapshot.data as List;
            Map accountData = snapList[0] as Map;
            int month_target = snapList[1] as int;
            List transactions = accountData["transacties_deze_maand"]["data"];
            Map savingsData = totalAndMonthlySavings(transactions);

            return mainWidget(
                accountData, month_target, transactions, savingsData);
          }
        });
  }
}
