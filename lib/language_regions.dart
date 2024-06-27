import 'package:flutter/material.dart';

class LanguageRegionPage extends StatefulWidget {
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
        title: Text('Language & Region'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Account Language',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
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
          title: Text('Select Language'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                ListTile(
                  title: Text('English (US)'),
                  onTap: () {
                    _changeLanguage('English (US)');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('French'),
                  onTap: () {
                    _changeLanguage('French');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Arabic'),
                  onTap: () {
                    _changeLanguage('Arabic');
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Turkish'),
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
