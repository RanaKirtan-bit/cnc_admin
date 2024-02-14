import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:flutter/material.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget _productData({
      String? productName,
      String? category,
      List<dynamic>? imageUrls,
      bool? isApproved,
      String? documentId,
      VoidCallback? onApprove,
      VoidCallback? onReject,
      VoidCallback? onDelete,
    }) {
      List<String> imageUrlList = List<String>.from(imageUrls ?? []);
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(imageUrlList.isNotEmpty ? imageUrlList[0] : '', width: 100, height: 100),
                ),
              ),
              SizedBox(
                width: 80,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    productName!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 70,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    category!,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 90,
                child: ElevatedButton(
                  onPressed: isApproved != null && !isApproved
                      ? () async {
                    await _service.products.doc(documentId).update({
                      'approved': true,
                    });
                    // Additional logic if needed
                    print('$productName has been approved.');
                  }
                      : () async {
                    await _service.products.doc(documentId).update({
                      'approved': false,
                    });
                    // Additional logic if needed
                    print('$productName has been rejected.');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isApproved != null && !isApproved ? Colors.blue : Colors.red,
                  ),
                  child: Text(isApproved != null && !isApproved ? 'Approve' : 'Reject'),
                ),
              ),
              SizedBox(
                width: 20,
                child: IconButton(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _service.products.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = snapshot.data!.docs[index].data() as Map<String, dynamic>;
            String documentId = snapshot.data!.docs[index].id;
            bool isApproved = data['approved'] ?? false;

            return _productData(
              productName: data['productName'],
              imageUrls: data['imageUrls'],
              category: data['category'],
              isApproved: isApproved,
              documentId: documentId,
              onApprove: () {
                _service.products.doc(documentId).update({
                  'approved': true,
                });
                // Additional logic if needed
                //print('$productName has been approved.');
              },
              onReject: () {
                _service.products.doc(documentId).update({
                  'approved': false,
                });
                // Additional logic if needed
                //print('$productName has been rejected.');
              },
              onDelete: () {
                // Logic to delete the product
                _service.products.doc(documentId).delete();
                // Additional logic if needed
                //print('$productName has been deleted.');
              },
            );
          },
        );
      },
    );
  }
}
