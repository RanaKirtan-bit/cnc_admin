import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../firebase_service.dart';

class CategoryListWidget extends StatelessWidget {
  const CategoryListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget categoryWidget(data){
      return SingleChildScrollView(
        child: Card(
          color: Colors.grey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Image.network(data['image'], fit: BoxFit.cover,),
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Text(
                      data ['cartName'],
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _service.categories.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        if(snapshot.data!.size==0){
          return Text('No Categories added');
        }
        return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,

            ),
            itemCount: snapshot.data!.size,
            itemBuilder: (context,index){
                 var data = snapshot.data!.docs[index];
                 return categoryWidget(data);
            },
        );
      },
    );
  }
}
