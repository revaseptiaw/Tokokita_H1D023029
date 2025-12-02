import 'package:flutter/material.dart';
import 'package:tokokita/bloc/login_bloc.dart';
import 'package:tokokita/helpers/user_info.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/ui/registrasi_page.dart';
import 'package:tokokita/widget/warning_dialog.dart';

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
      appBar: AppBar(title: const Text('Login')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _emailTextField(),
                _passwordTextField(),
                const SizedBox(height: 20),
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

  // Textbox Email
  Widget _emailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Email"),
      keyboardType: TextInputType.emailAddress,
      controller: _emailTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return 'Email harus diisi';
        }

        // Regex email aman
        String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
        RegExp regex = RegExp(pattern);
        if (!regex.hasMatch(value)) {
          return "Email tidak valid";
        }

        return null;
      },
    );
  }

  // Textbox Password
  Widget _passwordTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Password"),
      obscureText: true,
      controller: _passwordTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Password harus diisi";
        }
        if (value.length < 6) {
          return "Password minimal 6 karakter";
        }
        return null;
      },
    );
  }

  // Tombol Login
  Widget _buttonLogin() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          if (!_isLoading) _submit();
        }
      },
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Text("Login"),
    );
  }

  // Submit Login
  void _submit() {
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    LoginBloc.login(
          email: _emailTextboxController.text,
          password: _passwordTextboxController.text,
        )
        .then((value) async {
          if (value.code == 200) {
            await UserInfo().setToken(value.token.toString());
            await UserInfo().setUserID(int.parse(value.userID.toString()));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProdukPage()),
            );
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
              ),
            );
          }
        })
        .catchError((error) {
          print(error);
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => const WarningDialog(
              description: "Login gagal, silahkan coba lagi",
            ),
          );
        })
        .whenComplete(() {
          setState(() {
            _isLoading = false;
          });
        });
  }

  // Menu Registrasi
  Widget _menuRegistrasi() {
    return Center(
      child: TextButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RegistrasiPage()),
          );
        },
        child: const Text("Registrasi"),
      ),
    );
  }
}
