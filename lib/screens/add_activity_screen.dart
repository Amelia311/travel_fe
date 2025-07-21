import 'package:flutter/material.dart';
import '../services/itinerary_service.dart';

class AddActivityScreen extends StatefulWidget {
  final int tripId;

  const AddActivityScreen({required this.tripId});

  @override
  _AddActivityScreenState createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _activityController = TextEditingController();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tambah Aktivitas")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _activityController,
                decoration: const InputDecoration(labelText: "Nama Aktivitas"),
                validator: (value) => value!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 10),
              ListTile(
                title: Text(_selectedDay == null
                    ? "Pilih Hari"
                    : "Hari: ${_selectedDay!.toIso8601String().split('T')[0]}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2023),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) {
                    setState(() => _selectedDay = picked);
                  }
                },
              ),
              ListTile(
                title: Text(_selectedTime == null
                    ? "Pilih Waktu"
                    : "Jam: ${_selectedTime!.format(context)}"),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() => _selectedTime = picked);
                  }
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate() &&
                      _selectedDay != null &&
                      _selectedTime != null) {
                    final timeFormatted = "${_selectedTime!.hour.toString().padLeft(2, '0')}:${_selectedTime!.minute.toString().padLeft(2, '0')}";
                    final success = await ItineraryService.addItinerary({
                      "trip_id": widget.tripId,
                      "activity": _activityController.text,
                      "day": _selectedDay!.toIso8601String().split('T')[0],
                      "time": timeFormatted,
                    });

                    if (success) Navigator.pop(context, true);
                    else ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Gagal menambahkan aktivitas")),
                    );
                  }
                },
                child: const Text("Simpan"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
