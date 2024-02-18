import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:cnc_admin/widgets/main_categories_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class MainCategoryScreen extends StatefulWidget {
  static const String id = 'main-category';
  const MainCategoryScreen({super.key});

  @override
  State<MainCategoryScreen> createState() => _MainCategoryScreenState();
}

class _MainCategoryScreenState extends State<MainCategoryScreen> {
  final FirebaseService _service = FirebaseService();
  final TextEditingController _mainCart = TextEditingController();
  final _formKey  = GlobalKey<FormState>();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;


  Widget _dropDownButton(){
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['cartName'],
            child: Text(e['cartName']),
          );
        }).toList(),
        onChanged: (selectedCart){
          setState(() {
            _selectedValue = selectedCart;
            _noCategorySelected = false;
          });
        });
  }

  clear(){
    setState(() {
      _selectedValue = null;
      _mainCart.clear();
    });
  }

  @override
  void initState(){
    getCartList();
    super.initState();
  }

  getCartList(){
    return _service.categories
        .get()
        .then((QuerySnapshot querySnapshot) {
      setState(() {
        snapshot = querySnapshot;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30,8,8,8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child:  const Text(
                    'Main Categories',
                    style: TextStyle(
                      fontSize: 30,
                    ),
                  ),
                ),
                const Divider(color: Colors.grey,),
                snapshot==null ? const Text('Loading...') :
                _dropDownButton(),
                  const SizedBox(height: 8,),
                  if(_noCategorySelected == true)
                  const Text('No Category Selected', style: TextStyle(color: Colors.red,),),
                  SizedBox(
                  width: 200,
                  child: TextFormField(
                  validator: (value) {
                  if(value!.isEmpty){
                  return 'Enter Main Category Name';
                  }
                  },
                    controller: _mainCart,
                    decoration: const InputDecoration(
                      label: Text('Enter category name'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  ),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    TextButton(onPressed: (){
                      clear();
                    }, child: Text( 'Cancel', style: TextStyle(color: Theme.of(context).primaryColor,),),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor),),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    ElevatedButton(onPressed: (){
                      if(_selectedValue==null){
                        setState(() {
                          _noCategorySelected = true;
                        });
                        return;
                      }
                      if(_formKey.currentState!.validate()){
                        EasyLoading.show();
                          _service.saveCategory(
                            data: {
                                'category':_selectedValue,
                                'mainCategory': _mainCart.text,
                               'approved': true
                            },
                            reference:  _service.mainCart,
                            docName: _mainCart.text,
                          ).then((value) {
                            clear();
                            EasyLoading.dismiss();
                        });
                      }
                    },
                      child: const Text(
                      'Save',
                    ),
                    ),
                  ],
                  ),
                const Divider(color: Colors.grey,),
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  child:  Text(
                    'Main Category List',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 12,),
                const MainCategoryListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
