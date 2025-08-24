import 'package:cloud_firestore/cloud_firestore.dart';


class FP {
// Root: finance/main (single-user, no auth)
static DocumentReference<Map<String, dynamic>> root() => FirebaseFirestore.instance.collection('finance').doc('main');


static CollectionReference<Map<String, dynamic>> expenses() => root().collection('expenses');
static CollectionReference<Map<String, dynamic>> income() => root().collection('income');
static CollectionReference<Map<String, dynamic>> goals() => root().collection('goals');
static DocumentReference<Map<String, dynamic>> budgetDoc() => root().collection('meta').doc('budget');
}