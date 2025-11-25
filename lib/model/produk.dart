class Produk {
  String? id;
  String? kodeProduk;
  String? namaProduk;
  var hargaProduk;

  Produk({this.id, this.kodeProduk, this.namaProduk, this.hargaProduk});

  factory Produk.fromJson(Map<String, dynamic> obj) {
    return Produk(
      id: obj['id'].toString(), // Pastikan ID diubah ke String
      kodeProduk: obj['kode_produk'],
      namaProduk: obj['nama_produk'],
      hargaProduk: obj['harga'],
    );
  }
}
