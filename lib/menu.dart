import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projet/view_sales.dart';
import 'servers_list.dart';
import 'item_list.dart';
import 'account_settings.dart';
import 'main.dart';
import 'sales_garph.dart';
import 'sales_prediction_page.dart';

class MenuPage extends StatefulWidget {
    const MenuPage({super.key});

    @override
    _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
    int totalSalesToday = 0;
    int totalArticles = 0;
    int totalServers = 0;

    @override
    void initState() {
        super.initState();
        _fetchTotalSalesToday();
        _fetchTotalArticles();
        _fetchTotalServers();
    }

    Future<void> _fetchTotalSalesToday() async {
        try {
            final response = await http.get(Uri.parse('http://10.0.2.2/total_sales_today.php'));

            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                final todaySales = data['total_sales_today'];

                setState(() {
                    totalSalesToday = todaySales ?? 0;
                });
            } else {
                print('Failed to load total sales for today');
            }
        } catch (e) {
            print('Error fetching total sales for today: $e');
        }
    }

    Future<void> _fetchTotalArticles() async {
        try {
            final response = await http.get(Uri.parse('http://10.0.2.2/total_items.php'));

            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                final articles = data['total_articles'];

                setState(() {
                    totalArticles = articles ?? 0;
                });
            } else {
                print('Failed to load total articles');
            }
        } catch (e) {
            print('Error fetching total articles: $e');
        }
    }

    Future<void> _fetchTotalServers() async {
        try {
            final response = await http.get(Uri.parse('http://10.0.2.2/total_servers.php'));

            if (response.statusCode == 200) {
                final data = json.decode(response.body);
                final servers = data['total_servers'];

                setState(() {
                    totalServers = servers ?? 0;
                });
            } else {
                print('Failed to load total servers');
            }
        } catch (e) {
            print('Error fetching total servers: $e');
        }
    }

    void _showTotalSalesTodayDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Total Sales Today'),
                    content: SingleChildScrollView(
                        child: ListBody(
                            children: <Widget>[
                                Text('Total Sales for Today: $totalSalesToday'),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _showTotalArticlesDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Total Articles'),
                    content: SingleChildScrollView(
                        child: ListBody(
                            children: <Widget>[
                                Text('Total Articles: $totalArticles'),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('Close'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _showTotalServersDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Total Servers'),
                    content: SingleChildScrollView(
                        child: ListBody(
                            children: <Widget>[
                                Text('Total Servers: $totalServers'),
                            ],
                        ),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('Close'),
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
                backgroundColor: Colors.purple,
                title: const Text('Menu'),
            ),
            drawer: Drawer(
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: <Widget>[
                        const DrawerHeader(
                            decoration: BoxDecoration(
                                color: Colors.purple,
                            ),
                            child: Text(
                                'Menu',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                ),
                            ),
                        ),
                        ListTile(
                            leading: const Icon(Icons.list),
                            title: const Text('Server List'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ServersPage()),
                                );
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.inventory),
                            title: const Text('Items List'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ItemsListPage()),
                                );
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.receipt),  // Use your chosen icon here
                            title: const Text('View Sales'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ViewSalesPage()),
                                );
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.bar_chart),
                            title: const Text('Sales Graph'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const SalesGraphPage()),
                                );
                            },
                        ),
                        ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('Account Setting'),
                            onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const AccountSettingsPage()),
                                );
                            },
                        ),


                        ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('Log Out'),
                            onTap: () {
                                _showConfirmLogoutDialog(context);
                            },
                        ),
                    ],
                ),
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                        _buildStatCard('Total Sales Today', totalSalesToday),
                        const SizedBox(height: 16),
                        _buildStatCard('Total Articles', totalArticles),
                        const SizedBox(height: 16),
                        _buildStatCard('Total Servers', totalServers),
                    ],
                ),
            ),
        );
    }

    Widget _buildStatCard(String title, int value) {
        return Card(
            color: Colors.white,
            elevation: 5,
            child: InkWell(
                onTap: () {
                    if (title == 'Total Sales Today') {
                        _showTotalSalesTodayDialog(context);
                    } else if (title == 'Total Articles') {
                        _showTotalArticlesDialog(context);
                    } else if (title == 'Total Servers') {
                        _showTotalServersDialog(context);
                    }
                },
                child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            Text(
                                title,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                            ),
                            Text(
                                '$value',
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                            ),
                        ],
                    ),
                ),
            ),
        );
    }

    void _showConfirmLogoutDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text(
                        'Are you sure you want to log out?',
                        style: TextStyle(fontSize: 18),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('No'),
                            onPressed: () {
                                Navigator.of(context).pop();
                            },
                        ),
                        TextButton(
                            child: const Text('Yes'),
                            onPressed: () {
                                Navigator.of(context).pop();
                                _showLoggedOutDialog(context);
                            },
                        ),
                    ],
                );
            },
        );
    }

    void _showLoggedOutDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    content: const Text(
                        'You logged out',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                    ),
                    actions: <Widget>[
                        TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const LoginPage()),
                                );
                            },
                        ),
                    ],
                );
            },
        );
    }
}
