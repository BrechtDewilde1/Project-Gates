import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class keyScreen extends StatefulWidget {
  const keyScreen({Key? key}) : super(key: key);

  @override
  _keyScreenState createState() => _keyScreenState();
}

class _keyScreenState extends State<keyScreen> {
  // Controllers to store inputted text
  late TextEditingController refreshController;
  late TextEditingController idController;

  // Get Keys from Memory
  Future<Map> getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rt = prefs.getString("refreshToken");
    String? id = prefs.getString("linkID");

    return {"refreshToken": rt, "id": id};
  }

  // Pull keys that are stored in memory
  @override
  void initState() {
    refreshController = TextEditingController();
    idController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    refreshController.dispose();
    idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getKeys(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            Map keys = snapshot.data as Map;
            return Scaffold(
                body: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Refresh Token",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            )),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: refreshController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: keys["refreshToken"],
                              hintText: 'Refresh Token',
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              "Link ID",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w800),
                            )),
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: TextField(
                            controller: idController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: keys["id"],
                              hintText: 'Link ID',
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              child: Text('Update keys'),
                              onPressed: () {
                                setState(() async {
                                  keys["refreshToken"] = refreshController.text;
                                  keys["id"] = idController.text;

                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  await prefs.setString(
                                      "refreshToken", keys["refreshToken"]);
                                  await prefs.setString("linkID", keys["id"]);
                                });
                              },
                            )
                          ],
                        )
                      ],
                    )));
          }
        });
  }
}
