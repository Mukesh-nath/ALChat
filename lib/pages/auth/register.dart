// ignore_for_file: unused_field

import 'package:alchat/helper/helperfunc.dart';
import 'package:alchat/pages/auth/loginpage.dart';
import 'package:alchat/service/authservice.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../homepage.dart';

import '../../widgets/widgets.dart';

class register extends StatefulWidget {
  const register({super.key});

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {
  final formKey = GlobalKey<FormState>();
  String name = '';
  String email = '';
  String password = '';
  bool _isLoading = false;

  String? validateName(String? val) {
    if (val != null && val.isNotEmpty) {
      return null; // Return null if validation succeeds
    } else {
      return "Name can't be empty"; // Return an error message if validation fails
    }
  }

  String? validateEmail(String? val) {
    if (val != null && val.isNotEmpty) {
      // Use a regular expression to check if the email format is valid
      final emailRegex = RegExp(
          r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
      if (emailRegex.hasMatch(val)) {
        return null; // Return null if the email is valid
      } else {
        return 'Invalid email format'; // Return an error message if the email format is invalid
      }
    } else {
      return 'Email can\'t be empty'; // Return an error message if the email is empty
    }
  }

  String? validatePassword(String? val) {
    if (val != null && val.length >= 8) {
      return null; // Return null if the password is valid
    } else {
      return 'Password must be at least 8 characters long'; // Return an error message if the password is too short
    }
  }

  Authservice authservice = Authservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 80),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Alchat',
                      style: TextStyle(
                          fontSize: 45,
                          color: Colors.blueGrey,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Miniver'),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      "Create Your Account Now To Explore!",
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Image.asset(
                      "assets/register1.png",
                      height: 340,
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        decoration: textInputdecoration.copyWith(
                            labelText: "Name",
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.person,
                              color: Colors.black,
                            )),
                        onChanged: (val) {
                          setState(() {
                            name = val;
                          });
                        },
                        validator: validateName,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        decoration: textInputdecoration.copyWith(
                            labelText: "Email",
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.email,
                              color: Colors.black,
                            )),
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                        validator: validateEmail,
                        // (val) {
                        //   return RegExp(
                        //               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        //           .hasMatch(val!)
                        //       ? null
                        //       : "Please enter a valid email";
                        // },
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    SizedBox(
                      width: 320,
                      child: TextFormField(
                        obscureText: true,
                        decoration: textInputdecoration.copyWith(
                            labelText: "Password",
                            labelStyle: TextStyle(color: Colors.grey),
                            prefixIcon: Icon(
                              Icons.lock,
                              color: Colors.black,
                            )),
                        validator: validatePassword,
                        // (val) {
                        //   if (val!.length < 8) {
                        //     return "Password must be atleast 8 charcters";
                        //   } else {
                        //     return null;
                        //   }
                        // },
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 110,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            register();
                          },
                          child: Text(
                            'Register',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text.rich(TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: " Login Now",
                              style: TextStyle(
                                  color: Colors.black,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  nextscreen(context, loginpage());
                                })
                        ]))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  register() async {
    {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await authservice
            .registerUserWithEmailandPassword(name, email, password)
            .then((value) async {
          if (value != true) {
            nextscreenreplace(context, homepage());

            await helperfunc.saveUserLoggedInStatus(true);
            await helperfunc.saveUserEmailsf(email);
            await helperfunc.saveUserNamesf(name);
          } else if (value == false) {
            showsnackbar(context, Colors.red, value);
            setState(() {
              _isLoading = false;
            });
          }
        });
      }
    }
  }
}
