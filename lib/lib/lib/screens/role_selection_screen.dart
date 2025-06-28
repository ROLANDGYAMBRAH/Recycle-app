import 'package:flutter/material.dart';
import 'package:waste_wise/services/auth_service.dart';
import 'package:waste_wise/models/user_role.dart';

class RoleSelectionScreen extends StatelessWidget {
  final String email;
  final String password;

  const RoleSelectionScreen({
    super.key,
    required this.email,
    required this.password,
  });

  void _selectRole(BuildContext context, String role) async {
    final user = await AuthService().signUp(email, password, role);
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/dashboard/$role');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Signup failed."),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Role")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
              onPressed: () => _selectRole(context, 'recycler'),
              child: Text("Recycler")),
          ElevatedButton(
              onPressed: () => _selectRole(context, 'compounder'),
              child: Text("Compounder")),
          ElevatedButton(
              onPressed: () => _selectRole(context, 'industry'),
              child: Text("Industry")),
        ],
      ),
    );
  }
}

