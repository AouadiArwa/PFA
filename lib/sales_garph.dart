import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesGraphPage extends StatefulWidget {
  const SalesGraphPage({super.key});

  @override
  _SalesGraphPageState createState() => _SalesGraphPageState();
}

class _SalesGraphPageState extends State<SalesGraphPage> {
  List<BarChartGroupData> barChartData = [];
  List<String> itemNames = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSalesData();
  }

  Future<void> _fetchSalesData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2/fetch_sales_data.php'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        List<BarChartGroupData> tempData = [];
        List<String> tempItemNames = [];
        for (var item in data) {
          double totalSales;
          try {
            totalSales = double.parse(item['total_sales']);
          } catch (e) {
            print('Error parsing total sales: $e');
            continue; // Skip this item if parsing fails
          }

          tempData.add(
            BarChartGroupData(
              x: data.indexOf(item),
              barRods: [
                BarChartRodData(
                  toY: totalSales,
                  color: Colors.blue,
                ),
              ],
            ),
          );
          tempItemNames.add(item['article']);
        }

        setState(() {
          barChartData = tempData;
          itemNames = tempItemNames;
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to load sales data with status code: ${response.statusCode}';
        });
        print(errorMessage);
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Error fetching sales data: $e';
      });
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Sales Graph'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            width: 550, // Adjust width as needed
            height: 400, // Adjust height as needed
            child: BarChart(
              BarChartData(
                barGroups: barChartData,
                alignment: BarChartAlignment.spaceBetween,
                groupsSpace: 20, // Adjust space between groups
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 70, // Increase reserved size if needed
                      getTitlesWidget: (double value, TitleMeta meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Container(
                              width: 60, // Adjust width for spacing
                              child: Text(
                                itemNames[value.toInt()],
                                style: const TextStyle(fontSize: 10), // Adjust font size
                                textAlign: TextAlign.center,
                                softWrap: true,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
