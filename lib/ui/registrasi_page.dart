// lib/ui/registrasi_page.dart

import 'package:flutter/material.dart';
import 'package:tokokita/bloc/auth_bloc.dart'; // Impor AuthBloc
import 'package:tokokita/helpers/warning_dialog.dart'; // Impor Dialog

class RegistrasiPage extends StatefulWidget {
  const RegistrasiPage({Key? key}) : super(key: key);

  @override
  _RegistrasiPageState createState() => _RegistrasiPageState();
}

class _RegistrasiPageState extends State<RegistrasiPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _namaTextboxController = TextEditingController();
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Registrasi Rere")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _namaTextField(),
                _emailTextField(),
                _passwordTextField(),
                _passwordKonfirmasiTextField(),
                _buttonRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Nama
  Widget _namaTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama"),
      keyboardType: TextInputType.text,
      controller: _namaTextboxController,
      validator: (value) {
        if (value!.length < 3) {
          return "Nama harus diisi minimal 3 karakter";
        }
        return null;
      },
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        // validasi harus diisi
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }
        // VALIDASI EMAIL YANG DIPERBAIKI:
        Pattern pattern =
            r'^(([^<>()[\]\\.,;:\s@"]+(\.[^<>()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))';
        RegExp regex = RegExp(pattern.toString());

        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }
        return null;
      },
    );
  }

  // Membuat Textbox password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.length < 6) {
          return "Password harus diisi minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // membuat textbox Konfirmasi Password
  Widget _passwordKonfirmasiTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Konfirmasi Password"),
      keyboardType: TextInputType.text,
      obscureText: true,
      validator: (value) {
        if (value != _passwordTextboxController.text) {
          return "Konfirmasi Password tidak sama";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Registrasi
  Widget _buttonRegistrasi() {
    return ElevatedButton(
      child: (_isLoading)
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("Registrasi"),
      onPressed: (_isLoading)
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _submitRegistrasi();
              }
            },
    );
  }

  void _submitRegistrasi() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final registrasiResult = await AuthBloc.registrasi(
        _namaTextboxController.text,
        _emailTextboxController.text,
        _passwordTextboxController.text,
      );

      if (registrasiResult.status == true) {
        // Registrasi berhasil, kembali ke halaman login
        Navigator.pop(context);
      } else {
        // Registrasi gagal (email sudah terdaftar, dll.)
        showDialog(
          context: context,
          builder: (BuildContext context) => WarningDialog(
            description:
                registrasiResult.data ?? "Registrasi gagal, coba email lain.",
          ),
        );
      }
    } catch (e) {
      // Error koneksi
      showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
          description: "Gagal terhubung ke server: ${e.toString()}",
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
