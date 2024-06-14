import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:sim_unugiri/screens/feedback.dart';
import 'package:sim_unugiri/screens/denah.dart';

void main() {
  runApp(MahasiswaHomeScreen2());
}

class MahasiswaHomeScreen2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mahasiswa Menu',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainNavigationPage(), // Menggunakan MainNavigationPage sebagai halaman utama
    );
  }
}

class MainNavigationPage extends StatefulWidget {
  @override
  _MainNavigationPageState createState() => _MainNavigationPageState();
}

class _MainNavigationPageState extends State<MainNavigationPage> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    MahasiswaHomeScreen(),
    MateriHomeScreen(),
    DenahScreen(),
    FeedbackScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('LAYANAN MAHASISWA'),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Mahasiswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Materi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Denah',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Masukan',
          ),
        ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.black,
          onTap: _onItemTapped,
      ),
    );
  }
}

class MahasiswaHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text('Pilih Layanan'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ServiceSelectionScreen()),
              );
            },
          ),
          ElevatedButton(
            child: Text('Riwayat'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HistoryScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}

class ServiceSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pilih Layanan'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: Text('Surat'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaySelectionScreen(service: 'Surat')),
                );
              },
            ),
            ElevatedButton(
              child: Text('KHS'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DaySelectionScreen(service: 'KHS')),
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

      try {
        final response = await http.post(
          Uri.parse('http://192.168.65.131:3000/submit'),
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
          _saveToLocalHistory(data);
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

  void _saveToLocalHistory(Map<String, dynamic> data) {
    setState(() {
      HistoryData.history.add(data);
    });
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
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your NIM';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _classController,
                decoration: InputDecoration(labelText: 'Kelas'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your class';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prodiController,
                decoration: InputDecoration(labelText: 'Prodi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your prodi';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: InputDecoration(labelText: 'Keterangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter keterangan';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(labelText: 'Alamat'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Cantumkan alamat atau link';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text('Submit'),
                onPressed: _submitForm,
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
        Uri.parse('http://192.168.65.131:3000/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'nim': data['nim']}), // Assume NIM is the unique identifier
      );

      if (response.statusCode == 200) {
        // Remove data from local history
        HistoryData.history.removeWhere((element) => element['nim'] == data['nim']);

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
            Text('Link: ${data['link']}'),
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


class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: HistoryData.history.length,
          itemBuilder: (context, index) {
            final data = HistoryData.history[index];
            return ListTile(
              title: Text('${data['name']} - ${data['service']}'),
              subtitle: Text('${data['day']}'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ResultScreen(data: data)),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class HistoryData {
  static List<Map<String, dynamic>> history = [];
}

class MateriHomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: Center(
        child: ElevatedButton(
          child: Text('Lihat Materi'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MateriListScreen()),
            );
          },
        ),
      ),
    );
  }
}

class MateriListScreen extends StatelessWidget {
  Future<List<dynamic>> _fetchMateri() async {
    final response = await http.get(Uri.parse('http://192.168.65.131:4000/api/mahasiswa'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load materi');
    }
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Materi'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchMateri(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load materi'));
          } else {
            final materi = snapshot.data ?? [];
            return ListView.builder(
              itemCount: materi.length,
              itemBuilder: (context, index) {
                final item = materi[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item['keterangan']),
                      GestureDetector(
                        onTap: () => _launchURL(item['link']),
                        child: Text(
                          item['link'],
                          style: TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          }       
        },
      ),
    );
  }
}
