import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    TendikHomeScreen(),
    StudentListScreen(),
    TendikScreen(),
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
        title: Text('LAYANAN TENDIK UNUGIRI'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tendik Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Daftar Mahasiswa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.data_usage),
            label: 'Keaktifan Dosen',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TendikHomeScreen extends StatefulWidget {
  @override
  _TendikHomeScreenState createState() => _TendikHomeScreenState();
}

class _TendikHomeScreenState extends State<TendikHomeScreen> {
  Future<List<Map<String, dynamic>>> fetchSubmissions() async {
    final response = await http.get(Uri.parse('http://192.168.65.131:3000/submissions'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data
          .map((item) => item as Map<String, dynamic>)
          .where((item) => item['nim'] != null && item['name'] != null) // Filter data yang tidak lengkap
          .toList();
    } else {
      throw Exception('Tidak ada data');
    }
  }

  void _deleteSubmission(BuildContext context, String nim) async {
    try {
      final response = await http.delete(
        Uri.parse('http://192.168.65.131:3000/delete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({'nim': nim}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus')),
        );
        // Refresh the list
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (BuildContext context) => TendikHomeScreen()),
        );
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
        title: Text('Tendik Home'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: fetchSubmissions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Failed to load submissions'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No submissions found'));
          } else {
            final submissions = snapshot.data!;
            return ListView.builder(
              itemCount: submissions.length,
              itemBuilder: (context, index) {
                final item = submissions[index];
                return ListTile(
                  title: Text(item['name']),
                  subtitle: Text('NIM: ${item['nim']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultScreen(data: item),
                      ),
                    );
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _deleteSubmission(context, item['nim']);
                    },
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
        body: jsonEncode({'nim': data['nim']}),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data berhasil dihapus')),
        );
        Navigator.popUntil(context, (route) => route.isFirst);
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
            GestureDetector(
              onTap: () {
                _launchURL(data['link']);
              },
              child: Text(
                'Link: ${data['link']}',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
            Text('Hari: ${data['day']}'),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Hapus', style: TextStyle(color: Colors.red)),
              onPressed: () {
                _deleteData(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  @override
  _StudentListScreenState createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  List<dynamic> students = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  Future<void> fetchStudents() async {
    final response = await http.get(Uri.parse('https://masterviktor520.github.io/host_api/layanan.json'));
    if (response.statusCode == 200) {
      setState(() {
        students = json.decode(response.body);
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load students');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar mahasiswa'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                final student = students[index];
                return ListTile(
                  title: Text(student['name']),
                  subtitle: Text('NIM: ${student['nim']} | Jurusan: ${student['jurusan']} | Kelas: ${student['class']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.message),
                    onPressed: () => _launchWhatsApp(student['whatsapp']),
                  ),
                );
              },
            ),
    );
  }

  void _launchWhatsApp(String phone) async {
    final url = 'https://wa.me/$phone';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}

class TendikScreen extends StatelessWidget {
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://192.168.65.131:4000/api/tendik'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Gagal menemukan data');
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
        title: Text('Pratikum Tendik Data'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var item = snapshot.data![index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Nama: ${item['name']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('NIM: ${item['nim']}'),
                        Text('Kelas: ${item['className']}'), // Renamed from 'class' to 'className'
                        Text('Prodi: ${item['prodi']}'),
                        Text('Keterangan: ${item['keterangan']}'),
                        Text('Hari: ${item['day']}'),
                        GestureDetector(
                          onTap: () => _launchURL(item['link']),
                          child: Text(
                            'Link: ${item['link']}',
                            style: TextStyle(
                              color: Colors.blue,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
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
