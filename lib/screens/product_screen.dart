
import 'package:flutter/material.dart';

import '../widgets/product_list_widget.dart';

class ProductScreen extends StatelessWidget {
  static const String id = 'products-screen';
  const ProductScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 50,
                child: const Text(
                  'Product List',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9,
                child: SingleChildScrollView(
                  child: ProductsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}