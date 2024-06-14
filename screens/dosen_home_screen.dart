import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dosen App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: DosenHomeScreen(),
    );
  }
}

class DosenHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dosen Home'),
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Upload kegiatan'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ServiceSelectionScreen()),
            );
          },
        ),
      ),
    );
  }
}

class ServiceSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Kegiatan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Pratikum'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaySelectionScreen(service: 'Pratikum')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Materi'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaySelectionScreen(service: 'Materi')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class DaySelectionScreen extends StatelessWidget {
  final String service;

  DaySelectionScreen({required this.service});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Hari'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Senin'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Senin')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Selasa'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Selasa')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Rabu'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Rabu')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Kamis'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Kamis')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Jumat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Jumat')),
                );
              },
            ),
            ElevatedButton(
              child: Text('Sabtu'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataEntryScreen(service: service, day: 'Sabtu')),
                );
              },
            ),
            // Add more buttons for other days as needed
          ],
        ),
      ),
    );
  }
}

class DataEntryScreen extends StatefulWidget {
  final String service;
  final String day;

  DataEntryScreen({required this.service, required this.day});

  @override
  _DataEntryScreenState createState() => _DataEntryScreenState();
}

class _DataEntryScreenState extends State<DataEntryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nimController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _prodiController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'service': widget.service,
        'day': widget.day,
        'name': _nameController.text,
        'nim': _nimController.text,
        'class': _classController.text,
        'prodi': _prodiController.text,
        'keterangan': _keteranganController.text,
        'link': _alamatController.text,
      };

      String apiUrl;
      if (widget.service == 'Pratikum') {
        apiUrl = 'http://192.168.65.131:4000/api/tendik';
      } else {
        apiUrl = 'http://192.168.65.131:4000/api/mahasiswa';
      }

      try {
        final response = await http.post(
          Uri.parse(apiUrl),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Data berhasil di upload')),
          );
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ResultScreen(data: data)),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal mengupload data: ${response.reasonPhrase}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal mengupload data: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pengisian Data - ${widget.service} - ${widget.day}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan Nama';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan NIM';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _classController,
                decoration: InputDecoration(labelText: 'Kelas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan kelas yang diajar';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prodiController,
                decoration: InputDecoration(labelText: 'Prodi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan Prodi yang diajar';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tolong masukan keterangan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Link Drive Perkuliahan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cantumkan link google drive';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Upload'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final Map<String, dynamic> data;

  ResultScreen({required this.data});

  void _deleteData(BuildContext context) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.65.131:4000/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'nim': data['nim']}), // Assume NIM is the unique identifier
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus')),
        );
        Navigator.popUntil(context, (route) => route.isFirst); // Navigate back to home screen
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menghapus data: ${response.reasonPhrase}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menghapus data: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hasil Layanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Text('Nama: ${data['name']}'),
            Text('NIM: ${data['nim']}'),
            Text('Kelas: ${data['class']}'),
            Text('Prodi: ${data['prodi']}'),
            Text('Keterangan: ${data['keterangan']}'),
            Text('Alamat: ${data['link']}'),
            Text('Hari: ${data['day']}'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Edit'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DataEntryScreen(service: data['service'], day: data['day']),
                  ),
                );
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteData(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white, // Background color
                foregroundColor: Colors.red, // Text color
                side: BorderSide(color: Colors.red), // Border color
              ),
            ),
          ],
        ),
      ),
    );
  }
}
