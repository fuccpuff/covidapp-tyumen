import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DatabaseService {
  final String userEmail;
  DatabaseService({this.userEmail});
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('dd-MM-yyyy');
  final String formatted = formatter.format(now);
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');
  Future setUserData(
      String email, String firstName, String lastName, var phoneNumber) async {
    return await userCollection.doc(userEmail).collection('details').doc().set({
      "Email": email,
      "First Name": firstName,
      "Last Name": lastName,
      "Phone Number": phoneNumber,
    });
  }

  Future setUserSymptoms(
      String temp, String day, String cough, bool smell, bool gorlo, bool diary, bool painHead, bool speedPain) async {
    return await userCollection
        .doc(userEmail)
        .collection('Symptoms')
        .doc()
        .set({
      "Temperature": temp,
      "Cough Type": cough,
      "Day": day,
      "Smell": smell,
      "Gorlo": gorlo,
      "Diary": diary,
      "PainHead": painHead,
      "speedPain": speedPain,
      "date": now.toString().substring(0, 16)
    });
  }
}
