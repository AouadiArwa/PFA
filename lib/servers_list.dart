import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'view_sales.dart';

class ServersPage extends StatefulWidget {
  const ServersPage({super.key});

  @override
  _ServersPageState createState() => _ServersPageState();
}

class _ServersPageState extends State<ServersPage> {
  List<Map<String, dynamic>> _servers = [];

  @override
  void initState() {
    super.initState();
    _fetchServers();
  }

  Future<void> _fetchServers() async {
    final response = await http.get(Uri.parse('http://10.0.2.2/get_servers.php'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _servers = data.map((server) => {
          'id': server['id'],
          'name': server['name'],
        }).toList();

        // Sort the servers list by name
        _servers.sort((a, b) => a['name'].compareTo(b['name']));
      });
    } else {
      throw Exception('Failed to load servers');
    }
  }

  Future<void> _addServer(String name) async {
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Server name is required'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://10.0.2.2/add_server.php'),
      body: {'name': name},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        _fetchServers();
        _showServerAddedDialog();
      } else {
        debugPrint('Server addition failed: ${result['error']}');
        throw Exception('Failed to add server');
      }
    } else {
      throw Exception('Failed to add server');
    }
  }

  Future<void> _editServer(String currentName, String newName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/edit_server.php'),
      body: {'name': currentName, 'new_name': newName},
    );

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      if (result['success']) {
        _fetchServers();
        _showServerEditedDialog();
      } else {
        debugPrint('Server edit failed: ${result['error']}');
        throw Exception('Failed to edit server');
      }
    } else {
      throw Exception('Failed to edit server');
    }
  }

  Future<void> _deleteServer(String serverName) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2/delete_server.php'),
      body: {'name': serverName},
    );

    if (response.statusCode == 200) {
      try {
        final result = jsonDecode(response.body);
        if (result['success']) {
          _fetchServers();
          _showServerDeletedDialog();
        } else {
          debugPrint('Server deletion failed: ${result['error']}');
          throw Exception('Failed to delete server');
        }
      } catch (e) {
        debugPrint('JSON parsing error: $e');
        throw Exception('Failed to parse response');
      }
    } else {
      debugPrint('Failed to connect to server');
      throw Exception('Failed to delete server');
    }
  }

  void _showServerAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Server Added',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
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

  void _showServerEditedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Server Edited',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
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

  void _showServerDeletedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: const Text(
            'Server Deleted',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24),
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

  void _showAddServerDialog() {
    TextEditingController nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Server's Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Server's Name"),
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
                _addServer(nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditServerDialog(String currentName) {
    TextEditingController nameController = TextEditingController();
    nameController.text = currentName;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Server's Name"),
          content: TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Server's Name"),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Save'),
              onPressed: () {
                _editServer(currentName, nameController.text);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteServerDialog(String serverName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Server'),
          content: const Text('Do you want to delete this server?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                _deleteServer(serverName);
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
        title: Row(
          children: [
            const Text('Servers'),
            const Spacer(),
            TextButton.icon(
              onPressed: _showAddServerDialog,
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                'Add Server',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: _servers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.all(8.0),
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _servers[index]['name'],
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _showEditServerDialog(_servers[index]['name']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: const Text('Edit', style: TextStyle(color: Colors.white)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        _showDeleteServerDialog(_servers[index]['name']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Delete', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
