import 'package:flutter/material.dart';
import 'add_trip_screen.dart';

class CreateTripScreen extends StatelessWidget {
  const CreateTripScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: Text('Tambah Trip Baru'),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTripScreen()),
          );
        },
      ),
    );
  }
}
