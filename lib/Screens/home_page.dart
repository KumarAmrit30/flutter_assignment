import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testing_app/Widgets/qr_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen({super.key});

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  String? _qrData;
  String? _webViewContent;

  late final WebViewController _webViewController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _initWebView();
  }

  void _initWebView() {
    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white);
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('name', _nameController.text);
      await prefs.setString('email', _emailController.text);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User Data Saved Succesfully!'),
        ),
      );
      FocusScope.of(context).unfocus();
    }
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('name') ?? '';
      _emailController.text = prefs.getString('email') ?? '';
    });
  }

  Future<void> _scanQRCode() async {
    Navigator.of(context)
        .push(MaterialPageRoute(
      builder: (ctx) => const QRScannerPage(),
    ))
        .then((value) {
      if (value != null) {
        setState(() {
          _qrData = value;
        });
        _sendToMockAPI(value);
      }
    });
  }

  Future<void> _sendToMockAPI(String qrData) async {
    const mockResponse = '''
      <html>
        <head>
          <style>
            body { background-color: lightblue; }
            h1 { color: navy; }
          </style>
        </head>
        <body>
          <h1>Hello, World!</h1>
          <script>
            console.log('JavaScript is working!');
          </script>
        </body>
      </html>
    ''';

    await Future.delayed(
      const Duration(seconds: 1),
    );

    setState(() {
      _webViewContent = mockResponse;
      _webViewController.loadHtmlString(mockResponse);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Assignment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: _saveUserData,
                    child: const Text('Save Your Data'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _scanQRCode,
              child: const Text('Scan QR Code'),
            ),
            if (_qrData != null) ...{
              const SizedBox(height: 16),
              Text('Scanned QR Data: $_qrData'),
            },
            if (_webViewContent != null) ...{
              const SizedBox(
                height: 24,
              ),
              SizedBox(
                height: 300,
                child: WebViewWidget(controller: _webViewController),
              ),
            }
          ],
        ),
      ),
    );
  }
}
