// lib/bloc/produk_bloc.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tokokita/model/produk.dart';
import 'package:tokokita/helpers/api_url.dart';

class ProdukBloc {
  // 1. Fungsi untuk List Produk (GET)
  static Future<List<Produk>> getProduks() async {
    final response = await http.get(Uri.parse(ApiUrl.listProduk));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);

      // Mengatasi kasus List kosong dari API (misalnya API mengembalikan data: false)
      if (body['data'] is bool && !body['data']) {
        return [];
      }

      List<dynamic> listData = body['data'];
      List<Produk> produks = listData.map((e) => Produk.fromJson(e)).toList();
      return produks;
    } else {
      throw Exception('Gagal memuat list produk');
    }
  }

  // 2. Fungsi untuk Create Produk (POST)
  static Future<Produk> createProduk({Produk? produk}) async {
    String apiUrl = ApiUrl.listProduk;

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "kode_produk": produk!.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk,
      }),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Produk.fromJson(body['data']);
    } else {
      throw Exception('Gagal menambah produk');
    }
  }

  // 3. Fungsi untuk Update Produk (PUT)
  static Future<Produk> updateProduk({Produk? produk}) async {
    // URL untuk update menggunakan produk/{id}
    String apiUrl = "${ApiUrl.listProduk}/${produk!.id}";

    final response = await http.put(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "kode_produk": produk.kodeProduk,
        "nama_produk": produk.namaProduk,
        "harga": produk.hargaProduk,
      }),
    );

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return Produk.fromJson(body['data']);
    } else {
      throw Exception('Gagal mengubah produk');
    }
  }

  // 4. Fungsi untuk Delete Produk (DELETE)
  static Future<bool> deleteProduk({required int id}) async {
    String apiUrl = "${ApiUrl.listProduk}/$id";
    final response = await http.delete(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      return body['status'] as bool;
    } else {
      throw Exception('Gagal menghapus produk');
    }
  }
}
