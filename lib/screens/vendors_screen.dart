import 'package:cnc_admin/widgets/vendors_list.dart';
import 'package:flutter/material.dart';

class VendorScreen extends StatelessWidget {
  static const String id = 'vendors-screen';
  const VendorScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    Widget _rowHeader({int? flex, String? text}) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade700,
          ),
          color: Colors.grey.shade500,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            text!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 21.5),
          ),
        ),
      );
    }
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
                  'Registered Vendors',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.9, // Adjust the height as needed
                child: SingleChildScrollView(
                  child: VendorsList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
