

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService{
        CollectionReference categories = FirebaseFirestore.instance.collection('categorise');
        CollectionReference mainCart = FirebaseFirestore.instance.collection('mainCategorise');
        CollectionReference subCart = FirebaseFirestore.instance.collection('subCategorise');

        Future<void> saveCategory({CollectionReference? reference, Map<String,dynamic>? data, String? docName}){

          return reference!.doc(docName).set(data);

        }
}