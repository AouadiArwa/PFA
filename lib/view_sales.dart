import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ViewSalesPage extends StatefulWidget {
  const ViewSalesPage({super.key});

  @override
  _ViewSalesPageState createState() => _ViewSalesPageState();
}

class _ViewSalesPageState extends State<ViewSalesPage> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _serverNameController = TextEditingController();
  List<Map<String, dynamic>> _salesData = [];
  bool _noSalesForDate = false;
  double _totalSales = 0.0;

  @override
  void initState() {
    super.initState();
    _dateController.addListener(_handleDateChange);
    // Fetch initial data for today's date
    _fetchCurrentDateSales(); // Fetch sales data for the current date
  }

  @override
  void dispose() {
    _dateController.removeListener(_handleDateChange);
    _dateController.dispose();
    _serverNameController.dispose();
    super.dispose();
  }

  void _handleDateChange() {
    if (_dateController.text.isNotEmpty) {
      _fetchSalesData(_dateController.text, _serverNameController.text);
    }
  }

  String _getTodayDate() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Dismiss keyboard on tap
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('View Sales'),
          backgroundColor: Colors.purple,
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showAddArticleDialog();
              },
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _serverNameController,
                decoration: const InputDecoration(
                  labelText: 'Enter server name',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _dateController,
                decoration: InputDecoration(
                  labelText: 'Enter date (yyyy-mm-dd)',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _fetchSalesData(
                          _dateController.text, _serverNameController.text);
                      FocusScope.of(context)
                          .unfocus(); // Dismiss keyboard on search icon press
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: _salesData.isEmpty && _noSalesForDate
                  ? const Center(
                child: Text(
                  'No sales for this date',
                  style: TextStyle(fontSize: 18, color: Colors.red),
                ),
              )
                  : SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    Table(
                      border: TableBorder.all(),
                      columnWidths: const <int, TableColumnWidth>{
                        0: FlexColumnWidth(),
                        1: FlexColumnWidth(),
                        2: FlexColumnWidth(),
                        3: FlexColumnWidth(),
                      },
                      children: [
                        _buildRow(
                          ['Server', 'Article', 'Quantity', 'Total (Tnd)'],
                          isHeader: true,
                        ),
                        for (var sale in _salesData)
                          _buildRow([
                            sale['server'].toString(),
                            sale['article'].toString(),
                            sale['quantity'].toString(),
                            '${sale['total']} Tnd',
                          ]),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Sales: $_totalSales Tnd',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildRow(List<String> cells, {bool isHeader = false}) {
    return TableRow(
      children: cells.map((cell) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            cell,
            style: TextStyle(
              fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              fontSize: 14.0,
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _fetchSalesData(String date, String serverName) async {
    // Get server ID using the server name
    final serverIdResponse = await http.post(
      Uri.parse('http://10.0.2.2/get_server_id.php'),
      body: {'server_name': serverName},
    );

    if (serverIdResponse.statusCode == 200) {
      final serverIdData = jsonDecode(serverIdResponse.body);
      final serverId = serverIdData['server_id'];

      if (serverId != null) {
        // Fetch sales data using server ID
        final response = await http.post(
          Uri.parse('http://10.0.2.2/get_sales.php'),
          body: {
            'date': date,
            'server_id': serverId.toString(),
          },
        );

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          print('Sales Data: $data'); // Debugging statement
          setState(() {
            _salesData = List<Map<String, dynamic>>.from(data['sales']);
            _noSalesForDate = _salesData.isEmpty;
            _totalSales = data['totalSales']?.toDouble() ?? 0.0;
          });
        } else {
          throw Exception('Failed to load sales');
        }
      } else {
        setState(() {
          _salesData = [];
          _noSalesForDate = true;
        });
      }
    } else {
      throw Exception('Failed to get server ID');
    }
  }

  Future<void> _fetchCurrentDateSales() async {
    // Fetch sales data for the current date
    final today = _getTodayDate();
    final response = await http.post(
      Uri.parse('http://10.0.2.2/show_sales.php'),
      body: {
        'date': today,
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('Today\'s Sales Data: $data'); // Debugging statement
      setState(() {
        _salesData = List<Map<String, dynamic>>.from(data['sales']);
        _noSalesForDate = _salesData.isEmpty;
        _totalSales = data['totalSales']?.toDouble() ?? 0.0;
      });
    } else {
      throw Exception('Failed to load sales for today');
    }
  }

  void _showAddArticleDialog() {
    TextEditingController articleController = TextEditingController();
    TextEditingController quantityController = TextEditingController();
    TextEditingController serverNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Article"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: articleController,
                decoration: const InputDecoration(labelText: 'Article Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: serverNameController,
                decoration: const InputDecoration(labelText: 'Server Name'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                _addArticle(
                  articleController.text,
                  int.parse(quantityController.text),
                  serverNameController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addArticle(String article, int quantity,
      String serverName) async {
    try {
      final now = DateTime.now();
      final date = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now
          .day.toString().padLeft(2, '0')}';

      final response = await http.post(
        Uri.parse('http://10.0.2.2/add_sale.php'),
        body: {
          'article': article,
          'quantity': quantity.toString(),
          'server_name': serverName,
          'date': date,
        },
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result['success']) {
          _fetchCurrentDateSales();
        } else {
          print('Failed to add article: ${result['error']}');
        }
      } else {
        print('Failed to add article');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
