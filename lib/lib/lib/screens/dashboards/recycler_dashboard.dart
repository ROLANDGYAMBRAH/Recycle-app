import 'package:flutter/material.dart';
import 'package:waste_wise/services/auth_service.dart';

class RecyclerDashboard extends StatelessWidget {
  const RecyclerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recycler Dashboard'),
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
        child: Text("Welcome, Recycler!", style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

