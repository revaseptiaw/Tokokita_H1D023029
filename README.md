# Tokokita_H1D023029
Tugas 8 PERTEMUAN 10

Nama: Reva Septia Wulandari

NIM: H1D023029

Shift Baru: F

## Aplikasi Mobile TokoKita (CRUD Flutter & CodeIgniter 4)

Aplikasi ini menerapkan fitur CRUD (Create, Read, Update, Delete) untuk data Produk menggunakan Flutter sebagai frontend dan CodeIgniter 4 sebagai backend Restful API berbasis PHP/MySQL.
Aplikasi sudah dimodifikasi sehingga tombol submit berada di sebelah kanan dan judul halaman produk menyertakan nama panggilan "rere".

## 🏗️ Struktur Arsitektur (Layering)

Aplikasi menggunakan pola arsitektur Service / Bloc untuk memisahkan UI dan logika bisnis.

Struktur Layer

lib/ui → Berisi seluruh tampilan (pages, tombol, input).

lib/model → Berisi struktur data seperti Produk dan Login.

lib/bloc → Logika bisnis, HTTP request, dan validasi.

lib/helpers → Konfigurasi API (api_url.dart) dan utilities (user_info.dart).

### 1. Halaman List Produk (ProdukPage)

Halaman utama untuk menampilkan daftar produk dari API. Halaman ini juga berfungsi sebagai dashboard dan pusat akses CRUD.

Fungsi Utama

Mengambil list produk dengan ProdukBloc.getProduks.

Menggunakan FutureBuilder untuk loading/error handling.

Tombol + untuk membuka form tambah produk.

Drawer menu menyediakan fitur Logout.

Cuplikan Kode
```dart
return FutureBuilder<List<Produk>>(
  future: _listProduk,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
      return ListView.builder(
        itemCount: snapshot.data!.length,
        itemBuilder: (context, index) {
          Produk produk = snapshot.data![index];
          return ItemProduk(
            produk: produk,
            refreshList: _refreshProdukList,
          );
        },
      );
    }
  },
);
```

### 2. Halaman Detail Produk (ProdukDetail)

Halaman untuk menampilkan informasi lengkap produk serta tombol Update dan Delete.

Fungsi Utama

Menampilkan kodeProduk, namaProduk, dan hargaProduk.

Tombol EDIT membuka form update.

Tombol DELETE disertai dialog konfirmasi dan memanggil ProdukBloc.deleteProduk.

Cuplikan Kode
```dart
Widget _tombolHapusEdit() {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      OutlinedButton(/* ... */),
      OutlinedButton(
        child: const Text("DELETE"),
        onPressed: () => confirmHapus(),
      ),
    ],
  );
}

void confirmHapus() {
  ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then((value) {
    Navigator.pop(context);
    widget.refreshList();
    Navigator.pop(context);
  });
}
```

### 3. Halaman Form Produk (ProdukForm)

Form digunakan untuk Create dan Update produk (reusable form).

Fungsi Utama

Menentukan mode (tambah/update) menggunakan isUpdateMode.

Validasi input sebelum submit.

Tombol submit memanggil createProduk atau updateProduk.

Tombol diletakkan di sisi kanan.

Cuplikan Kode
```dart
Widget _buttonSubmit() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(tombolSubmit),
          onPressed: isLoading ? null : () {
            if (_formKey.currentState!.validate()) submitData();
          },
        ),
      ),
    ],
  );
}

void submitData() async {
  if (isUpdateMode) {
    await ProdukBloc.updateProduk(produk: produk);
  } else {
    await ProdukBloc.createProduk(produk: produk);
  }
  Navigator.pop(context);
}

```

### 4. Halaman Registrasi (RegistrasiPage)

Digunakan untuk mendaftarkan user baru.

Fungsi Utama

Validasi input: nama min 3 karakter, email valid, konfirmasi password.

Tombol registrasi memanggil AuthBloc.registrasi.

Tombol ditempatkan di kanan.

Cuplikan Kode
```dart
Widget _buttonRegistrasi() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 20),
        child: ElevatedButton(
          child: _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : const Text("Registrasi"),
          onPressed: _isLoading ? null : () {
            if (_formKey.currentState!.validate()) _submitRegistrasi();
          },
        ),
      ),
    ],
  );
}

void _submitRegistrasi() async {
  final result = await AuthBloc.registrasi(
    _namaTextboxController.text,
    // ...
  );
  if (result.status == true) {
    Navigator.pop(context);
  }
}
```

### 5. Halaman Login (LoginPage)

Halaman autentikasi pengguna.

Fungsi Utama

Tombol Login memanggil AuthBloc.login.

Jika berhasil, token dan userID disimpan pada shared_preferences.

Setelah login, user diarahkan ke ProdukPage.

Menyediakan link untuk registrasi.

### Halaman Login
<img width="492" height="350" alt="image" src="https://github.com/user-attachments/assets/b10a6eb9-4fb2-4853-99f9-103c614809e8" />


### Halaman Registrasi
<img width="495" height="365" alt="image" src="https://github.com/user-attachments/assets/d97c5b01-e67a-420d-a4fc-6b4b8f5d6329" />


### Halaman List Produk
<img width="791" height="390" alt="image" src="https://github.com/user-attachments/assets/0fb600d3-297f-4f94-ad52-9d6924dba177" />


### Halaman Tambah Produk
<img width="754" height="359" alt="image" src="https://github.com/user-attachments/assets/258ca702-16d6-47d9-b8bc-81b8470057d7" />


### Halaman Detail Produk
<img width="617" height="409" alt="image" src="https://github.com/user-attachments/assets/99701507-e3de-4098-aa72-e01bcdacbb58" />


### Halaman Ubah Produk
<img width="829" height="362" alt="image" src="https://github.com/user-attachments/assets/6cc9e7c4-8113-4725-b1e7-73ac606b3770" />






