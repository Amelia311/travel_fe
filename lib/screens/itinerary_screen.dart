import 'package:flutter/material.dart';
import '../services/itinerary_service.dart';
import 'add_activity_screen.dart';
import '../models/itinerary_model.dart';

class ItineraryScreen extends StatefulWidget {
  final int tripId;
  final String tripName;

  const ItineraryScreen({required this.tripId, required this.tripName, super.key});

  @override
  State<ItineraryScreen> createState() => _ItineraryScreenState();
}

class _ItineraryScreenState extends State<ItineraryScreen> {
  late Future<List<Itinerary>> _itineraryList;

  @override
  void initState() {
    super.initState();
    _fetchItineraries();
  }

  void _fetchItineraries() {
    _itineraryList = ItineraryService.getItineraries(widget.tripId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.tripName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.blue[400],
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _fetchItineraries());
          await _itineraryList;
        },
        color: Colors.blue[400],
        child: FutureBuilder<List<Itinerary>>(
          future: _itineraryList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 50, color: Colors.red[400]),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat itinerary',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _fetchItineraries,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[400],
                      ),
                      child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            }

            final itinerary = snapshot.data ?? [];
            if (itinerary.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.calendar_today, size: 80, color: Colors.blue[200]),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada aktivitas',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tambahkan aktivitas pertama Anda',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            // Kelompokkan berdasarkan tanggal
            final grouped = <String, List<Itinerary>>{};
            for (var item in itinerary) {
              grouped.putIfAbsent(item.date, () => []).add(item);
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: grouped.entries.map((entry) {
                final date = entry.key;
                final items = entry.value;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      "Tanggal: $date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                      ),
                    ),
                    leading: Icon(Icons.calendar_today, color: Colors.blue[400]),
                    collapsedBackgroundColor: Colors.blue[50],
                    backgroundColor: Colors.white,
                    children: items.map((act) {
                      final time = act.startTime ?? '-';
                      return Container(
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey[200]!,
                              width: 1,
                            ),
                          ),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.blue[50],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.access_time,
                              color: Colors.blue[400],
                            ),
                          ),
                          title: Text(
                            act.activity,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[800],
                            ),
                          ),
                          subtitle: Text(
                            'Waktu: $time',
                            style: TextStyle(
                              color: Colors.grey[600],
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[400],
                            ),
                            onPressed: () async {
                              await ItineraryService.deleteItinerary(act.id);
                              setState(() => _fetchItineraries());
                            },
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddActivityScreen(tripId: widget.tripId),
            ),
          );

          if (result == true) {
            setState(() => _fetchItineraries());
          }
        },
        backgroundColor: Colors.blue[400],
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}