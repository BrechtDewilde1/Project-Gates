import "package:flutter/material.dart";
import 'package:flutter/cupertino.dart';

class myDialogBox extends StatefulWidget {
  String description = "";
  String Amount = "";

  myDialogBox(this.description, this.Amount);

  @override
  _dialogState createState() => _dialogState(description, Amount);
}

class _dialogState extends State<myDialogBox> {
  late TextEditingController controller;
  late TextEditingController controllerAmount;
  String description = "";
  String Amount = "";

  String chosenCategory = "";
  String newDescription = "";
  String newAmount = "";

  String determineOutput(inputText, o) {
    if (inputText == "") {
      return o;
    } else {
      return inputText;
    }
  }

  @override
  void initState() {
    super.initState();

    controller = TextEditingController();
    controllerAmount = TextEditingController();
  }

  @override
  void dispose() {
    controller.dispose();
    controllerAmount.dispose();
    super.dispose();
  }

  _dialogState(this.description, this.Amount);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            elevation: 0,
            backgroundColor: Colors.transparent,
            child: contentBox(context)));
  }

  Map iconColors = {
    "Restaurant": Colors.red[100],
    "Activiteit": Colors.yellow[100],
    "Furniture": Colors.blue[100],
    "Groceries": Colors.green[100],
    "Holiday": Colors.grey[100]
  };

  bool iconSelected = false;

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(
              left: 15.0, top: 15.0 + 15.0, right: 15.0, bottom: 15.0),
          margin: EdgeInsets.only(top: 15.0),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                "Choose category",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipOval(
                    child: Material(
                      color: iconColors["Restaurant"], // Button color
                      child: InkWell(
                        splashColor: Color(0xff3D75EF), // Splash color
                        onTap: () {
                          setState(() {
                            chosenCategory = "Restaurant";
                            if (iconSelected) {
                              iconColors = {
                                "Restaurant": Colors.red,
                                "Activiteit": Colors.yellow[100],
                                "Furniture": Colors.blue[100],
                                "Groceries": Colors.green[100],
                                "Holiday": Colors.grey[100]
                              };
                            } else {
                              iconSelected = true;
                              iconColors["Restaurant"] = Colors.red;
                            }
                          });
                        },
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.restaurant)),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: iconColors["Activiteit"], // Button color
                      child: InkWell(
                        splashColor: Color(0xff3D75EF), // Splash color
                        onTap: () {
                          setState(() {
                            chosenCategory = "Activiteit";

                            if (iconSelected) {
                              iconColors = {
                                "Restaurant": Colors.red[100],
                                "Activiteit": Colors.yellow,
                                "Furniture": Colors.blue[100],
                                "Groceries": Colors.green[100],
                                "Holiday": Colors.grey[100]
                              };
                            } else {
                              iconSelected = true;
                              iconColors["Activiteit"] = Colors.yellow;
                            }
                          });
                        },
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.local_activity)),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: iconColors["Furniture"], // Button color
                      child: InkWell(
                        splashColor: Color(0xff3D75EF), // Splash color
                        onTap: () {
                          setState(() {
                            chosenCategory = "Groceries";
                            if (iconSelected) {
                              iconColors = {
                                "Restaurant": Colors.red[100],
                                "Activiteit": Colors.yellow[100],
                                "Furniture": Colors.blue,
                                "Groceries": Colors.green[100],
                                "Holiday": Colors.grey[100]
                              };
                            } else {
                              iconSelected = true;
                              iconColors["Furniture"] = Colors.blue;
                            }
                          });
                        },
                        child: SizedBox(
                            width: 56, height: 56, child: Icon(Icons.weekend)),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: iconColors["Groceries"], // Button color
                      child: InkWell(
                        splashColor: Color(0xff3D75EF), // Splash color
                        onTap: () {
                          setState(() {
                            chosenCategory = "Groceries";
                            if (iconSelected) {
                              iconColors = {
                                "Restaurant": Colors.red[100],
                                "Activiteit": Colors.yellow[100],
                                "Furniture": Colors.blue[100],
                                "Groceries": Colors.green,
                                "Holiday": Colors.grey[100]
                              };
                            } else {
                              iconSelected = true;
                              iconColors["Groceries"] = Colors.green;
                            }
                          });
                        },
                        child: SizedBox(
                            width: 56,
                            height: 56,
                            child: Icon(Icons.local_grocery_store)),
                      ),
                    ),
                  ),
                  ClipOval(
                    child: Material(
                      color: iconColors["Holiday"], // Button color
                      child: InkWell(
                        splashColor: Color(0xff3D75EF), // Splash color
                        onTap: () {
                          setState(() {
                            chosenCategory = "holiday";

                            if (iconSelected) {
                              iconColors = {
                                "Restaurant": Colors.red[100],
                                "Activiteit": Colors.yellow[100],
                                "Furniture": Colors.blue[100],
                                "Groceries": Colors.green[100],
                                "Holiday": Colors.grey
                              };
                            } else {
                              iconSelected = true;
                              iconColors["Holiday"] = Colors.grey;
                            }
                          });
                        },
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: Icon(
                            Icons.local_airport,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Description",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 15,
              ),
              TextField(
                decoration: InputDecoration(hintText: description),
                controller: controller,
              ),
              SizedBox(
                height: 30,
              ),
              Text(
                "Amount",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
              ),
              TextField(
                decoration: InputDecoration(hintText: Amount),
                controller: controllerAmount,
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop([
                        determineOutput(controller.text, description),
                        determineOutput(controllerAmount.text, Amount),
                        chosenCategory
                      ]);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop([
                        determineOutput(controller.text, description),
                        determineOutput(controllerAmount.text, Amount),
                        chosenCategory
                      ]);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Positioned(
          left: 15.0,
          right: 15.0,
          bottom: 400,
          child: CircleAvatar(
            radius: 20,
            backgroundColor: Colors.lightBlue[100],
            child: Icon(CupertinoIcons.question),
          ),
        ),
      ],
    );
  }
}