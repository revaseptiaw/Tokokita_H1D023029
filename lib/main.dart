// lib/main.dart

import 'package:flutter/material.dart';
import 'package:tokokita/ui/login_page.dart'; // Ganti ke login

void main() {
  // Pastikan widget Flutter diinisialisasi untuk shared_preferences
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Toko Kita',
      debugShowCheckedModeBanner: false,
      home: LoginPage(), // Dimulai dari halaman Login
    );
  }
}
