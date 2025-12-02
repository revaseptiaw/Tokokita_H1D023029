import 'dart:convert';
import 'package:tokokita/helpers/api.dart';
import 'package:tokokita/helpers/api_url.dart';
import 'package:tokokita/model/produk.dart';

class ProdukBloc {
  /// GET LIST PRODUK
  static Future<List<Produk>> getProduks() async {
    String apiUrl = ApiUrl.listProduk;

    var response = await Api().get(apiUrl);
    var jsonObj = json.decode(response.body);

    List<dynamic> listProduk = (jsonObj as Map<String, dynamic>)['data'];
    List<Produk> produks = [];

    for (var item in listProduk) {
      produks.add(Produk.fromJson(item));
    }

    return produks;
  }

  /// ADD PRODUK
  static Future<dynamic> addProduk({required Produk produk}) async {
    String apiUrl = ApiUrl.createProduk;

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    var response = await Api().post(apiUrl, body);
    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }

  /// UPDATE PRODUK
  static Future<dynamic> updateProduk({required Produk produk}) async {
    if (produk.id == null) {
      throw Exception("ID produk tidak boleh null saat update.");
    }

    String apiUrl = ApiUrl.updateProduk(int.parse(produk.id.toString()));
    print("URL Update: $apiUrl");

    var body = {
      "kode_produk": produk.kodeProduk,
      "nama_produk": produk.namaProduk,
      "harga": produk.hargaProduk.toString(),
    };

    print("Body : $body");

    var response = await Api().put(apiUrl, jsonEncode(body));
    var jsonObj = json.decode(response.body);

    return jsonObj['status'];
  }

  /// DELETE PRODUK
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = ApiUrl.deleteProduk(id);

    var response = await Api().delete(apiUrl);
    var jsonObj = json.decode(response.body);

    return (jsonObj as Map<String, dynamic>)['data'];
  }
}
