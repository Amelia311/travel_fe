import 'package:flutter/material.dart';
import '../services/trip_service.dart';

class TripScreen extends StatefulWidget {
  @override
  _TripScreenState createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  late Future<List<Map<String, dynamic>>> _tripList;

  @override
  void initState() {
    super.initState();
    _tripList = TripService.getTrips();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tripList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Belum ada trip'));
          }

          final trips = snapshot.data!;

          return ListView.builder(
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              return ListTile(
                title: Text(trip['title'] ?? ''),
                subtitle: Text(trip['date']?.split('T')[0] ?? ''),
              );
            },
          );
        },
      ),
    );
  }
}
