# README Aplikasi Tokokita

**Nama:** Reva Septia Wulandari  
**NIM:** H1D023029  
**Shift Baru:** F  

---

## Deskripsi Aplikasi

Aplikasi Flutter **Tokokita** adalah aplikasi manajemen produk sederhana yang memungkinkan pengguna untuk:

- Menambahkan produk baru beserta detailnya (nama, harga, stok).  
- Melihat daftar produk yang telah ditambahkan.  
- Mengedit dan menghapus produk.  
- Menyimpan data produk secara lokal atau melalui API backend.  
- Mengatur preferensi tampilan atau tema (opsional).  

---

## Proses Login

### a. Mengisi Form Login
- <img width="498" height="487" alt="image" src="https://github.com/user-attachments/assets/06b50ff1-b3c4-44d9-ba64-7a535e4e8c15" />
- Penjelasan:  
  User memasukkan **email/username** dan **password**, lalu menekan tombol login. Data dikirim ke API backend untuk diverifikasi.

- Kode Flutter:

```dart
void _submitLogin() async {
  final response = await LoginBloc.login(
    email: _emailController.text,
    password: _passwordController.text,
  );
  if (response.statusCode == 200) {
    // Login berhasil
    Navigator.pushReplacementNamed(context, '/dashboard');
  } else {
    // Login gagal
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Login Gagal'),
        content: Text(response.message),
      ),
    );
  }
}
```

### b. Popup Login Berhasil / Gagal
-<img width="501" height="630" alt="image" src="https://github.com/user-attachments/assets/6b47c4cb-4186-4514-b019-6ee06a8456ae" />
- Penjelasan:  
 Jika login gagal, muncul popup menampilkan error dari backend. Jika berhasil, langsung diarahkan ke dashboard.

## 3 Proses CRUD Produk

### a.Menambah Data Produk
-<img width="496" height="604" alt="image" src="https://github.com/user-attachments/assets/c0eec7f7-f036-4d01-8b38-cb8190fa89be" />
- Penjelasan:  
  User mengisi nama produk, harga, dan stok → tekan tombol Tambah → POST request dikirim ke API backend.
- Kode Flutter:

```dart
void _submitTambahProduk() async {
  final response = await ProdukBloc.tambahProduk(
    nama: _namaController.text,
    harga: int.parse(_hargaController.text),
    stok: int.parse(_stokController.text),
  );
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Berhasil'), content: Text('Produk ditambahkan')),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Gagal'), content: Text(response.message)),
    );
  }
}
```

### b. Menampilkan Data Produk
-<img width="496" height="598" alt="image" src="https://github.com/user-attachments/assets/6a441081-d613-4b93-b26c-519e8b494e92" />
- Penjelasan:  
Data produk diambil dari backend → ditampilkan dalam list. Setiap item memiliki tombol Edit dan Hapus.
- Kode Flutter:
```dart
FutureBuilder(
  future: ProdukBloc.getProduk(),
  builder: (context, snapshot) {
    if (snapshot.hasData) {
      return ListView.builder(
        itemCount: snapshot.data.length,
        itemBuilder: (context, index) {
          final produk = snapshot.data[index];
          return ListTile(
            title: Text(produk.nama),
            subtitle: Text('Harga: ${produk.harga} | Stok: ${produk.stok}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(icon: Icon(Icons.edit), onPressed: () { /* edit */ }),
                IconButton(icon: Icon(Icons.delete), onPressed: () { /* delete */ }),
              ],
            ),
          );
        },
      );
    }
    return CircularProgressIndicator();
  },
)
```

### c. Mengedit Data Produk
-<img width="487" height="589" alt="image" src="https://github.com/user-attachments/assets/ccac9697-9757-40f0-921e-3475b8d04a74" />
- Penjelasan:  
 User mengubah field → tekan tombol Simpan → PUT/PATCH request dikirim ke API backend.
- Kode Flutter:

```dart
void _submitEditProduk(int id) async {
  final response = await ProdukBloc.editProduk(
    id: id,
    nama: _namaController.text,
    harga: int.parse(_hargaController.text),
    stok: int.parse(_stokController.text),
  );
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Berhasil'), content: Text('Produk diperbarui')),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Gagal'), content: Text(response.message)),
    );
  }
}
```

### d. Menghapus Data Produk
-<img width="341" height="411" alt="image" src="https://github.com/user-attachments/assets/9f39b552-fb9b-4a0e-84c6-df071a0beeaa" />
- Penjelasan:  
User menekan tombol Hapus → muncul popup konfirmasi → DELETE request dikirim ke API backend.
- Kode Flutter:

```dart
void _hapusProduk(int id) async {
  final response = await ProdukBloc.hapusProduk(id);
  if (response.statusCode == 200) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Berhasil'), content: Text('Produk dihapus')),
    );
  } else {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(title: Text('Gagal'), content: Text(response.message)),
    );
  }
}
```
