import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_service.dart';

class SubCategoryListWidget extends StatefulWidget {
  final String selectedMainCategory;

  SubCategoryListWidget({required this.selectedMainCategory});

  @override
  State<SubCategoryListWidget> createState() => _SubCategoryListWidgetState();
}

class _SubCategoryListWidgetState extends State<SubCategoryListWidget> {
  final FirebaseService _service = FirebaseService();
  QuerySnapshot? snapshot;

  Widget subCategoryWidget(data) {
    return Card(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Center(
                child: Text(
                  data['subCartName'], // Assuming 'subCartName' is the correct field
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    getSubCategoriesList();
    super.initState();
  }

  getSubCategoriesList() {
    return _service.subCart
        .where('mainCategory', isEqualTo: widget.selectedMainCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        snapshot == null
            ? const Text('Loading..')
            : GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 3,
            mainAxisSpacing: 3,
            childAspectRatio: 6 / 2,
          ),
          itemCount: snapshot!.size,
          itemBuilder: (context, index) {
            var data = snapshot!.docs[index];
            return subCategoryWidget(data);
          },
        ),
      ],
    );
  }
}
