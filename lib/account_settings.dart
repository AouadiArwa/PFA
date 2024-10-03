import 'package:flutter/material.dart';
import 'profile_details.dart'; // Import the new file

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfileDetailsPage()),
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
            style: const TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
