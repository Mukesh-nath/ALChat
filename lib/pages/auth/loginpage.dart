import 'package:alchat/pages/auth/register.dart';
import 'package:alchat/service/dbservice.dart';
import 'package:alchat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:alchat/helper/helperfunc.dart';
import 'package:flutter/services.dart';
import '../../service/authservice.dart';
import '../homepage.dart';

// ignore_for_file: prefer_const_constructors

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  Authservice authservice = Authservice();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return Scaffold(
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: SafeArea(
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : SingleChildScrollView(
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
                                fontFamily: "Miniver",
                                color: Colors.blueGrey,
                                fontSize: 45,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Login now to see what's going on!",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          Image.asset(
                            "assets/loginpage2.png",
                            height: 370,
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
                              validator: (val) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val!)
                                    ? null
                                    : "Please enter a valid email";
                              },
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
                              validator: (val) {
                                if (val!.length < 8) {
                                  return "Password must be atleast 8 charcters";
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (val) {
                                setState(() {
                                  password = val;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          SizedBox(
                            width: 110,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  login();
                                },
                                child: Text(
                                  'Login',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text.rich(TextSpan(
                              text: "Don\'t have an account?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                    text: " Register Here",
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextscreen(context, register());
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

  login() async {
    {
      if (formKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        await authservice
            .signinUserWithEmailandPassword(email, password)
            .then((value) async {
          if (value != true) {
            QuerySnapshot snapshot =
                await dbservice(uid: FirebaseAuth.instance.currentUser!.uid)
                    .gettinguserdata(email);
            await helperfunc.saveUserLoggedInStatus(true);
            await helperfunc.saveUserEmailsf(email);
            await helperfunc.saveUserNamesf(snapshot.docs[0]['name']);
            nextscreenreplace(context, homepage());
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
