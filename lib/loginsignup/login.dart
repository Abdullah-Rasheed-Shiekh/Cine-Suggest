import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/loginsignup/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  Future<void> login() async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      Navigator.of(context).pushReplacementNamed('/');
    } catch (e) {
      
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Login Failed', style: GoogleFonts.oswald()),
          content: Text(
            'Invalid credentials. Please try again.',
            style: GoogleFonts.oswald(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); 
              },
              child: Text('OK',
                  style: GoogleFonts.oswald(color: Colors.deepPurple)),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80), 

              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 19.0),
                  child: Image.asset(
                    'assests/logo.png', 
                    height: 150,
                    width: 150,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              
              Text(
                "Welcome To Cine Suggest",
                style: GoogleFonts.oswald(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromRGBO(255, 215, 0, 1.0),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Your Go To Movie Recommendation App",
                style: GoogleFonts.oswald(
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 40),

              
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    border: UnderlineInputBorder(),
                    hoverColor: Colors.white),
                keyboardType: TextInputType.emailAddress,
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    color: Colors.white,
                  ),
                  border: UnderlineInputBorder(),
                  hoverColor: Colors.white,
                ),
                obscureText: true,
                cursorColor: Colors.white,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: login,
                child: Text("Login",
                    style: GoogleFonts.oswald(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    )),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(double.infinity, 50),
                  backgroundColor: const Color.fromRGBO(212, 175, 55, 1.0),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignupPage()),
                  );
                },
                child: Text(
                  "Don't have an account? Sign up",
                  style: GoogleFonts.oswald(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
