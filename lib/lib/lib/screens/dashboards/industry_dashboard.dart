import 'package:flutter/material.dart';
import 'package:waste_wise/services/auth_service.dart';

class IndustryDashboard extends StatelessWidget {
  const IndustryDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Industry Dashboard'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              AuthService().signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          )
        ],
      ),
      body: Center(
        child: Text("Welcome, Industry!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

