import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:medfast_go/pages/components/my_button.dart';
import 'package:medfast_go/pages/components/my_textfield.dart';
import 'package:medfast_go/pages/components/normal_tf.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _checkForToken();
  }

  Future<void> _checkForToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null) {
      final payload = decodeJwtPayload(token);
      final iat = payload['iat'];
      if (iat != null) {
        final issuedAt = DateTime.fromMillisecondsSinceEpoch(iat * 1000);
        final currentDateTime = DateTime.now();
        final expiryDate = issuedAt.add(const Duration(hours: 24));
        if (currentDateTime.isBefore(expiryDate)) {
          Navigator.of(context).pushReplacementNamed('/home');
          return;
        }
      }
    }
    // If no token, token is invalid, or token has expired, stay on login page.
  }

  Future<void> signUserIn() async {
    setState(() {
      loading = true;
    });

    final enteredEmail = emailController.text;
    final enteredPassword = passwordController.text;

    final url =
        Uri.parse('https://medrxapi.azurewebsites.net/api/Account/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': enteredEmail,
          'password': enteredPassword,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final token = responseData[
            'token']; // Assuming 'token' is the key in the response

        // Decode the JWT token
        final payload = decodeJwtPayload(token);

        // Extract the email address and pharmacy name
        final email = payload[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"];
        final pharmacyName = payload['PharmacyName'];

        // Save the token, email, and pharmacy name using SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('jwt_token', token);
        await prefs.setString('user_email', email);
        await prefs.setString('pharmacy_name', pharmacyName);

        Navigator.of(context).pushReplacementNamed('/bottom');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Invalid email or password'),
            duration: Duration(milliseconds: 1500),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred: $e'),
          duration: Duration(milliseconds: 1500),
        ),
      );
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  Map<String, dynamic> decodeJwtPayload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid token');
    }

    final payload = parts[1];
    final normalized = base64Url.normalize(payload);
    final resp = utf8.decode(base64Url.decode(normalized));
    final payloadMap = json.decode(resp);
    return payloadMap;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),
                    Text(
                      'Welcome back to MedRx',
                      style: TextStyle(
                        color: Colors.grey[700],
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 25),
                    normalTF(
                      controller: emailController,
                      hintText: 'Enter your email',
                      obscureText: false,
                    ),
                    const SizedBox(height: 10),
                    MyTextField(
                      controller: passwordController,
                      hintText: 'Enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed('/password');
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.grey[600],
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    MyButton(
                      onTap: loading ? null : signUserIn,
                      buttonText: "Login",
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Don\'t have an account?',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context)
                                .pushNamed('/registerpharmacy');
                          },
                          child: const Text(
                            'Register now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (loading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
