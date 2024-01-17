import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
//import 'package:path/path.dart';

import '../firebase_service.dart';

class MainCategoryListWidget extends StatefulWidget {
  const MainCategoryListWidget({super.key});

  @override
  State<MainCategoryListWidget> createState() => _MainCategoryListWidgetState();
}
class _MainCategoryListWidgetState extends State<MainCategoryListWidget> {
  final FirebaseService _service = FirebaseService();
  String? _selectedValue;
  QuerySnapshot? snapshot;

  Widget categoryWidget(data) {
    return Card(
      color: Colors.grey,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Center(
                child: Text(
                  data['mainCategory'], // Assuming 'cartName' is the correct field
                  style: const TextStyle(
                    color: Colors.black,
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

  Widget _dropDownButton() {
    return DropdownButton<String>(
      value: _selectedValue,
      hint: const Text('Select Category'),
      items: snapshot!.docs.map((e) {
        return DropdownMenuItem<String>(
          value: e['cartName'],
          child: Text(e['cartName']),
        );
      }).toList(),
      onChanged: (selectedCart) {
        setState(() {
          _selectedValue = selectedCart;
        });
      },
    );
  }

  @override
  void initState() {
    getCartList();
    super.initState();
  }

  getCartList() {
    return _service.categories.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        snapshot == null ? const Text('Loading..') :
        Row(
          children: [
            _dropDownButton(),
            const SizedBox(width: 10,),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedValue = null;
                });
              },
              child: const Text('Show All'),
            ),
          ],
        ),
        const SizedBox(height: 10,),
        StreamBuilder<QuerySnapshot>(
          stream: _selectedValue == null
              ? _service.mainCart.snapshots()
              : _service.mainCart.where('category', isEqualTo: _selectedValue).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }

            if (snapshot.data!.size == 0) {
              return const Text('No Main Categories added');
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 3,
                mainAxisSpacing: 3,
                childAspectRatio: 6/2,
              ),
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                var data = snapshot.data!.docs[index];
                return categoryWidget(data);
              },
            );
          },
        ),
      ],
    );
  }
}

