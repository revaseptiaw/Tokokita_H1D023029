import 'package:flutter/material.dart';
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/ui/produk_detail.dart';
import 'package:tokokita/ui/produk_form.dart';
import 'package:tokokita/bloc/produk_bloc.dart'; // <<< Tambahkan impor ini

class ProdukPage extends StatefulWidget {
  const ProdukPage({Key? key}) : super(key: key);

  @override
  _ProdukPageState createState() => _ProdukPageState();
}

class _ProdukPageState extends State<ProdukPage> {
  // Tambahkan: Future untuk menyimpan hasil pemanggilan API
  late Future<List<Produk>> _listProduk;

  @override
  void initState() {
    super.initState();
    // Panggil fungsi API saat halaman dimuat
    _listProduk = ProdukBloc.getProduks();
  }

  // Fungsi untuk me-refresh data setelah operasi CRUD
  Future<void> _refreshProdukList() async {
    setState(() {
      _listProduk = ProdukBloc.getProduks();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Produk rere'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              child: const Icon(Icons.add, size: 26.0),
              onTap: () async {
                // Navigasi ke form dan tunggu hasilnya
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProdukForm()),
                );
                _refreshProdukList(); // Panggil refresh setelah kembali dari form
              },
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: const [
            ListTile(
              title: Text('Logout'),
              trailing: Icon(Icons.logout),
              // onTap: () async { ... }
            ),
          ],
        ),
      ),
      // Ganti ListView statis dengan FutureBuilder
      body: FutureBuilder<List<Produk>>(
        future: _listProduk,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            // Tampilkan data dari API
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Produk produk = snapshot.data![index];
                // Kirim fungsi refresh ke ItemProduk
                return ItemProduk(
                  produk: produk,
                  refreshList: _refreshProdukList,
                );
              },
            );
          } else {
            return const Center(
              child: Text("Tidak ada data produk. Silakan tambahkan!"),
            );
          }
        },
      ),
    );
  }
}

class ItemProduk extends StatelessWidget {
  final Produk produk;
  final Function refreshList; // <<< Tambahkan properti ini

  const ItemProduk({
    Key? key,
    required this.produk,
    required this.refreshList,
  }) // <<< Inisialisasi properti
  : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        // Navigasi ke detail dan tunggu hasilnya
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProdukDetail(
              produk: produk,
              refreshList: refreshList, // <<< Teruskan fungsi refresh
            ),
          ),
        );
        refreshList(); // <<< Panggil refresh setelah kembali dari detail
      },
      child: Card(
        child: ListTile(
          title: Text(produk.namaProduk!),
          subtitle: Text("Harga: Rp. ${produk.hargaProduk.toString()}"),
        ),
      ),
    );
  }
}
