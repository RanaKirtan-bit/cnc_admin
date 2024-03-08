import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../firebase_service.dart';

class SubCategoryListWidget extends StatefulWidget {
  final CollectionReference? reference;

  const SubCategoryListWidget({this.reference, Key? key});

  @override
  State<SubCategoryListWidget> createState() => _SubCategoryListWidgetState();
}

class _SubCategoryListWidgetState extends State<SubCategoryListWidget> {
  final FirebaseService _service = FirebaseService();
  String? _selectedMainCategory;
  String? _selectedSubCategory;
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
    List<String> mainCategories = snapshot!.docs
        .map<String>((e) => e['mainCategory'].toString())
        .toSet()
        .toList();

    return DropdownButton(
      value: _selectedMainCategory,
      hint: const Text('Select Main Category'),
      items: mainCategories
          .map(
            (mainCategory) => DropdownMenuItem<String>(
          value: mainCategory,
          child: Text(mainCategory),
        ),
      )
          .toList(),
      onChanged: (selectedMainCategory) {
        setState(() {
          _selectedMainCategory = selectedMainCategory;
          _selectedSubCategory = null; // Reset selected sub-category
        });
      },
    );
  }

  @override
  void initState() {
    getSubCategoriesList();
    super.initState();
  }

  getSubCategoriesList() {
    return _service.subCart.get().then((QuerySnapshot querySnapshot) {
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
                      _selectedMainCategory = null;
                      _selectedSubCategory = null;
                    });
                  },
                  child: const Text('Show All'),
                ),
              ],
            ),
          const SizedBox(
            height: 10,
          ),
          if (_selectedMainCategory != null)
            Column(
              children: [
                const SizedBox(height: 10),
                Wrap(
                  children: snapshot!.docs
                      .where((e) =>
                  e['mainCategory'] == _selectedMainCategory)
                      .map((e) {
                    String subCategoryName = e['subCartName'];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSubCategory = subCategoryName;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: _selectedSubCategory == subCategoryName
                                ? Colors.blue
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            subCategoryName,
                            style: TextStyle(
                              color: _selectedSubCategory == subCategoryName
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
              ],
            ),
          StreamBuilder<QuerySnapshot>(
            stream: _selectedMainCategory == null
                ? _service.subCart.snapshots()
                : _service.subCart
                .where('mainCategory', isEqualTo: _selectedMainCategory)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return const Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const LinearProgressIndicator();
              }

              if (snapshot.data!.size == 0) {
                return const Text('No Categories added');
              }

              List<DocumentSnapshot> filteredData = snapshot.data!.docs;

              if (_selectedSubCategory != null) {
                // Filter data based on selected subCartName
                filteredData = filteredData
                    .where((e) => e['subCartName'] == _selectedSubCategory)
                    .toList();
              }

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 3,
                  mainAxisSpacing: 3,
                ),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  var data = filteredData[index];
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
