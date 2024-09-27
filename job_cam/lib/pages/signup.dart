// ignore_for_file: avoid_print

import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'dashboard_page.dart';

// SignupModel to handle the state
class SignupModel extends ChangeNotifier {
  String _name = '';
  int _age = 0;
  String _email = '';
  String _password = '';

  String get name => _name;
  int get age => _age;
  String get email => _email;
  String get password => _password;

  void setName(String name) {
    _name = name;
    notifyListeners();
  }

  void setAge(int age) {
    _age = age;
    notifyListeners();
  }

  void setEmail(String email) {
    _email = email;
    notifyListeners();
  }

  void setPassword(String password) {
    _password = password;
    notifyListeners();
  }

  void signup() {
    print('Name: $_name');
    print('Age: $_age');
    print('Email: $_email');
    print('Password: $_password');
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  late VideoPlayerController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/signup_video.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SignupModel(),
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (_controller.value.isInitialized)
              FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              )
            else
              const Center(child: CircularProgressIndicator()),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: SignupForm(formKey: _formKey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const SignupForm({super.key, required this.formKey});

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final signupModel = Provider.of<SignupModel>(context);

    return Form(
        key: widget.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    'SignUp ',
                    textStyle: TextStyle(
                      fontSize: 35.0,
                      fontFamily: GoogleFonts.blackOpsOne().fontFamily,
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                    speed: const Duration(milliseconds: 100),
                  ),
                ],
                isRepeatingAnimation: false,
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Name',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
              onSaved: (value) => signupModel.setName(value!),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Age',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid age';
                }
                return null;
              },
              onSaved: (value) => signupModel.setAge(int.parse(value!)),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Company Email',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your company email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              onSaved: (value) => signupModel.setEmail(value!),
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                hintText: 'Password',
                filled: true,
                fillColor: Colors.white.withOpacity(0.7),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                ),
              ),
              obscureText: _obscurePassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
              onSaved: (value) => signupModel.setPassword(value!),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  widget.formKey.currentState!.save();
                  signupModel.signup();
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text('Sign Up'),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.1, // 10% of screen width
                ),
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DashboardPage(),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min, // shrink wrap the row
                    children: [
                      Text(
                        'Login ',
                        style: TextStyle(color: Colors.white),
                      ),
                      Icon(Icons.login, color: Colors.white),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
