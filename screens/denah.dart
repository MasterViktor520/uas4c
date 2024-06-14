import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(DenahScreen());
}

class DenahScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image Link Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String imageAsset = 'assets/map.jpg'; // Ubah dengan path gambar Anda
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://masterviktor520.github.io/host_api/denah.json'));
    if (response.statusCode == 200) {
      setState(() {
        data = jsonDecode(response.body);
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      body: data == null
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image.asset(
                      imageAsset, // Sesuaikan ukuran asli gambar tanpa terpotong
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _launchURL(); // Panggil fungsi untuk membuka link
                    },
                    child: Text('Buka Google Maps'),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: ListView.builder(
                      itemCount: data!['denah_ruang_kelas']['sections'].length,
                      itemBuilder: (context, index) {
                        var section = data!['denah_ruang_kelas']['sections'][index];
                        return ListTile(
                          title: Text('Label: ${section['label']}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Name: ${section['name']}'),
                              if (section['rooms'] != null)
                                Text('Rooms: ${section['rooms'].join(', ')}'),
                              if (section['features'] != null)
                                Text('Features: ${section['features'].join(', ')}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void _launchURL() async {
    const url = 'https://maps.app.goo.gl/7QmMLstKu1FdMwoq7'; // Ganti dengan URL yang diinginkan
    
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
