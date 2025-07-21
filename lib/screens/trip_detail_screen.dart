// import 'package:flutter/material.dart';
// import '../services/itinerary_service.dart';
// import 'add_itinerary_screen.dart';

// class TripDetailScreen extends StatefulWidget {
//   final int tripId;
//   final String tripName;

//   const TripDetailScreen({required this.tripId, required this.tripName});

//   @override
//   State<TripDetailScreen> createState() => _TripDetailScreenState();
// }

// class _TripDetailScreenState extends State<TripDetailScreen> {
//   late Future<List<Map<String, dynamic>>> _itineraryList;

//   @override
//   void initState() {
//     super.initState();
//     _fetchItineraries();
//   }

//   void _fetchItineraries() {
//     setState(() {
//       _itineraryList = ItineraryService.getItinerariesByTrip(widget.tripId);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Itinerary: ${widget.tripName}')),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: _itineraryList,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());
//           if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));

//           final itinerary = snapshot.data!;
//           if (itinerary.isEmpty) return Center(child: Text("Belum ada aktivitas"));

//           return ReorderableListView(
//             onReorder: (oldIndex, newIndex) {
//               setState(() {
//                 if (newIndex > oldIndex) newIndex -= 1;
//                 final item = itinerary.removeAt(oldIndex);
//                 itinerary.insert(newIndex, item);
//               });
//             },
//             children: [
//               for (final item in itinerary)
//                 ListTile(
//                   key: ValueKey(item['id']),
//                   title: Text(item['activity']),
//                   subtitle: Text(item['time']),
//                   trailing: const Icon(Icons.drag_handle),
//                 ),
//             ],
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           final result = await Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AddItineraryScreen(tripId: widget.tripId),
//             ),
//           );
//           if (result == true) _fetchItineraries();
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }
