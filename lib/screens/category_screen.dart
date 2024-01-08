import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class CategoryScreen extends StatefulWidget {
  static const String id = 'category';
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final TextEditingController _cartName = TextEditingController();
  final FirebaseService _service = FirebaseService();
dynamic image;
String? fileName;
final _formKey  = GlobalKey<FormState>();

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

    saveImageToDb() async{
      var ref = firebase_storage.FirebaseStorage.instance
          .ref('categoryImage/$fileName');
        EasyLoading.show();
        try{
              await ref.putData(image);
              String downloadURL = await ref
              .getDownloadURL().then((value) {
                      if(value.isNotEmpty) {
                        _service.saveCategory({
                          'cartName': _cartName.text,
                          'image': value,
                          'active': true,
                        }).then((value) {
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
          image = null;

        });
    }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child:  Text(
                'Categories',
                    style: TextStyle(
                          fontSize: 26,
                      fontWeight: FontWeight.w700,
            ),
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
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
                      child: Center(
                        child: image==null ?
                         Text(
                          'Category image',
                        ):Image.memory(image),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(onPressed: (){
                        pickImage();
                    }, child: Text(
                      'Upload Image',
                    ),),
                  ],
                ),
                SizedBox(width: 20,),
                 SizedBox(
                    width: 200,
                  child: TextFormField(
                    validator: (value) {
                      if(value!.isEmpty){
                        return 'Enter Category Name';
                      }
                  },
                    controller: _cartName,
                    decoration: InputDecoration(
                        label: Text('Enter category name'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(onPressed: (){}, child: Text(
                  'Cancel',
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    side: MaterialStateProperty.all(BorderSide(color: Theme.of(context).primaryColor),),
                ),
                ),
                const SizedBox(width: 10,),
                image == null ? Container() : ElevatedButton(onPressed: (){
                  if(_formKey.currentState!.validate()){
                    saveImageToDb();
                  }
                }, child: Text(
                  'Save',
                  ),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.grey,
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: const EdgeInsets.all(10),
            child:  Text(
              'Category List',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
