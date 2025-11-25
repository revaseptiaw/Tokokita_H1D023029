// lib/ui/produk_form.dart

import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/bloc/produk_bloc.dart'; // Impor bloc
import 'package:tokokita/helpers/warning_dialog.dart'; // Impor dialog
// Import http package (pastikan sudah ditambahkan di pubspec.yaml)
// import 'package:http/http.dart' as http;

// ignore: must_be_immutable
class ProdukForm extends StatefulWidget {
  Produk? produk;
  ProdukForm({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukFormState createState() => _ProdukFormState();
}

class _ProdukFormState extends State<ProdukForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String judul = "TAMBAH PRODUK rere";
  String tombolSubmit = "SIMPAN";
  final _kodeProdukTextboxController = TextEditingController();
  final _namaProdukTextboxController = TextEditingController();
  final _hargaProdukTextboxController = TextEditingController();
  bool isUpdateMode = false;

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.produk != null) {
      isUpdateMode = true;
      setState(() {
        judul = "UBAH PRODUK rere";
        tombolSubmit = "UBAH";
        _kodeProdukTextboxController.text = widget.produk!.kodeProduk!;
        _namaProdukTextboxController.text = widget.produk!.namaProduk!;
        _hargaProdukTextboxController.text = widget.produk!.hargaProduk
            .toString();
      });
    } else {
      isUpdateMode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(judul)),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _kodeProdukTextField(),
                _namaProdukTextField(),
                _hargaProdukTextField(),
                _buttonSubmit(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Membuat Textbox Kode Produk
  Widget _kodeProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Kode Produk"),
      keyboardType: TextInputType.text,
      controller: _kodeProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Kode Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Nama Produk
  Widget _namaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Nama Produk"),
      keyboardType: TextInputType.text,
      controller: _namaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Nama Produk harus diisi";
        }
        return null;
      },
    );
  }

  // Membuat Textbox Harga Produk
  Widget _hargaProdukTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: "Harga"),
      keyboardType: TextInputType.number,
      controller: _hargaProdukTextboxController,
      validator: (value) {
        if (value!.isEmpty) {
          return "Harga harus diisi";
        }
        // Tambahkan validasi angka jika perlu:
        if (int.tryParse(value) == null) {
          return "Harga harus berupa angka";
        }
        return null;
      },
    );
  }

  // Membuat Tombol Simpan/Ubah
  Widget _buttonSubmit() {
    return ElevatedButton(
      // Ganti OutlinedButton ke ElevatedButton agar bisa menampilkan CircularProgressIndicator
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 40),
      ),
      child: (isLoading)
          ? const CircularProgressIndicator(color: Colors.white)
          : Text(tombolSubmit),
      onPressed: isLoading
          ? null
          : () {
              // Nonaktifkan tombol saat loading
              if (_formKey.currentState!.validate()) {
                submitData();
              }
            },
    );
  }

  void submitData() async {
    // Pastikan tombol tidak diklik ganda
    if (isLoading) return;

    setState(() {
      isLoading = true;
    });

    Produk produk = Produk(
      id: isUpdateMode ? widget.produk!.id : null,
      kodeProduk: _kodeProdukTextboxController.text,
      namaProduk: _namaProdukTextboxController.text,
      hargaProduk: int.parse(_hargaProdukTextboxController.text),
    );

    try {
      if (isUpdateMode) {
        await ProdukBloc.updateProduk(produk: produk); // Panggilan ke bloc
      } else {
        await ProdukBloc.createProduk(produk: produk); // Panggilan ke bloc
      }
      // Berhasil, kembali ke halaman List Produk
      Navigator.pop(context);
    } catch (e) {
      // Tampilkan pesan error jika koneksi/API gagal
      showDialog(
        context: context,
        builder: (BuildContext context) => WarningDialog(
          description:
              "Gagal ${isUpdateMode ? 'mengubah' : 'menambah'} produk. Pastikan API/Server jalan. Error: $e",
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
