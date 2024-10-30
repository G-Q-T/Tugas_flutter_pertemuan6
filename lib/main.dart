import 'package:flutter/material.dart';

void main() {
  runApp(AplikasiKontak());
}

class AplikasiKontak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Daftar Kontak'),
        ),
        body: KontakPage(),
      ),
    );
  }
}

class KontakPage extends StatefulWidget {
  @override
  _KontakPageState createState() => _KontakPageState();
}

class _KontakPageState extends State<KontakPage> {
  // List untuk menyimpan data kontak
  List<Map<String, String>> kontakList = [];

  // GlobalKey untuk mengelola form
  final _formKey = GlobalKey<FormState>();

  // Controller untuk mengelola input nama dan nomor telepon
  final TextEditingController namaController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();

  // Checkbox status untuk validasi tambah kontak
  bool _isTambahChecked = false;

  // Fungsi untuk menampilkan pemberitahuan jika checkbox belum dicentang
  void _showWarningDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Peringatan'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menambahkan kontak
  void _tambahKontak() {
    if (_formKey.currentState!.validate()) {
      if (!_isTambahChecked) {
        // Jika checkbox belum dicentang, tampilkan pemberitahuan
        _showWarningDialog(
            'Anda perlu mencentang checkbox terlebih dahulu untuk menambahkan kontak.');
      } else {
        setState(() {
          kontakList.add({
            'nama': namaController.text,
            'nomor': nomorController.text,
          });
        });
        // Reset input dan checkbox setelah menambahkan kontak
        namaController.clear();
        nomorController.clear();
        _isTambahChecked = false;
        Navigator.of(context)
            .pop(); // Menutup dialog setelah kontak ditambahkan
      }
    }
  }

  // Fungsi untuk menghapus kontak berdasarkan indeks
  void _hapusKontak(int index) {
    bool isHapusChecked = false; // Status checkbox hanya untuk dialog hapus

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus Kontak'),
          content: StatefulBuilder(
            // Menggunakan StatefulBuilder untuk memperbarui tampilan checkbox dalam dialog
            builder: (context, setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Apakah Anda yakin ingin menghapus kontak ini?'),
                  Row(
                    children: [
                      Checkbox(
                        value: isHapusChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            isHapusChecked = value ?? false;
                          });
                        },
                      ),
                      Text('Saya yakin untuk menghapus'),
                    ],
                  ),
                ],
              );
            },
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (!isHapusChecked) {
                  // Jika checkbox belum dicentang, tampilkan pemberitahuan
                  _showWarningDialog(
                      'Anda perlu mencentang checkbox terlebih dahulu untuk menghapus kontak.');
                } else {
                  setState(() {
                    kontakList.removeAt(index);
                  });
                  Navigator.of(context)
                      .pop(); // Menutup dialog setelah kontak dihapus
                }
              },
              child: Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog form tambah kontak
  void _showTambahKontakDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          // Menggunakan StatefulBuilder untuk memperbarui tampilan checkbox dalam dialog
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Tambah Kontak'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: namaController,
                      decoration: InputDecoration(
                        labelText: 'Nama',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nama tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: nomorController,
                      decoration: InputDecoration(
                        labelText: 'Nomor Telepon',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Nomor telepon tidak boleh kosong';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(
                          value: _isTambahChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isTambahChecked = value ?? false;
                            });
                          },
                        ),
                        Text('Saya setuju untuk menambahkan kontak ini'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                ElevatedButton(
                  onPressed: _tambahKontak,
                  child: Text('Tambah'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Batal'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: kontakList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: Icon(Icons.person),
                title: Text(kontakList[index]['nama']!),
                subtitle: Text(kontakList[index]['nomor']!),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    _hapusKontak(index);
                  },
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _showTambahKontakDialog,
            child: Text('Tambah Kontak'),
          ),
        ),
      ],
    );
  }
}
