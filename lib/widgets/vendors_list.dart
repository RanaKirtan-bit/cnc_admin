import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:flutter/material.dart';

class VendorsList extends StatelessWidget {
  const VendorsList({Key? key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget _vendorData({
      String? logoUrl,
      String? shopName,
      String? city,
      String? state,
      bool? isApproved,
      VoidCallback? onApprove,
      VoidCallback? onReject,
      VoidCallback? onViewMore,
    }) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              SizedBox(
                width: 100, // Adjust the width as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(logoUrl!, width: 100, height: 100),
                ),
              ),
              SizedBox(
                width: 150, // Adjust the width as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    shopName!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150, // Adjust the width as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    city!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150, // Adjust the width as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    state!,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 150, // Adjust the width as needed
                child: ElevatedButton(
                  onPressed: isApproved != null && !isApproved ? onApprove : onReject,
                  style: ElevatedButton.styleFrom(
                    primary: isApproved != null && !isApproved ? Colors.blue : Colors.red,
                  ),
                  child: Text(isApproved != null && !isApproved ? 'Approve' : 'Reject'),
                ),
              ),
              SizedBox(
                width: 150, // Adjust the width as needed
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: onViewMore,
                    child: Text('View More'),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return StreamBuilder<QuerySnapshot>(
      stream: _service.sellers.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LinearProgressIndicator();
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;
            bool isApproved = data['approved'] ?? false;

            return _vendorData(
              logoUrl: data['logoUrl'],
              shopName: data['shopName'],
              city: data['city'],
              state: data['state'],
              isApproved: isApproved,
              onApprove: () {
                _service.sellers.doc(snapshot.data!.docs[index].id).update({
                  'approved': true,
                });

                // Additional logic if needed

                print('${data['shopName']} has been approved.');
              },
              onReject: () {
                _service.sellers.doc(snapshot.data!.docs[index].id).update({
                  'approved': false,
                });

                // Additional logic if needed

                print('${data['shopName']} has been rejected.');
              },
              onViewMore: () {
                // Implement the view more logic
                print('View More for ${data['shopName']}');
              },
            );
          },
        );
      },
    );
  }
}