import 'package:flutter/material.dart';
import '../services/trip_service.dart';
import 'add_trip_screen.dart';
import 'itinerary_screen.dart';
import 'main_screen.dart';

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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Daftar Trip', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshTrips();
          await _tripList;
        },
        color: Colors.blue[400],
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _tripList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data trip',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refreshTrips,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                      ),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.travel_explore, size: 80, color: Colors.blue[200]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada trip',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan trip pertama Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            final trips = snapshot.data!;

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: trips.length,
              itemBuilder: (context, index) {
                final trip = trips[index];
                final date = trip['date']?.split('T')[0] ?? '';
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ItineraryScreen(
                            tripId: trip['id'],
                            tripName: trip['title'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  trip['title'] ?? '',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue[800],
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue[50],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  date,
                                  style: TextStyle(
                                    color: Colors.blue[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (trip['description']?.isNotEmpty ?? false)
                            Text(
                              trip['description'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.chevron_right,
                              color: Colors.blue[400],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
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
        backgroundColor: Colors.blue[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}