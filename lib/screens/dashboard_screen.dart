import 'package:flutter/material.dart';
import '../firebase_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardScreen extends StatelessWidget {
  final FirebaseService _service = FirebaseService();
  static const String id = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<int>(
              future: _service.getTotalSellers(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else {
                  return Text(
                    'Total Sellers: ${snapshot.data}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),

            SizedBox(height: 16),
           // _buildStatCard(
             // title: 'Total Products',
              //valueFuture: _service.getTotalProducts(),
            //),
            FutureBuilder<int>(
              future: _service.getTotalProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else {
                  return Text(
                    'Total Products: ${snapshot.data}',
                    style: TextStyle(fontSize: 18),
                  );
                }
              },
            ),

            SizedBox(height: 16),
            _buildCategoryWiseProductCount(),
          ],
        ),
      ),
    );
  }


  Widget _buildCategoryWiseProductCount() {
    return FutureBuilder<Map<String, int>>(
      future: _service.getCategoryProductCount(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data: ${snapshot.error}');
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Category-wise Product Count',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildCategoryWisePieChart(snapshot.data),
            ],
          );
        }
      },
    );
  }


  Widget _buildCategoryWisePieChart(Map<String, int>? categoryData) {
    List<Color> colors = [
      Colors.cyanAccent,
      Colors.lightGreenAccent,
      Colors.orange,
      Colors.blue,
      // Add more colors as needed
    ];

    return Container(
      height: 200, // Set a specific height for the chart
      child: PieChart(
        PieChartData(
          sections: categoryData?.entries
              .map(
                (entry) => PieChartSectionData(
              value: entry.value.toDouble(),
              color: colors[categoryData.keys.toList().indexOf(entry.key) % colors.length],
              title: "${entry.key}\n${entry.value}", // Display category name and product count
              radius: 100, // Set the radius of the pie chart sections
              titleStyle: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          )
              .toList() ??
              [],
          borderData: FlBorderData(show: false),
          centerSpaceRadius: 0,
          sectionsSpace: 0,
        ),
      ),
    );
  }







}