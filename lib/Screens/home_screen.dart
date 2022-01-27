import 'package:flutter/material.dart';
import 'package:flutter_application_1/Screens/key_screen.dart';
import 'package:flutter_application_1/Screens/month_screen.dart';
import 'package:flutter_application_1/Screens/totalSavings_screen.dart';
import 'package:flutter_application_1/Screens/analysis_screen.dart';

class mainWidget extends StatefulWidget {
  Map accountData = {};
  int month_target;
  List transactions;
  Map savingsData;

  mainWidget(
      this.accountData, this.month_target, this.transactions, this.savingsData);

  @override
  _mainWidgetState createState() =>
      _mainWidgetState(accountData, month_target, transactions, savingsData);
}

class _mainWidgetState extends State<mainWidget> {
  int _selectedIndex = 0;
  Map accountData = {};
  int month_target;
  List transactions;
  Map savingsData;
  late List<Widget> _widgetOptions;

  _mainWidgetState(
      this.accountData, this.month_target, this.transactions, this.savingsData);

  @override
  void initState() {
    _widgetOptions = <Widget>[
      monthScreen(accountData, month_target),
      totalSavings_screen(transactions, savingsData),
      analysisScreen(transactions),
      keyScreen()
    ];
    super.initState();
  }

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Greeting function
  String generate_time_based_greeting() {
    DateTime now = DateTime.now();
    if (now.hour < 12) {
      return "Goedemorgen, \nBrecht & Jolien! ☕";
    } else if (now.hour < 17) {
      return "Goedemiddag, \nBrecht & Jolien! ☀";
    } else {
      return "Goedeavond, \nBrecht & Jolien! ⭐";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0.0,
        backgroundColor: Color(0xffFCFBFC),
        title: Text(
          generate_time_based_greeting(),
          style: TextStyle(
              fontFamily: "Vietnam",
              color: Color(0xff414C51),
              fontWeight: FontWeight.bold),
        ),
        actions: [
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(70),
              child: Image.asset("assets/we.jpg"),
            ),
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.credit_card_rounded,
              size: 32.0,
            ),
            label: 'Month',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.savings_outlined, size: 32.0),
            label: 'Savings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart, size: 32.0),
            label: 'Analysis',
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.vpn_key,
                size: 32.0,
              ),
              label: "Keys")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff3E5E8E),
        onTap: _onItemTapped,
      ),
    );
  }
}
