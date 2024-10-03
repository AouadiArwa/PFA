import 'package:flutter/material.dart';
import 'change_username.dart';

class ProfileDetailsPage extends StatelessWidget {
  const ProfileDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Settings'),
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
                  MaterialPageRoute(builder: (context) => const ChangeUsernamePage()),
                );
              },
              child: _buildSettingsCard('Change User Name'),
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
