import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(FeedbackScreen());
}

class FeedbackScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _sendFeedback() {
    if (_formKey.currentState!.validate()) {
      final feedback = _feedbackController.text;
      final phoneNumber = '62881027107840'; // Ganti dengan nomor WhatsApp yang dituju
      _launchWhatsApp(phoneNumber, feedback);
    }
  }

  void _launchWhatsApp(String phone, String message) async {
    final url = 'https://wa.me/$phone?text=${Uri.encodeComponent(message)}';
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _feedbackController,
                decoration: InputDecoration(labelText: 'Berikan Nilai Terhadap Aplikasi'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Maaf Teks Tidak Boleh Kosong';
                  }
                  return null;
                },
                maxLines: 5,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _sendFeedback,
                child: Text('Kirim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
