import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/Widgets/dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class spendingsCard extends StatefulWidget {
  String naam = "";
  String date = "";
  String bedrag = "";
  String firebaseID = "";
  String icoon = "";

  spendingsCard(this.naam, this.date, this.bedrag, this.icoon, this.firebaseID);

  @override
  _spendingsCardState createState() =>
      _spendingsCardState(naam, date, bedrag, icoon, firebaseID);
}

class _spendingsCardState extends State<spendingsCard> {
  String naam = "";
  String date = "";
  String bedrag = "";
  String firebaseID = "";
  String icoon = "";

  Map iconLayout = {
    "Icoon": Icon(CupertinoIcons.question),
    "Kleur": Colors.lightBlue[100]
  };

  _spendingsCardState(
      this.naam, this.date, this.bedrag, this.icoon, this.firebaseID) {
    iconLayout = setCategoryIcon(icoon);
  }

  Future openDialog(String n, String b, String i) => showDialog(
      barrierDismissible: false,
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return myDialogBox(n, b, i);
      });

  Map setCategoryIcon(String categoryText) {
    if (categoryText == "Restaurant") {
      icoon = "Restaurant";
      return {
        "Icoon": Icon(
          Icons.restaurant,
          color: Colors.black,
        ),
        "Kleur": Colors.red
      };
    } else if (categoryText == "Activiteit") {
      icoon = "Activiteit";
      return {
        "Icoon": Icon(
          Icons.local_activity,
          color: Colors.black,
        ),
        "Kleur": Colors.yellow
      };
    } else if (categoryText == "Furniture") {
      icoon = "Furniture";
      return {
        "Icoon": Icon(
          Icons.weekend,
          color: Colors.black,
        ),
        "Kleur": Colors.blue
      };
    } else if (categoryText == "Groceries") {
      icoon = "Groceries";
      return {
        "Icoon": Icon(
          Icons.local_grocery_store,
          color: Colors.black,
        ),
        "Kleur": Colors.green
      };
    } else if (categoryText == "Holiday") {
      icoon = "Holiday";
      return {
        "Icoon": Icon(
          Icons.local_airport,
          color: Colors.black,
        ),
        "Kleur": Colors.grey
      };
    } else {
      return {
        "Icoon": Icon(CupertinoIcons.question),
        "Kleur": Colors.lightBlue[100]
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: GestureDetector(
        onTap: () async {
          final dialogOutput = await openDialog(naam, bedrag, icoon);
          setState(() {
            naam = dialogOutput[0];
            bedrag = dialogOutput[1];
            iconLayout = setCategoryIcon(dialogOutput[2]);

            FirebaseFirestore.instance
                .collection('Spendings')
                .doc(firebaseID)
                .update({'Bedrag': bedrag, "Logo": icoon, "Naam": naam});
          });
        },
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          color: Colors.white,
          elevation: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20.0),
                child: CircleAvatar(
                  radius: 20,
                  backgroundColor: iconLayout["Kleur"],
                  child: iconLayout["Icoon"],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      naam,
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Text(date),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(right: 20),
                child: Text(
                  bedrag + "€",
                  style: TextStyle(
                      color: Colors.blue[900],
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
