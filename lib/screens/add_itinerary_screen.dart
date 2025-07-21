// import 'package:flutter/material.dart';
// import '../services/itinerary_service.dart';

// class AddItineraryScreen extends StatefulWidget {
//   final int tripId;

//   AddItineraryScreen({required this.tripId});

//   @override
//   _AddItineraryScreenState createState() => _AddItineraryScreenState();
// }

// class _AddItineraryScreenState extends State<AddItineraryScreen> {
//   final _formKey = GlobalKey<FormState>();
//   String _activity = '';
//   String _time = '';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Tambah Aktivitas")),
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Aktivitas'),
//                 onSaved: (value) => _activity = value ?? '',
//                 validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Waktu (contoh: 09:00)'),
//                 onSaved: (value) => _time = value ?? '',
//                 validator: (value) => value == null || value.isEmpty ? 'Wajib diisi' : null,
//               ),
//               SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   if (_formKey.currentState!.validate()) {
//                     _formKey.currentState!.save();
//                     final success = await ItineraryService.addItinerary(widget.tripId, _activity, _time);
//                     if (success) {
//                       Navigator.pop(context, true);
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal menambahkan")));
//                     }
//                   }
//                 },
//                 child: Text("Simpan"),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
