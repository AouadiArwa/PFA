import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ItemsListPage extends StatefulWidget {
  const ItemsListPage({super.key});

  @override
  _ItemsListPageState createState() => _ItemsListPageState();
}

class _ItemsListPageState extends State<ItemsListPage> {
  List<Map<String, dynamic>> _items = [];

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/get_items.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _items = data.map((item) => {
          'id': int.parse(item['id']),
          'name': item['name'],
          'price': double.parse(item['price']),
        }).toList();
      });
    } else {
      throw Exception('Failed to load items');
    }
  }

  Future<void> _addItem(String name, double price) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/add_item.php'),
      body: {'name': name, 'price': price.toString()},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        _fetchItems();
        Navigator.of(context).pop(); // Close the dialog
        _showMessage('Item added');
      } else {
        debugPrint('Item addition failed: ${result['error']}');
        throw Exception('Failed to add item');
      }
    } else {
      throw Exception('Failed to add item');
    }
  }

  Future<void> _editItem(int id, String name, double price) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/edit_item.php'),
      body: {'id': id.toString(), 'name': name, 'price': price.toString()},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        _fetchItems();
        Navigator.of(context).pop(); // Close the dialog
      } else {
        debugPrint('Item edit failed: ${result['error']}');
        throw Exception('Failed to edit item');
      }
    } else {
      throw Exception('Failed to edit item');
    }
  }

  Future<void> _deleteItem(int id) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/delete_item.php'),
      body: {'id': id.toString()},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        _fetchItems();
        _showMessage('Item deleted');
      } else {
        debugPrint('Item deletion failed: ${result['error']}');
        throw Exception('Failed to delete item');
      }
    } else {
      throw Exception('Failed to delete item');
    }
  }

  void _showAddItemDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Add Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  _addItem(nameController.text, double.parse(priceController.text));
                }
              },
              child: const Text('Create Item'),
            ),
          ],
        );
      },
    );
  }

  void _showEditItemDialog(int id, String currentName, double currentPrice) {
    TextEditingController nameController = TextEditingController(text: currentName);
    TextEditingController priceController = TextEditingController(text: currentPrice.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Item"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              onPressed: () {
                if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                  _editItem(id, nameController.text, double.parse(priceController.text));
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteItemDialog(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Item'),
          content: const Text('Do you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                _deleteItem(id);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Items List'),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddItemDialog,
          ),
        ],
      ),
      body: _buildTable(),
    );
  }

  Widget _buildTable() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: const [
          DataColumn(label: Text('ID')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Price')),
          DataColumn(label: Text('Actions')),
        ],
        rows: _items.map((item) {
          return DataRow(cells: [
            DataCell(Text(item['id'].toString())),
            DataCell(Text(item['name'])),
            DataCell(Text(item['price'].toStringAsFixed(2))),
            DataCell(Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _showEditItemDialog(item['id'], item['name'], item['price']);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteItemDialog(item['id']);
                  },
                ),
              ],
            )),
          ]);
        }).toList(),
      ),
    );
  }
}
