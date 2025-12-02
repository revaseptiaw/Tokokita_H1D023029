import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/ui/produk_page.dart';
import 'package:tokokita/bloc/produk_bloc.dart';
import 'package:tokokita/widget/warning_dialog.dart';

class ProdukDetail extends StatefulWidget {
  Produk? produk;

  ProdukDetail({Key? key, this.produk}) : super(key: key);

  @override
  _ProdukDetailState createState() => _ProdukDetailState();
}

class _ProdukDetailState extends State<ProdukDetail> {
  bool _isDeleting = false;

  @override
  Widget build(BuildContext context) {
    final p = widget.produk;

    if (p == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Produk rere')),
        body: const Center(child: Text("Data produk tidak tersedia")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk rere')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Kode : ${p.kodeProduk}",
              style: const TextStyle(fontSize: 20),
            ),
            Text(
              "Nama : ${p.namaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            Text(
              "Harga : Rp. ${p.hargaProduk}",
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            _tombolHapusEdit(p),
            if (_isDeleting) ...[
              const SizedBox(height: 16),
              const CircularProgressIndicator(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _tombolHapusEdit(Produk p) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        OutlinedButton(
          child: const Text("EDIT"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProdukForm(produk: p)),
            );
          },
        ),
        const SizedBox(width: 8),
        OutlinedButton(
          child: const Text("DELETE"),
          onPressed: () => confirmHapus(p),
        ),
      ],
    );
  }

  void confirmHapus(Produk p) {
    final alertDialog = AlertDialog(
      content: const Text("Yakin ingin menghapus data ini?"),
      actions: [
        OutlinedButton(
          child: const Text("Ya"),
          onPressed: () async {
            Navigator.pop(context);

            setState(() => _isDeleting = true);

            try {
              final id = p.id;
              if (id == null) throw Exception("ID produk kosong");

              await ProdukBloc.deleteProduk(id: int.parse(id.toString()));

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const ProdukPage()),
              );
            } catch (e) {
              showDialog(
                context: context,
                builder: (context) =>
                    WarningDialog(description: "Hapus gagal: ${e.toString()}"),
              );
            } finally {
              if (mounted) {
                setState(() => _isDeleting = false);
              }
            }
          },
        ),
        OutlinedButton(
          child: const Text("Batal"),
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alertDialog);
  }
}
