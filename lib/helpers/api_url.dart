class ApiUrl {
  static const String baseUrl =
      "http://172.16.7.2:8080"; // Ganti dengan IP komputer Rere

  // Auth
  static const String registrasi = '$baseUrl/registrasi';
  static const String login = '$baseUrl/login';

  // Produk
  static const String listProduk = '$baseUrl/produk';
  static const String createProduk = '$baseUrl/produk';

  static String updateProduk(int id) => '$baseUrl/produk/$id';
  static String showProduk(int id) => '$baseUrl/produk/$id';
  static String deleteProduk(int id) => '$baseUrl/produk/$id';
}
