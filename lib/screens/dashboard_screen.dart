import 'package:flutter/material.dart';
import '../firebase_service.dart';
import 'package:fl_chart/fl_chart.dart';

class DashBoardScreen extends StatelessWidget {
  final FirebaseService _service = FirebaseService();
  static const String id = 'dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
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
                  return _buildStatCard(
                    title: 'Total Sellers',
                    value: snapshot.data!,
                    icon: Icons.people,
                  );
                }
              },
            ),

            SizedBox(height: 16),

            FutureBuilder<int>(
              future: _service.getTotalProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading data: ${snapshot.error}');
                } else {
                  return _buildStatCard(
                    title: 'Total Products',
                    value: snapshot.data!,
                    icon: Icons.shopping_bag,
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

  Widget _buildStatCard({required String title, required int value, required IconData icon}) {
    return Card(
      elevation: 4,
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Total: $value',
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
        leading: Icon(
          icon,
          size: 40,
          color: Colors.blue,
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

    return Card(
      elevation: 4,
      child: Container(
        height: 300, // Set a specific height for the chart
        child: PieChart(
          PieChartData(
            sections: categoryData?.entries
                .map(
                  (entry) => PieChartSectionData(
                value: entry.value.toDouble(),
                color: colors[categoryData.keys.toList().indexOf(entry.key) % colors.length],
                title: "${entry.key}\n${entry.value}", // Display category name and product count
                radius: 150, // Set the radius of the pie chart sections
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
      ),
    );
  }
}
