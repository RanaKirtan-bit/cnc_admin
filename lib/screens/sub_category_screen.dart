import 'package:flutter/material.dart';

class SubCategoryScreen extends StatelessWidget {
  static const String id = 'sub-category';
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Text(
        'Sub Category Screen',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
