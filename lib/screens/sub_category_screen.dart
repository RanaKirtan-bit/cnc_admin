import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:cnc_admin/widgets/main_categories_list_widget.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../widgets/category_list_widget.dart';
import '../widgets/sub_categories_list_widget.dart';


class SubCategoryScreen extends StatefulWidget {
  static const String id = 'sub-category';
  const SubCategoryScreen({super.key});

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {

  File? _image;
  final picker = ImagePicker();         //NEW
  final TextEditingController _subCartName = TextEditingController();
  final FirebaseService _service = FirebaseService();
  dynamic image = null;
  String? fileName;
  final _formKey  = GlobalKey<FormState>();
  Object? _selectedValue;
  bool _noCategorySelected = false;
  QuerySnapshot? snapshot;


  Widget _dropDownButton(){
    return DropdownButton(
        value: _selectedValue,
        hint: const Text('Select Main Category'),
        items: snapshot!.docs.map((e) {
          return DropdownMenuItem<String>(
            value: e['mainCategory'],
            child: Text(e['mainCategory']),
          );
        }).toList(),
        onChanged: (selectedCart){
          setState(() {
            _selectedValue = selectedCart;
            _noCategorySelected = false;
          });
        });
  }


  firebase_storage.FirebaseStorage storage = firebase_storage.FirebaseStorage.instance;     //NEW
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');      //NEW

  /*
   pickImage() async{
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,allowMultiple: false,
    );
    if(result!=null){
      setState(() {
        image = result.files.first.bytes;
        fileName = result.files.first.name;
      });
    }else{
      print("cancelled or Failed");
    }
  }
*/


  Future _pickImage() async {
    final pickedFile =
    await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        image = _image!.readAsBytesSync();
        fileName = pickedFile.name; // Update this line with the actual file name
      } else {
        print('no image picked');
      }
    });
  }


  saveImageToDb() async{
    var ref = firebase_storage.FirebaseStorage.instance
        .ref('subCategoryImage/$fileName');
    EasyLoading.show();
    try{
      await ref.putData(image);
      String downloadURL = await ref
          .getDownloadURL().then((value) {
        if(value.isNotEmpty) {
          _service.saveCategory(
              data: {
                'subCartName': _subCartName.text,
                'mainCategory': _selectedValue,
                'image': value,
                'active': true,
              },
              docName: _subCartName.text,
              reference: _service.subCart
          ).then((value) {
            clear();
            EasyLoading.dismiss();
          });
        }
        return value;
      });
    } on FirebaseException catch(e){
      clear();
      EasyLoading.dismiss();
      print('Firebase error: $e');
    } catch (e) {
      clear();
      EasyLoading.dismiss();
      print('Unknown Error: $e');
    }
  }

  clear(){
    setState(() {
      _subCartName.clear();
      image = null;       //NEW

    });
  }



  @override
  void initState(){
    getMainCartList();
    super.initState();
  }

  getMainCartList(){
    return _service.mainCart
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
          child: Column(
            children: [
              Container(
                child:  Text(
                  'Sub Category Screen',
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ),
              Divider(color: Colors.orange,),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      children: [
                        Container(
                          height: 150,
                          width:  150,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.grey.shade500),

                          ),
                          child: image!= null  ? Image.memory(image, fit: BoxFit.cover,) : Center(
                            child:Text(
                              'Sub Category image',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(onPressed: (){
                          _pickImage();
                        }, child: Text(
                          'Upload Image',
                        ),),
                      ],
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        snapshot==null ? const Text('Loading...') :
                        _dropDownButton(),
                        const SizedBox(height: 8,),
                        if(_noCategorySelected == true)
                          const Text('No Main Category Selected', style: TextStyle(color: Colors.red,),),
                        SizedBox(
                          width: 200,
                          child: TextFormField(
                            validator: (value) {
                              if(value!.isEmpty){
                                return 'Enter Sub Category Name';
                              }
                            },
                            controller: _subCartName,
                            decoration: const InputDecoration(
                              label: Text('Enter Sub category name'),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20,),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
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
                              if(image!=null)
                                ElevatedButton(onPressed: (){
                                  if(_selectedValue==null){
                                    setState(() {
                                      _noCategorySelected = true;
                                    });
                                    return;
                                  }
                                  if(_formKey.currentState!.validate()){
                                    saveImageToDb();
                                  }
                                },
                                  child: const Text(
                                    'Save',
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(color: Colors.orange,),
              const SizedBox(height: 10,),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child:  const Text(
                  'Sub Category List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SubCategoryListWidget(
                reference: _service.subCart,
              ),
            ],
          ),
        ),
      ),
    );
  }
}