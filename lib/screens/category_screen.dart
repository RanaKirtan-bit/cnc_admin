
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../widgets/category_list_widget.dart';

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  File? _image;
  final picker = ImagePicker();         //NEW
  final TextEditingController _cartName = TextEditingController();
  final FirebaseService _service = FirebaseService();
 dynamic image = null;
String? fileName;
final _formKey  = GlobalKey<FormState>();

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
          .ref('categoryImage/$fileName');
        EasyLoading.show();
        try{
              await ref.putData(image);
              String downloadURL = await ref
              .getDownloadURL().then((value) {
                      if(value.isNotEmpty) {
                        _service.saveCategory(
                            data: {
                          'cartName': _cartName.text,
                          'image': value,
                          'active': true,
                        },
                          docName: _cartName.text,
                          reference: _service.categories
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
          _cartName.clear();
          image = null;       //NEW

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
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child:  const Text(
                    'Categories',
                        style: TextStyle(
                              fontSize: 26,
                          fontWeight: FontWeight.w700,
                ),
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
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
                          child: image!= null  ? Image.memory(image, fit: BoxFit.cover,) : const Center(
                             child:Text(
                              'Category image',
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(onPressed: (){
                            _pickImage();
                        }, child: const Text(
                          'Upload Image',
                        ),),
                      ],
                    ),
                    const SizedBox(width: 20,),
                     SizedBox(
                        width: 200,
                      child: TextFormField(
                        validator: (value) {
                          if(value!.isEmpty){
                            return 'Enter Category Name';
                          }
                      },
                        controller: _cartName,
                        decoration: const InputDecoration(
                            label: Text('Enter category name'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    TextButton(onPressed: (){
                      clear();
                    },
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.white),
                        side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor),),
                    ),
                      child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    ),
                    const SizedBox(width: 10,),
                    image == null ? Container() : ElevatedButton(onPressed: (){
                      if(_formKey.currentState!.validate()){
                        saveImageToDb();
                      }
                    }, child: const Text(
                      'Save',
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(
                color: Colors.grey,
              ),
              Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(10),
                child:  const Text(
                  'Category List',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              CategoryListWidget(
                reference: _service.categories,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


