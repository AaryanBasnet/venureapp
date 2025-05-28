import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Profile",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              SizedBox(width: 30),
              CircleAvatar(),
              SizedBox(width: 20),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Text("Aaryan"), Text("Aaryan@gmail.com")],
              ),
            ],
          ),
          SizedBox(height: 20),
          Card(
            child: Column(
              children: [
                Text("Edit profile Information"),
                SizedBox(height: 20),
                Text("Edit profile Information"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
