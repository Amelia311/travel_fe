import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '', email = '', password = '';

void _submit() async {
  if (_formKey.currentState!.validate()) {
    final success = await AuthService.register(name, email, password);
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi berhasil!"))
      );
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registrasi gagal!"))
      );
    }
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: "Name"),
                onChanged: (val) => name = val,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (val) => email = val,
                validator: (val) => val!.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Password"),
                obscureText: true,
                onChanged: (val) => password = val,
                validator: (val) => val!.length < 6 ? 'Min 6 karakter' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _submit, child: const Text("Register")),
            ],
          ),
        ),
      ),
    );
  }
}
