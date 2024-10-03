import 'package:flutter/material.dart';

class LanguageRegionPage extends StatefulWidget {
  const LanguageRegionPage({super.key});

  @override
  _LanguageRegionPageState createState() => _LanguageRegionPageState();
}

class _LanguageRegionPageState extends State<LanguageRegionPage> {
  String _selectedLanguage = 'English (US)';

  void _changeLanguage(String language) {
    setState(() {
      _selectedLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Language & Region'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Account Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Language',
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showLanguageDialog();
                      },
                      child: Text(_selectedLanguage),
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

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: const Text('English (US)'),
                  onTap: () {
                    _changeLanguage('English (US)');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('French'),
                  onTap: () {
                    _changeLanguage('French');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Arabic'),
                  onTap: () {
                    _changeLanguage('Arabic');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: const Text('Turkish'),
                  onTap: () {
                    _changeLanguage('Turkish');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
