

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
        CollectionReference categories = FirebaseFirestore.instance.collection('categorise');

        Future<void> saveCategory(Map<String,dynamic>data){

          return categories.doc(data['cartName']).set(data);

        }
}