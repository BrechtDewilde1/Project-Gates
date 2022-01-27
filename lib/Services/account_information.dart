import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_application_1/Services/firebase_connection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "dart:collection";
import 'dart:math';

String processTransactionMessage(Map transactionMap) {
  if (transactionMap.keys.contains("remittanceInformationUnstructuredArray")) {
    return transactionMap["remittanceInformationUnstructuredArray"][0];
  } else if (transactionMap["additionalInformation"].split(",").length > 6) {
    String uncleanedOutput =
        transactionMap["additionalInformation"].split(",")[6];
    return uncleanedOutput.substring(2, uncleanedOutput.length - 1);
  } else {
    return "";
  }
}

class AccountInformation {
  String refreshToken = "";
  String linkID = "";

  String refreshBackup =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ0b2tlbl90eXBlIjoicmVmcmVzaCIsImV4cCI6MTY0NTg3MTc2NiwianRpIjoiMjUwYjczY2I0NjQ4NGIxODgxZGY3M2UxOTM0ZDIwM2UiLCJpZCI6NjY2Niwic2VjcmV0X2lkIjoiNmNkMDFiOGItNTA5Ny00NjNiLWIzMDMtZjI1Zjg5ZDc5Zjk4IiwiYWxsb3dlZF9jaWRycyI6WyIwLjAuMC4wLzAiXX0.v-6-WfJIyPB-jzzerp7YaUbL8GdyQGdgrORG5WVNoOw";
  String linkIDBackup = "41d57076-3ef3-44c7-89b2-461d5de24f6a";
  // Get Keys from Memory
  Future<Map> getKeys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? rt = prefs.getString("refreshToken");
    String? id = prefs.getString("linkID");

    if ((rt ?? true) as bool) {
      rt = refreshBackup;
      id = linkIDBackup;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(refreshToken, rt);
      await prefs.setString("linkID", id);
    }

    return {"refreshToken": rt, "id": id};
  }

  // Reference to fireStore
  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('Spendings');

  // Random hour, minute, second function
  String random_hour() {
    var rng = Random();
    return (rng.nextInt(12) + 12).toString() +
        ":" +
        (rng.nextInt(50) + 10).toString() +
        ":" +
        (rng.nextInt(50) + 10).toString();
  }

  // Method to get data from firebase
  Future<Map> getFireBaseData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    List documents = querySnapshot.docs;
    List allData = [];
    List allKeys = [];

    // Order the firebase rows
    final allRowsUnordered = SplayTreeMap<DateTime, Map>();
    for (int i = 0; i < documents.length; i++) {
      allRowsUnordered[DateTime.parse(
          documents[i].data()["Datum"] + " " + random_hour())] = {
        "Data": documents[i].data(),
        "Key": documents[i].id
      };
    }

    final sortedMap = SplayTreeMap<DateTime, Map>.from(allRowsUnordered);

    // Get data of all firebase rows
    void populateList(d, k) {
      allData.add(d);
      allKeys.add(k);
    }

    sortedMap.forEach((key, value) {
      populateList(value["Data"], value["Key"]);
    });

    return {
      "keys": List.from(allKeys.reversed),
      "data": List.from(allData.reversed)
    };
  }

  void populateFirestoreDataBase(parsedData) {
    for (int i = 0; i < parsedData.length; i++) {
      Map ft = parsedData[i];
      firebase_connection().addSpending(
          ft["amount"].toString(), ft["datum"], "nologo", ft["message"]);
    }
  }

  // Overal method to get data
  Future<Map> getAccountData() async {
    // Get keys from memory
    Map keys = await getKeys();
    refreshToken = keys["refreshToken"];
    linkID = keys["id"];

    // 1. checkt of er alreeds een refresh token in memory zit, maakt één indien dit niet het geval is
    // 2. Gebruik de refresh token om nieuwe access token te genereren
    // 3. Gebruik deze access token om transactie data te verkrijgen
    return useRefreshToken(refreshToken).then((newAccessToken) {
      return list_accountst(newAccessToken, linkID).then((accountNumber) {
        return getAccountInformation(accountNumber, newAccessToken)
            .then((transactionData) async {
          Map fireBaseData = await getFireBaseData();
          List parsedData = [];

          if (fireBaseData["data"].length > 0) {
            parsedData = await parseTransactionData(transactionData, false);
            populateFirestoreDataBase(parsedData);
          } else {
            parsedData = await parseTransactionData(transactionData, true);
            populateFirestoreDataBase(parsedData);
          }

          Map allFireBaseData = await getFireBaseData();

          return {
            "transacties_deze_maand": allFireBaseData,
            "totaal_deze_maand":
                calculateSpendedThisMonth(allFireBaseData["data"])
          };
        });
      });
    });
  }

// FIRST TIME - and every 90 days
// STEP 1 - Get access token
  Future<Map<String, String>> getAccessKey() async {
    http.Response response = await http.post(
        Uri.parse("https://ob.nordigen.com/api/v2/token/new/"),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, String>{
          'secret_id': "6cd01b8b-5097-463b-b303-f25f89d79f98",
          'secret_key':
              '8e8e18c8b1cff9f84bd396a4af665433049029e6728344695c467772f22444457e01eba1a2a31efe3670145e58d33724b539989fd015e9a34847af94c8ae6726'
        }));

    Map returnedValue = jsonDecode(response.body);

    // Creation of map return
    return {
      "access_token": returnedValue["access"],
      "refresh_token": returnedValue["refresh"]
    };
  }

