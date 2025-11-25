// lib/helpers/api_url.dart

class ApiUrl {
  // Ganti '10.0.2.2' dengan IP Address komputer Anda
  // jika menggunakan perangkat fisik. '10.0.2.2' adalah alias emulator Android.
  static const String baseUrl = "http://172.16.7.2/toko_api/public";

  static const String registrasi = "$baseUrl/registrasi";
  static const String login = "$baseUrl/login";
  static const String listProduk = "$baseUrl/produk";
}
