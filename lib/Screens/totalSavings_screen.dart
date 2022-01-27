import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_application_1/Screens/loading_screen.dart';

class _ChartData {
  _ChartData(this.x, this.y);

  final String x;
  final double y;
}

class totalSavings_screen extends StatelessWidget {
  List transactions;
  Map savingsData;

  totalSavings_screen(this.transactions, this.savingsData);

  List<_ChartData> getChartData(monthlySavedMap) {
    List<_ChartData> chartList = [];
    monthlySavedMap.forEach((key, value) {
      chartList.add(_ChartData(key.toString(), value));
    });

    return chartList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(top: 15),
            child: Text(
              "We saved",
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 35,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 25, bottom: 45),
            child: Text(
              savingsData["totalSaved"].toString() + "€",
              style: TextStyle(
                  color: Colors.green[600],
                  fontSize: 55,
                  fontWeight: FontWeight.w900),
            ),
          ),
          SfCartesianChart(
              // Initialize category axis
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(
                  text: "Monthly saved",
                  textStyle:
                      TextStyle(fontSize: 15.0, fontWeight: FontWeight.w900)),
              series: <ChartSeries<_ChartData, String>>[
                ColumnSeries<_ChartData, String>(
                    dataSource: getChartData(savingsData["monthlySaved"]),
                    xValueMapper: (_ChartData data, _) => data.x,
                    yValueMapper: (_ChartData data, _) => data.y,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    name: 'Gold',
                    color: Color.fromRGBO(8, 142, 255, 1))
              ]),
        ],
      ),
    );
  }
}
