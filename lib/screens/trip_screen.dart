import 'package:flutter/material.dart';
import '../services/trip_service.dart';
import 'add_trip_screen.dart';
import 'itinerary_screen.dart'; // ← ini ditambahkan

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

  void _refreshTrips() {
    setState(() {
      _tripList = TripService.getTrips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Trip")),
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(trip['date']?.split('T')[0] ?? ''),
                    Text(trip['description'] ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
                  ],
                ),
                isThreeLine: true,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ItineraryScreen(
                        tripId: trip['id'],
                        tripName: trip['title'], // atau trip['name'] kalau beda
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTripScreen()),
          );
          if (result == true) {
            _refreshTrips();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
