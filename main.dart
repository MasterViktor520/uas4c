import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:sim_unugiri/screens/dosen_home_screen.dart';
import 'package:sim_unugiri/screens/mahasiswa_home_screen.dart';
import 'package:sim_unugiri/screens/tendik_home_screen.dart';

enum ImageType { asset, network }

class ImageViewer extends StatelessWidget {
  final String imagePath;
  final ImageType imageType;
  final double width;
  final double height;
  final BoxFit boxFit;
  final IconData errorIcon;
  final Color errorIconColor;
  final Color imageColor;
  final Alignment alignment;
  final double topLeftRadius;
  final double topRightRadius;
  final double bottomLeftRadius;
  final double bottomRightRadius;

  const ImageViewer({
    Key? key,
    required this.imagePath,
    required this.imageType,
    this.width = 100,
    this.height = 100,
    this.boxFit = BoxFit.cover,
    this.errorIcon = Icons.error,
    this.errorIconColor = Colors.red,
    this.imageColor = Colors.transparent,
    this.alignment = Alignment.center,
    this.topLeftRadius = 0,
    this.topRightRadius = 0,
    this.bottomLeftRadius = 0,
    this.bottomRightRadius = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(topLeftRadius),
        topRight: Radius.circular(topRightRadius),
        bottomLeft: Radius.circular(bottomLeftRadius),
        bottomRight: Radius.circular(bottomRightRadius),
      ),
      child: imageType == ImageType.asset
          ? Image.asset(
              imagePath,
              width: width,
              height: height,
              fit: boxFit,
              color: imageColor,
            )
          : Image.network(
              imagePath,
              width: width,
              height: height,
              fit: boxFit,
              color: imageColor,
              errorBuilder: (context, error, stackTrace) {
                return Icon(errorIcon, color: errorIconColor);
              },
            ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String _message = '';

  Future<void> _login() async {
    final response = await http.get(Uri.parse('https://masterviktor520.github.io/host_api/login.json'));

    if (response.statusCode == 200) {
      List users = json.decode(response.body);
      String username = _usernameController.text;
      String password = _passwordController.text;

      bool isValid = false;
      String role = '';

      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          isValid = true;
          role = user['role'];
          break;
        }
      }

      if (isValid) {
        setState(() {
          _message = 'Login Telah Berhasil sebagai: $role';
        });
        _navigateToHome(role);
      } else {
        setState(() {
          _message = 'username atau password salah';
        });
      }
    } else {
      setState(() {
        _message = 'Failed to load user data';
      });
    }
  }

  void _navigateToHome(String role) {
    Widget screen;

    switch (role) {
      case 'dosen':
        screen = DosenHomeScreen();
        break;
      case 'mahasiswa':
        screen =  MainNavigationPage();
        break;
      case 'tendik':
        screen = MainScreen();
        break;
      default:
        screen = const LoginPage(); // Fallback to LoginPage if role is not recognized
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
      Icon(Icons.phone, color: Colors.black),
      SizedBox(width: 8),
      Text('(0353) 887341', style: TextStyle(color: Colors.black)),
      Spacer(),
      Icon(Icons.email, color: Colors.black),
      SizedBox(width: 8),
      Text('unugiri.bjn@gmail.com', style: TextStyle(color: Colors.black)),
          ],
            ),

              const SizedBox(height: 20),
              Container(
                color: Colors.green,
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Text(
                      'Selamat Datang',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'di Sistem Informasi Manajemen Universitas Nahdlatul Ulama Sunan Giri',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Image.asset('assets/unugiri.jpeg', height: 150),
              const SizedBox(height: 20),
              TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Password',
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: _login,
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _message,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 20),
              const Text(
                '© ILHAM & ALI.',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