// STEP 2 - Get end user agreement
  Future<String> createEndUserAgreement(access_token) async {
    http.Response response = await http.post(
      Uri.parse("https://ob.nordigen.com/api/v2/agreements/enduser/"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + access_token
      },
      body: jsonEncode(<String, String>{
        "institution_id": "BNP_BE_GEBABEBB",
        "max_historical_days": "360",
        "access_valid_for_days": "90"
      }),
    );

    Map returnedValue = jsonDecode(response.body);

    return returnedValue["id"];
  }

// STEP 3 - Build a link
  Future<Map<String, String>> buildLink(access_token, endUserID) async {
    http.Response response = await http.post(
      Uri.parse("https://ob.nordigen.com/api/v2/requisitions/"),
      headers: {
        "accept": "application/json",
        "Content-Type": "application/json",
        "Authorization": "Bearer " + access_token
      },
      body: jsonEncode(<String, String>{
        "institution_id": "BNP_BE_GEBABEBB",
        "redirect": "http://www.google.com",
        "agreement": endUserID
      }),
    );

    Map returnedValue = jsonDecode(response.body);
    return {"link": returnedValue["link"], "id": returnedValue["id"]};
  }

// Always
// STEP 1 - Use refresh token for new access token
  Future<String> useRefreshToken(refresh_token) async {
    http.Response response = await http.post(
        Uri.parse("https://ob.nordigen.com/api/v2/token/refresh/"),
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
        body: jsonEncode(<String, String>{"refresh": refresh_token}));

    Map returnedValue = jsonDecode(response.body);
    return returnedValue["access"];
  }

// STEP 2 - List accounts
  Future<String> list_accountst(acces_token, id) async {
    String link = "https://ob.nordigen.com/api/v2/requisitions/" + id + "/";

    http.Response response = await http.get(
      Uri.parse(link),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer " + acces_token
      },
    );

    Map returnedValue = jsonDecode(response.body);
    return returnedValue["accounts"][0];
  }

// STEP 3 - Get account information
  Future<Map> getAccountInformation(accountNumber, accessToken) async {
    String link = "https://ob.nordigen.com/api/v2/accounts/" +
        accountNumber +
        "/transactions/";

    http.Response response = await http.get(
      Uri.parse(link),
      headers: {
        "accept": "application/json",
        "Authorization": "Bearer " + accessToken
      },
    );

    Map returnedValue = jsonDecode(response.body);
    return returnedValue;
  }

  Future<String?> getLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? dateLastLaunch = prefs.getString("dateLastLaunch") ?? "";
    return dateLastLaunch;
  }

  Future<void> setLastDate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("dateLastLaunch", DateTime.now().toString());
  }

  // STEP 5 - Get transaction data
  Future<List> parseTransactionData(transactionData, all) async {
    List transactions = transactionData["transactions"]["booked"];
    List parsedTransactions = [];

    // Get date of last transaction pull
    await getLastDate().then((lastPullDate) {
      // If FireStore is empty, pull all data
      if (all) {
        for (int i = 0; i < transactions.length; i++) {
          Map currentTransaction = transactions[i];
          if (double.parse(currentTransaction["transactionAmount"]["amount"]) <
              0) {
            parsedTransactions.add({
              "message": processTransactionMessage(currentTransaction),
              "datum": currentTransaction["valueDate"],
              "amount": double.parse(
                      currentTransaction["transactionAmount"]["amount"])
                  .abs()
                  .toString()
            });
          }
        }
      } else if (lastPullDate == "") {
        // If we don't have a last pull date, pull all data
        for (int i = 0; i < transactions.length; i++) {
          Map currentTransaction = transactions[i];
          if (double.parse(currentTransaction["transactionAmount"]["amount"]) <
              0) {
            parsedTransactions.add({
              "message": processTransactionMessage(currentTransaction),
              "datum": currentTransaction["valueDate"],
              "amount": double.parse(
                      currentTransaction["transactionAmount"]["amount"])
                  .abs()
                  .toString()
            });
          }
        }
      } else {
        // If we do have a date, only pull data that is generated after the date
        for (int i = 0; i < transactions.length; i++) {
          Map currentTransaction = transactions[i];
          if (double.parse(currentTransaction["transactionAmount"]["amount"]) <
              0) {
            if (DateTime.parse(currentTransaction["bookingDate"])
                .isAfter(DateTime.parse(lastPullDate!))) {
              parsedTransactions.add({
                "message": processTransactionMessage(currentTransaction),
                "datum": currentTransaction["valueDate"],
                "amount": double.parse(
                        currentTransaction["transactionAmount"]["amount"])
                    .abs()
                    .toString()
              });
            }
          }
        }
      }
    });

    // Set last date to now to prevent that next pull is again everything
    setLastDate();

    return parsedTransactions;
  }

  double calculateSpendedThisMonth(transactionDataList) {
    double spendedThisMonth = 0.0;

    for (int i = 0; i < transactionDataList.length; i++) {
      if (DateTime.parse(transactionDataList[i]["Datum"]).month ==
          DateTime.now().month) {
        spendedThisMonth += double.parse(transactionDataList[i]["Bedrag"]);
      }
    }

    return double.parse(spendedThisMonth.abs().toStringAsFixed(2));
  }
}
