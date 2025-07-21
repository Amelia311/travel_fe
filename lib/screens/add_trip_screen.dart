import 'package:flutter/material.dart';
import '../services/trip_service.dart'; // panggil API ke backend Laravel

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({super.key});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  DateTime? selectedDate;

  void _submit() async {
    if (_formKey.currentState!.validate() && selectedDate != null) {
      final success = await TripService.createTrip(title, selectedDate!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Trip berhasil ditambahkan!'))
        );
        setState(() {
          title = '';
          selectedDate = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan trip!'))
        );
      }
    }
  }

  Future<void> _pickDate() async {
    final DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Trip')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Judul Trip"),
                onChanged: (val) => title = val,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(selectedDate == null
                      ? "Pilih Tanggal"
                      : "Tanggal: ${selectedDate!.toLocal()}".split(' ')[0]),
                  const SizedBox(width: 12),
                  ElevatedButton(onPressed: _pickDate, child: const Text("Pilih")),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Tambah Trip")),
            ],
          ),
        ),
      ),
    );
  }
}
