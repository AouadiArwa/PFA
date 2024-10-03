import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesPredictionPage extends StatefulWidget {
  const SalesPredictionPage({super.key});

  @override
  _SalesPredictionPageState createState() => _SalesPredictionPageState();
}

class _SalesPredictionPageState extends State<SalesPredictionPage> {
  List<FlSpot> lineChartData = [];
  List<String> itemNames = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchPredictionData();
  }

  Future<void> _fetchPredictionData() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:8000/api/predict-sales/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        List<FlSpot> tempData = [];
        List<String> tempItemNames = [];
        for (var i = 0; i < data.length; i++) {
          double predictedSales = double.tryParse(data[i]['predicted_sales'].toString()) ?? 0.0;

          // Ensure non-negative sales values
          if (predictedSales < 0) {
            predictedSales = 0.0;
          }

          tempData.add(FlSpot(i.toDouble(), predictedSales));
          tempItemNames.add(data[i]['date']);
        }

        setState(() {
          lineChartData = tempData;
          itemNames = tempItemNames;
          isLoading = false;
          hasError = false;
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Failed to load prediction data with status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
        errorMessage = 'Error fetching prediction data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: const Text('Sales Prediction'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: isLoading
              ? const CircularProgressIndicator()
              : hasError
              ? Text(errorMessage)
              : SizedBox(
            width: double.infinity, // Use full width
            height: 400, // Adjust height as needed
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: lineChartData,
                    isCurved: true,
                    color: Colors.green,
                    barWidth: 4,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            itemNames.isNotEmpty && index < itemNames.length
                                ? itemNames[index].substring(5, 10).replaceAll('-', '/') // Change substring range to get DD-MM format
                                : '',
                            style: const TextStyle(fontSize: 10),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                      reservedSize: 70,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
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
