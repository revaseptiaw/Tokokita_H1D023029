# README Aplikasi Tokokita

**Nama:** Reva Septia Wulandari  
**NIM:** H1D023029  
**Shift Baru:** F  

---

## Deskripsi Aplikasi

Aplikasi Flutter Tokokita adalah aplikasi manajemen produk sederhana yang terhubung dengan REST API (CodeIgniter 4). Aplikasi ini memungkinkan pengguna untuk:

- Melakukan Registrasi dan Login pengguna.

- Melihat daftar produk (Kode Produk, Nama Produk, Harga).

- Menambah produk baru.

- Mengubah data produk.

- Menghapus produk.

- Logout dari sistem.

---

## Proses Login

### a. Mengisi Form Login
-<img width="498" height="487" alt="image" src="https://github.com/user-attachments/assets/06b50ff1-b3c4-44d9-ba64-7a535e4e8c15" />
- Penjelasan:
User memasukkan email dan password. Aplikasi memvalidasi input, lalu mengirim request menggunakan LoginBloc. Jika berhasil (status code 200), token dan User ID disimpan ke SharedPreferences menggunakan helper UserInfo, lalu navigasi diarahkan ke halaman List Produk.

- Kode Flutter:

```dart
LoginBloc.login(
    email: _emailTextboxController.text,
    password: _passwordTextboxController.text)
    .then((value) async {
        if (value.code == 200) {
            // Simpan Token & User ID
            await UserInfo().setToken(value.token.toString());
            await UserInfo().setUserID(int.parse(value.userID.toString()));
            
            // Pindah ke Halaman Produk
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const ProdukPage()));
        } else {
            showDialog(
                context: context,
                builder: (BuildContext context) => const WarningDialog(
                    description: "Login gagal, silahkan coba lagi",
                ));
        }
    }, onError: (error) {
        showDialog(
            context: context,
            builder: (BuildContext context) => const WarningDialog(
                description: "Login gagal, silahkan coba lagi",
            ));
    });
```

### b. Popup Login Berhasil / Gagal
-<img width="501" height="630" alt="image" src="https://github.com/user-attachments/assets/6b47c4cb-4186-4514-b019-6ee06a8456ae" />
- Penjelasan:  
 Jika login gagal, muncul popup menampilkan error dari backend. Jika berhasil, maka akan muncul popup berhasil.

## Proses CRUD Produk

### a.Menambah Data Produk
-<img width="496" height="604" alt="image" src="https://github.com/user-attachments/assets/c0eec7f7-f036-4d01-8b38-cb8190fa89be" />
- Penjelasan:  
Pada ProdukForm, jika statusnya tambah, user mengisi Kode Produk, Nama, dan Harga. Data dikirim via ProdukBloc.addProduk. Jika sukses, kembali ke list produk.
- Kode Flutter:

```dart
simpan() {
  setState(() { _isLoading = true; });
  
  Produk createProduk = Produk(id: null);
  createProduk.kodeProduk = _kodeProdukTextboxController.text;
  createProduk.namaProduk = _namaProdukTextboxController.text;
  createProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.addProduk(produk: createProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage()));
  }, onError: (error) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
        ));
  });
  setState(() { _isLoading = false; });
}
```

### b. Menampilkan Data Produk
-<img width="496" height="598" alt="image" src="https://github.com/user-attachments/assets/6a441081-d613-4b93-b26c-519e8b494e92" />
- Penjelasan:  
Halaman ProdukPage menggunakan FutureBuilder untuk memanggil ProdukBloc.getProduks(). Data yang diterima (List) ditampilkan menggunakan widget ListView.builder.
- Kode Flutter:
```dart
body: FutureBuilder<List<Produk>>(
  future: ProdukBloc.getProduks(),
  builder: (context, snapshot) {
    if (snapshot.hasError) print(snapshot.error);
    return snapshot.hasData
        ? ListProduk(list: snapshot.data)
        : const Center(child: CircularProgressIndicator());
  },
),
```

### c. Mengedit Data Produk
-<img width="487" height="589" alt="image" src="https://github.com/user-attachments/assets/ccac9697-9757-40f0-921e-3475b8d04a74" />
- Penjelasan:  
Saat masuk ke ProdukForm dengan membawa data produk, form akan terisi otomatis (isUpdate). Saat tombol UBAH ditekan, fungsi ubah() dipanggil untuk mengirim data revisi ke API.
- Kode Flutter:

```dart
ubah() {
  setState(() { _isLoading = true; });
  
  Produk updateProduk = Produk(id: widget.produk!.id!);
  updateProduk.kodeProduk = _kodeProdukTextboxController.text;
  updateProduk.namaProduk = _namaProdukTextboxController.text;
  updateProduk.hargaProduk = int.parse(_hargaProdukTextboxController.text);
  
  ProdukBloc.updateProduk(produk: updateProduk).then((value) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => const ProdukPage()));
  }, onError: (error) {
    showDialog(
        context: context,
        builder: (BuildContext context) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
        ));
  });
  setState(() { _isLoading = false; });
}
```

### d. Menghapus Data Produk
-<img width="341" height="411" alt="image" src="https://github.com/user-attachments/assets/9f39b552-fb9b-4a0e-84c6-df071a0beeaa" />
- Penjelasan:  
Pada halaman ProdukDetail, tombol DELETE memicu confirmHapus. Jika user memilih "Ya", ProdukBloc.deleteProduk dipanggil berdasarkan ID produk.
- Kode Flutter
```Dart
void confirmHapus() {
  AlertDialog alertDialog = AlertDialog(
    content: const Text("Yakin ingin menghapus data ini?"),
    actions: [
      OutlinedButton(
        child: const Text("Ya"),
        onPressed: () {
          ProdukBloc.deleteProduk(id: int.parse(widget.produk!.id!)).then(
              (value) => {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const ProdukPage()))
              }, onError: (error) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                        description: "Hapus gagal, silahkan coba lagi",
                    ));
              });
        },
      ),
      OutlinedButton(
        child: const Text("Batal"),
        onPressed: () => Navigator.pop(context),
      )
    ],
  );
  showDialog(builder: (context) => alertDialog, context: context);
}
```
