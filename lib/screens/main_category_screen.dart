import 'package:flutter/material.dart';

class MainCategoryScreen extends StatelessWidget {
  static const String id = 'main-category';
  const MainCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child:  Text(
        'Main Category Screen',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
    );
  }
}
