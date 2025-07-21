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
      appBar: AppBar(title: Text("Itinerary: ${widget.tripName}")),
      body: FutureBuilder<List<Itinerary>>(
        future: _itineraryList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final itinerary = snapshot.data ?? [];
          if (itinerary.isEmpty) {
            return const Center(child: Text("Belum ada aktivitas"));
          }

          // Kelompokkan berdasarkan tanggal
          final grouped = <String, List<Itinerary>>{};
          for (var item in itinerary) {
            grouped.putIfAbsent(item.date, () => []).add(item);
          }

          return ListView(
            children: grouped.entries.map((entry) {
              final date = entry.key;
              final items = entry.value;

              return ExpansionTile(
                title: Text("Tanggal: $date"),
                children: items.map((act) {
                  final time = act.startTime ?? '-';
                  return ListTile(
                    title: Text('$time - ${act.activity}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await ItineraryService.deleteItinerary(act.id);
                        setState(() => _fetchItineraries());
                      },
                    ),
                  );
                }).toList(),
              );
            }).toList(),
          );
        },
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
        child: const Icon(Icons.add),
      ),
    );
  }
}
