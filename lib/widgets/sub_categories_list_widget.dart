import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_service.dart';

class SubCategoryListWidget extends StatefulWidget {
  //final String selectedMainCategory;
  final CollectionReference? reference;

  const SubCategoryListWidget({this.reference,Key? key});

  @override
  State<SubCategoryListWidget> createState() => _SubCategoryListWidgetState();
}

class _SubCategoryListWidgetState extends State<SubCategoryListWidget> {
  final FirebaseService _service = FirebaseService();
  Object? _selectedValue;
  QuerySnapshot? snapshot;

  Widget subCategoryWidget(data) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                data['image'],
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  widget.reference == _service.categories
                      ? data['cartName']
                      : data['subCartName'],
                  style: const TextStyle(
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
  Widget _dropDownButton() {
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select Main Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
        }).toList(),
        onChanged: (selectedCart) {
          setState(() {
            _selectedValue = selectedCart;
          });
        });
  }
  @override
  void initState() {
    getSubCategoriesList();
    super.initState();
  }

  getSubCategoriesList() {
    return _service.subCart
    // .where('mainCategory', isEqualTo: widget.selectedMainCategory)
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.reference == _service.subCart && snapshot != null)
            Row(
              children: [
                _dropDownButton(),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedValue = null;
                      });
                    },
                    child: const Text('Show All')),
              ],
            ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _selectedValue == null
                ? _service.subCart.snapshots()
                : _service.subCart
                .where('mainCategory', isEqualTo: _selectedValue)
                .snapshots(),
            // stream: widget.reference!.where('mainCategory',isEqualTo:_selectedValue ).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.data!.size == 0) {
                return const Text('No Categories added');
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
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return subCategoryWidget(data);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../firebase_service.dart';

class CategoryListWidget extends StatefulWidget {
  final CollectionReference? reference;
  const CategoryListWidget({this.reference, Key? key}) : super(key: key);

  @override
  State<CategoryListWidget> createState() => _CategoryListWidgetState();
}

class _CategoryListWidgetState extends State<CategoryListWidget> {
  FirebaseService _service = FirebaseService();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;
  /*Object? _selectedValue;
  QuerySnapshot? snapshot;*/

  Widget categoryWidget(data) {
    return SingleChildScrollView(
      child: Card(
        color: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.network(
                data['image'],
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  widget.reference == _service.categories
                      ? data['cartName']
                      : data['subCartName'],
                  style: const TextStyle(
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

  Widget _dropDownButton() {
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select Main Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
        }).toList(),
        onChanged: (selectedCart) {
          setState(() {
            _selectedValue = selectedCart;
          });
        });
  }

  @override
  void initState() {
    getMainCartList();
    super.initState();
  }

  getMainCartList() {
    return _service.mainCart.get().then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          if (widget.reference == _service.subCart && snapshot != null)
            Row(
              children: [
                _dropDownButton(),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _selectedValue = null;
                      });
                    },
                    child: const Text('Show All')),
              ],
            ),
          const SizedBox(
            height: 10,
          ),
          StreamBuilder<QuerySnapshot>(
            stream: _selectedValue == null
                ? _service.subCart.snapshots()
                : _service.subCart
                .where('category', isEqualTo: _selectedValue)
                .snapshots(),
            // stream: widget.reference!.where('mainCategory',isEqualTo:_selectedValue ).snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.data!.size == 0) {
                return const Text('No Categories added');
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
                itemBuilder: (context, index) {
                  var data = snapshot.data!.docs[index];
                  return categoryWidget(data);
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
*/