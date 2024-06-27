import 'package:flutter/material.dart';
import 'language_regions.dart';
import 'profile_details.dart'; // Import the new file

class AccountSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSettingsCard('Notifications'),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LanguageRegionPage()),
                );
              },
              child: _buildSettingsCard('Language & Region'),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileDetailsPage()),
                );
              },
              child: _buildSettingsCard('Profile Details'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsCard(String title) {
    return Card(
      elevation: 5,
      child: SizedBox(
        width: double.infinity,
        height: 100,
        child: Center(
          child: Text(
            title,
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
