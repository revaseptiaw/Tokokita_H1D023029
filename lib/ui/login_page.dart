// lib/ui/login_page.dart

import 'package:flutter/material.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/ui/produk_page.dart'; // Navigasi ke halaman produk
import 'package:tokokita/bloc/auth_bloc.dart'; // Impor AuthBloc
import 'package:tokokita/helpers/warning_dialog.dart'; // Impor Dialog

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final _emailTextboxController = TextEditingController();
  final _passwordTextboxController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Rere')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                _buttonLogin(),
                const SizedBox(height: 30),
                _menuRegistrasi(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
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
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      child: (_isLoading)
          ? const CircularProgressIndicator(color: Colors.white)
          : const Text("Login"),
      onPressed: (_isLoading)
          ? null
          : () {
              if (_formKey.currentState!.validate()) {
                _submitLogin();
              }
            },
    );
  }

  // Fungsi submit login
  void _submitLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final loginResult = await AuthBloc.login(
        _emailTextboxController.text,
        _passwordTextboxController.text,
      );

      if (loginResult.status == true) {
        // Login berhasil, navigasi ke halaman produk
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProdukPage()),
        );
      } else {
        // Login gagal (email/password salah)
        showDialog(
          context: context,
          builder: (BuildContext context) =>
              const WarningDialog(description: "Email atau Password salah."),
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

  // Membuat menu untuk membuka halaman registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: InkWell(
        child: const Text("Registrasi", style: TextStyle(color: Colors.blue)),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
      ),
    );
  }
}
