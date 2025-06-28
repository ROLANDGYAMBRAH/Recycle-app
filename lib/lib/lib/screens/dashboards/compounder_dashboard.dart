import 'package:flutter/material.dart';
import 'package:waste_wise/services/auth_service.dart';

class CompounderDashboard extends StatelessWidget {
  const CompounderDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compounder Dashboard'),
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
        child: Text("Welcome, Compounder!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

