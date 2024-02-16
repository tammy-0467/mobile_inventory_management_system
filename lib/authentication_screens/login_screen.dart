import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/custom_styles/app_theme.dart';

import 'package:untitled/home_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //necessary variables
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLogin = true;
  String? errorMessage = '';

  //function for signing in a user with email & password
  Future signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to another screen upon successful login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // Handle sign-in errors
      setState(() {
        errorMessage = 'Error signing in: $e';
      });
      // print("Error signing in: $e");
    }
  }

  //function for creating a user with email & password
  Future createUserWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to another screen upon successful registration
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } catch (e) {
      // Handle registration errors
      setState(() {
        errorMessage = 'Error registering user: $e';
      });
      // print("Error registering user: $e");
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget _errorMessage(){
    return Text(errorMessage == '' ? '' : 'Hmm ? $errorMessage');
  }

  //a text field widget fn that requires a controller and title
  Widget _entryField(String title,
      TextEditingController controller,
      ) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: title
      ),
    );
  }

  //a submit button
  Widget _submitButton(){
    return ElevatedButton(
      //if user is logged in, calls the first function otherwise the second
      onPressed: isLogin ? signInWithEmailAndPassword : createUserWithEmailAndPassword,
      //if user is logged in, uses the first display text otherwise the second
      child: Text( isLogin ? 'Login' : 'Register'),
      style: ButtonStyle(
        minimumSize: MaterialStateProperty.all(Size(double.infinity, 0))
      ),
    );
  }

  //function used to change the value of the isLogin variable
  Widget _loginOrRegisterButton(){
    return TextButton(
      onPressed: (){
        setState(() {
          isLogin = !isLogin;
        });
      },
      //if user is logged in, calls the first display text otherwise the second
      child: Text(isLogin ? 'Register instead' : 'Login', style: appTheme.textTheme.bodyLarge),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 130.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 40),
                Text(
                  'Sign Up',
                  style: appTheme.textTheme.displaySmall
                ),
                SizedBox(height: 20),

                //email entry
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _entryField('Email', _emailController)
                ),
                Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _entryField('Password', _passwordController)
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _errorMessage(),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _submitButton(),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                    child: _loginOrRegisterButton()
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
