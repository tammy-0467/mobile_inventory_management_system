import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:untitled/custom_styles/app_theme.dart';

import 'package:untitled/home_screen.dart';
import 'package:wc_form_validators/wc_form_validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //necessary variables
  final _emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  String? _password = "";
  String? _confirmPassword = "";

  bool isLogin = true;
  String errorMessage = '';




  Widget _passwordField(String title,
      TextEditingController controller,
      bool obscure
      ) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: (value){
        setState(() {
          _password = value;
        });
      },
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose([
        Validators.required("Password is required"),
        Validators.patternString(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
            'Your password must contain 8 characters, including a digit, a special character, and an uppercase letter')
      ]),
      decoration: InputDecoration(
          labelText: title,
          errorMaxLines: 3
      ),
    );
  }

  Widget _confirmPasswordField(String title,
      TextEditingController controller,
      bool obscure
      ) {
    if(isLogin == true){
      return SizedBox.shrink();
    }
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      onChanged: (value){
        setState(() {
          _confirmPassword = value;
        });
      },
      enabled: isLogin? false : true,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: Validators.compose([
        Validators.required("Should match with password"),
        Validators.patternString(_password!, 'Passwords do not match')
      ]),
      decoration: InputDecoration(
          labelText: title,
          errorMaxLines: 3
      ),
    );
  }
  //function for signing in a user with email & password
  Future signInWithEmailAndPassword() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to another screen upon successful login
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      // Handle sign-in errors
      Fluttertoast.showToast(
          msg: '${e.message}',
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: lightAppTheme.primaryColor,
          textColor: Colors.white
      );
    }
  }

  //function for creating a user with email & password
  Future createUserWithEmailAndPassword() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    if (_password != _confirmPassword){
      setState(() {
      });
      return;
    }
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Navigate to another screen upon successful registration
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
    } on FirebaseAuthException catch (e) {
      // Handle registration errors
        Fluttertoast.showToast(
          msg: '${e.message}',
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: lightAppTheme.primaryColor,
          textColor: Colors.white
        );
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
  Widget _emailField(String title,
      TextEditingController controller,
      ) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (email) => 
          email != null && !EmailValidator.validate(email)
          ? "Enter a valid email" : null,
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
      child: Text(isLogin ? 'Register instead' : 'Login', style: GoogleFonts.mulish(
          fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.4, color: lightAppTheme.primaryColor),
      ),
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
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/images/babcock_logo.png",
                    width: 160,
                    height: 160,
                    fit: BoxFit.fill,
                  ),
                  // SizedBox(height: 40),
                  Text( isLogin ?
                    'Log in' : 'Create a new account' ,
                    style: lightAppTheme.textTheme.headlineMedium
                  ),
                  SizedBox(height: 20),
              
                  //email entry
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: _emailField('Email', _emailController,)
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: _passwordField('Password', _passwordController, true)
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: _confirmPasswordField('Confirm Password', _confirmPasswordController, true)
                  ),
                  Padding(padding: EdgeInsets.only(top: 5, bottom: 5)),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: _submitButton(),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(isLogin? "Don\'t have an account?" : "Already have an account?",
                              style: lightAppTheme.textTheme.bodyLarge
                          ),
                          _loginOrRegisterButton(),
                        ],
                      )
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}
