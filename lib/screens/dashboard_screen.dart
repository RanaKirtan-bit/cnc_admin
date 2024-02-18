import 'package:flutter/material.dart';
import '../firebase_service.dart';

class DashBoardScreen extends StatelessWidget {
  final FirebaseService _service = FirebaseService();
  static const String id = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Sellers: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FutureBuilder<int>(
              future: _service.getTotalSellers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Total Products: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FutureBuilder<int>(
              future: _service.getTotalProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data');
                } else {
                  return Text(
                    snapshot.data.toString(),
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            Text(
              'Category-wise Product Count: ',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            FutureBuilder<Map<String, int>>(
              future: _service.getCategoryProductCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.entries.map((entry) {
                      return Text(
                        '${entry.key}: ${entry.value}',
                        style: TextStyle(fontSize: 18),
                      );
                    }).toList(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
