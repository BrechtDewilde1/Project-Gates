import "package:flutter/material.dart";
import 'package:flutter_application_1/Services/account_information.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_application_1/Services/helper.dart';

class analysisScreen extends StatefulWidget {
  List transactions;

  analysisScreen(this.transactions);

  @override
  _analysisScreenState createState() => _analysisScreenState(transactions);
}

class _analysisScreenState extends State<analysisScreen> {
  List transactions;

  _analysisScreenState(this.transactions);

  // Function to convert the transaction data pulled from the bank account
  // into a format that can be used by the graph generation functions.
  List<ChartData> generateGraphData(transactions) {
    Map monthlyTransactions = {};
    for (int i = 0; i < transactions.length; i++) {
      Map currentTransaction = transactions[i];
      int currentMonth = DateTime.parse(currentTransaction["Datum"]).month;

      if (monthlyTransactions.containsKey(currentMonth)) {
        monthlyTransactions[currentMonth].add(currentTransaction);
      } else {
        monthlyTransactions[currentMonth] = [currentTransaction];
      }
    }

    Map monthlyAnalysis = {};
    for (int i = 1; i < (DateTime.now().month + 1); i++) {
      Map CategoryMap = {
        "Restaurant": 0.0,
        "Activiteit": 0.0,
        "Furniture": 0.0,
        "Groceries": 0.0,
        "Holiday": 0.0,
        "nologo": 0.0
      };

      List currentMonth = monthlyTransactions[i];

      for (int j = 0; j < currentMonth.length; j++) {
        Map currentTransaction = currentMonth[j];
        CategoryMap[currentTransaction["Logo"]] +=
            double.parse(currentTransaction["Bedrag"]);
      }

      monthlyAnalysis[fullMonthName[i]] = [
        ChartData('Restaurant', CategoryMap["Restaurant"], Colors.red),
        ChartData('Activiteit', CategoryMap["Activiteit"], Colors.yellow),
        ChartData('Furniture', CategoryMap["Furniture"], Colors.blue),
        ChartData('Groceries', CategoryMap["Groceries"], Colors.green),
        ChartData('Holiday', CategoryMap["Holiday"], Colors.grey),
        ChartData("Other", CategoryMap["nologo"], Colors.lightBlue)
      ];
    }

    return monthlyAnalysis[fullMonthName[indexOfMonthWatched]] ??
        [
          ChartData('Restaurant', 0.0, Colors.red),
          ChartData('Activiteit', 0.0, Colors.yellow),
          ChartData('Furniture', 0.0, Colors.blue),
          ChartData('Groceries', 0.0, Colors.green),
          ChartData('Holiday', 0.0, Colors.grey),
          ChartData("Other", 0.0, Colors.lightBlue)
        ];
  }

  int monthIncrease(int currentMonth) {
    if (currentMonth == 12) {
      return 1;
    } else {
      return currentMonth + 1;
    }
  }

  int monthDecrease(int currentMonth) {
    if (currentMonth == 1) {
      return 12;
    } else {
      return currentMonth - 1;
    }
  }

  int indexOfMonthWatched = DateTime.now().month;

  @override
  Widget build(BuildContext context) {
    late TooltipBehavior _tooltipBehavior = TooltipBehavior(enable: true);

    return Scaffold(
        body: Center(
            child: SizedBox.expand(
                child: Dismissible(
                    key: UniqueKey(),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        setState(() {
                          indexOfMonthWatched =
                              monthIncrease(indexOfMonthWatched);
                        });
                        print("Right");
                      }

                      if (direction == DismissDirection.startToEnd) {
                        setState(() {
                          indexOfMonthWatched =
                              monthDecrease(indexOfMonthWatched);
                        });
                        print("Left");
                      }
                      return Future.value(false);
                    },
                    child: Container(
                        child: SfCircularChart(
                            title: ChartTitle(
                                text: fullMonthName[indexOfMonthWatched],
                                textStyle: TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.w600)),
                            legend: Legend(
                                isVisible: true,
                                textStyle: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w600),
                                overflowMode: LegendItemOverflowMode.wrap),
                            tooltipBehavior: _tooltipBehavior,
                            series: <CircularSeries>[
                          // Render pie chart
                          DoughnutSeries<ChartData, String>(
                              dataSource: generateGraphData(transactions),
                              pointColorMapper: (ChartData data, _) =>
                                  data.color,
                              xValueMapper: (ChartData data, _) => data.x,
                              yValueMapper: (ChartData data, _) => data.y,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  textStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500)),
                              enableTooltip: true)
                        ]))))));
  }
}

class ChartData {
  ChartData(this.x, this.y, this.color);
  final String x;
  final double y;
  final Color color;
}
