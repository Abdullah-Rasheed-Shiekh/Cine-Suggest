import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/loginsignup/login.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    setState(() {
      _isLoading = true;
    });

    try {
      
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      
      String uid = userCredential.user!.uid;

      
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'name': _nameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Signup successful! Please log in.')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      String errorMessage = 'An error occurred';
      if (e.code == 'email-already-in-use') {
        errorMessage = 'This email is already in use.';
      } else if (e.code == 'weak-password') {
        errorMessage = 'The password is too weak.';
      } else if (e.code == 'invalid-email') {
        errorMessage = 'The email is invalid.';
      }

      // Show a popup dialog with the error message
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Signup Failed', style: GoogleFonts.oswald()),
          content: Text(
            errorMessage,
            style: GoogleFonts.oswald(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: GoogleFonts.oswald(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Show a popup dialog for unexpected errors
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text('Signup Failed', style: GoogleFonts.oswald()),
          content: const Text(
            'An unexpected error occurred. Please try again.',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // Close the dialog
              },
              child: Text(
                'OK',
                style: GoogleFonts.oswald(color: Colors.deepPurple),
              ),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(212, 175, 55, 1.0),
        title: Text(
          'Sign Up',
          style: GoogleFonts.teko(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 80),
            // Heading for Create Account
            Text(
              'Create an Account',
              style: GoogleFonts.oswald(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(255, 215, 0, 1.0),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: UnderlineInputBorder(),
                hoverColor: Colors.white,
                labelStyle: TextStyle(color: Colors.white),
              ),
              cursorColor: Colors.white,
            ),
            const SizedBox(height: 10),

            // Email Text Field
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Email',
                  border: UnderlineInputBorder(),
                  hoverColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white)),
              cursorColor: Colors.white,
              
            ),
            const SizedBox(height: 10),

            
            TextField(
              controller: _passwordController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                  labelText: 'Password',
                  border: UnderlineInputBorder(),
                  hoverColor: Colors.white,
                  labelStyle: TextStyle(color: Colors.white)),
              obscureText: true,
              cursorColor: Colors.white,
            ),
            const SizedBox(height: 20),

            
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: _signup,
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.oswald(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: const Color.fromRGBO(212, 175, 55, 1.0),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
