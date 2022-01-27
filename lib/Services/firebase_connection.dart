import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class firebase_connection {
  // Create instance and connect with the users collection
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference Spendings =
      FirebaseFirestore.instance.collection("Spendings");

  // Method to add a spending row to the database
  Future<void> addSpending(bedrag, Datum, Logo, Naam) {
    return Spendings.add(
        {"Bedrag": bedrag, "Datum": Datum, "Logo": Logo, "Naam": Naam});
  }
}
