import 'package:alchat/pages/homepage.dart';
import 'package:alchat/service/authservice.dart';
import 'package:flutter/material.dart';

import '../widgets/widgets.dart';
import 'auth/loginpage.dart';

// ignore: must_be_immutable
class profile extends StatefulWidget {
  String name;
  String email;
  profile(this.name, this.email);

  @override
  State<profile> createState() => _profileState();
}

class _profileState extends State<profile> {
  final Authservice authservice = Authservice();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(
              color: Colors.white,
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.symmetric(
              vertical: 50,
            ),
            children: <Widget>[
              Icon(
                Icons.man_2_rounded,
                size: 150,
                color: Colors.grey,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                widget.name.toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                height: 2,
              ),
              ListTile(
                onTap: () {
                  nextscreen(context, homepage());
                },
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.group_add_rounded),
                title: Text(
                  "Groups",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () {},
                selectedColor: Theme.of(context).primaryColor,
                selected: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(Icons.account_balance_wallet_rounded),
                title: Text(
                  "Profile",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              ListTile(
                onTap: () async {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to Logout'),
                          actions: [
                            IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.red,
                              ),
                            ),
                            IconButton(
                              onPressed: () async {
                                await authservice.signout();
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => loginpage(),
                                    ),
                                    (route) => false);
                              },
                              icon: Icon(
                                Icons.done,
                                color: Colors.green,
                              ),
                            ),
                          ],
                        );
                      });
                },
                selected: true,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: Icon(
                  Icons.logout_rounded,
                  color: Colors.grey,
                ),
                title: Text(
                  "Logout",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 40, vertical: 160),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.man_3_rounded,
                size: 200,
                color: Colors.grey[700],
              ),
              SizedBox(
                height: 18,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Name",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.name.toUpperCase(),
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
              Divider(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Email",
                    style: TextStyle(fontSize: 17),
                  ),
                  Text(
                    widget.email,
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
