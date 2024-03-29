
// vendor_list.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cnc_admin/firebase_service.dart';
import 'package:flutter/material.dart';

class VendorsList extends StatefulWidget {
  const VendorsList({Key? key});

  @override
  State<VendorsList> createState() => _VendorsListState();
}

class _VendorsListState extends State<VendorsList> {
  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    Widget _vendorData({
      String? logoUrl,
      String? shopName,
      String? city,
      String? state,
      bool? isApproved,
      String? documentId,
      VoidCallback? onApprove,
      VoidCallback? onReject,
      VoidCallback? onViewMore,
    }) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.network(logoUrl!, width: 100, height: 100),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          shopName!,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'City: $city',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'State: $state',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 100,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ElevatedButton(
                        onPressed: isApproved != null && !isApproved
                            ? () async {
                          await _service.sellers.doc(documentId).update({
                            'approved': true,
                          });
                          Navigator.pushReplacementNamed(
                              context, '/vendor_home');
                        }
                            : () async {
                          await _service.sellers.doc(documentId).update({
                            'approved': false,
                          });
                          Navigator.pushReplacementNamed(context, '/landing');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isApproved != null && !isApproved
                              ? Colors.blue
                              : Colors.red,
                        ),
                        child:
                        Text(isApproved != null && !isApproved ? 'Approve' : 'Reject'),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: onViewMore,
                        child: Text('View More'),
                      ),
                      SizedBox(height: 100,)
                    ],
                  ),
                ),
              ],
            ),
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
          physics: NeverScrollableScrollPhysics(),
          itemCount: snapshot.data!.size,
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;
            String documentId = snapshot.data!.docs[index].id;
            bool isApproved = data['approved'] ?? false;

            return _vendorData(
              logoUrl: data['logoUrl'],
              shopName: data['shopName'],
              city: data['city'],
              state: data['state'],
              isApproved: isApproved,
              documentId: documentId,
              onApprove: () async {
                await _service.sellers.doc(documentId).update({
                  'approved': true,
                });
                // Additional logic if needed
                print('${data['shopName']} has been approved.');
              },
              onReject: () async {
                await _service.sellers.doc(documentId).update({
                  'approved': false,
                });
                // Additional logic if needed
                print('${data['shopName']} has been rejected.');
              },
              onViewMore: () {showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Additional Details'),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('shopName: ${data['shopName'] ?? 'Not Available'}'),
                        Text('Email: ${data['email'] ?? 'Not Available'}'),
                        Text('Address: ${data['address'] ?? 'Not Available'}'),
                        Text('Landmark: ${data['landmark'] ?? 'Not Available'}'),
                        Text('Pincode: ${data['pinCode'] ?? 'Not Available'}'),
                        Text('Phone.No: ${data['phoneNumber'] ?? 'Not Available'}'),
                        // Add more details as needed
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
              },
            );
          },
        );
      },
    );
  }
}
























/*
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
      String? documentId, // Added documentId parameter
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
                width: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(logoUrl!, width: 100, height: 100),
                ),
              ),
              SizedBox(
                width: 150,
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
                width: 150,
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
                width: 150,
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
                width: 150,
                child: ElevatedButton(
                  onPressed: isApproved != null && !isApproved
                      ? () async {
                    await _service.sellers.doc(documentId).update({
                      'approved': true,
                    });

                    // Navigate to the vendor home screen
                    Navigator.pushReplacementNamed(context, '/vendor_home');
                  }
                      : () async {
                    await _service.sellers.doc(documentId).update({
                      'approved': false,
                    });

                    // Navigate to the landing screen
                    Navigator.pushReplacementNamed(context, '/landing');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: isApproved != null && !isApproved ? Colors.blue : Colors.red,
                  ),
                  child: Text(isApproved != null && !isApproved ? 'Approve' : 'Reject'),
                ),
              ),
              SizedBox(
                width: 150,
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
            String documentId = snapshot.data!.docs[index].id;
            bool isApproved = data['approved'] ?? false;

            return _vendorData(
              logoUrl: data['logoUrl'],
              shopName: data['shopName'],
              city: data['city'],
              state: data['state'],
              isApproved: isApproved,
              documentId: documentId, // Pass the document ID
              onApprove: () {
                _service.sellers.doc(documentId).update({
                  'approved': true,
                });

                // Additional logic if needed

                print('${data['shopName']} has been approved.');
              },
              onReject: () {
                _service.sellers.doc(documentId).update({
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


 */



