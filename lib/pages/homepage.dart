import 'package:alchat/helper/helperfunc.dart';
import 'package:alchat/pages/auth/loginpage.dart';
import 'package:alchat/pages/profile.dart';
import 'package:alchat/pages/search.dart';
import 'package:alchat/service/authservice.dart';
import 'package:alchat/widgets/grouptile.dart';
import 'package:alchat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../service/dbservice.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  String name = '';
  String email = '';
  Stream? group;
  bool _isloading = false;
  String gname = '';
  Authservice authservice = Authservice();
  @override
  void initState() {
    super.initState();
    gettinguserdata();
  }

  gettinguserdata() async {
    await helperfunc.getUseremail().then((value) {
      setState(() {
        email = value!;
      });
    });
    await helperfunc.getUsername().then((value) {
      setState(() {
        name = value!;
      });
    });

    await dbservice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getusergroups()
        .then((snapshot) {
      setState(() {
        group = snapshot;
      });
    });
  }

  String getid(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              nextscreen(context, search());
            },
            icon: Icon(Icons.search),
          )
        ],
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          'Groups',
          style: TextStyle(
              color: Colors.white, fontSize: 27, fontWeight: FontWeight.bold),
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
              name.toUpperCase(),
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
              onTap: () {},
              selectedColor: Theme.of(context).primaryColor,
              selected: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.groups_3_rounded),
              title: Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
                nextscreenreplace(context, profile(name, email));
              },
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.account_balance_wallet),
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
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: Icon(Icons.logout_rounded),
              title: Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
      body: grouplist(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popupDialog(context);
        },
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 30,
        ),
      ),
    );
  }

  grouplist() {
    return StreamBuilder(
      stream: group,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data["groups"] != null) {
            if (snapshot.data["groups"].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['groups'].length,
                itemBuilder: (context, index) {
                  int reverseindex = snapshot.data["groups"].length - index - 1;
                  return grouptile(
                      getid(snapshot.data["groups"][reverseindex]),
                      getname(snapshot.data["groups"][reverseindex]),
                      snapshot.data["name"]);
                },
              );
            } else {
              return nogroupwidget();
            }
          } else {
            return nogroupwidget();
          }
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColor,
            ),
          );
        }
      },
    );
  }

  popupDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: ((context, setState) {
            return AlertDialog(
              title: Text(
                "Create a group",
                textAlign: TextAlign.left,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isloading == true
                      ? Center(
                          child: CircularProgressIndicator(
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      : TextField(
                          onChanged: (value) {
                            setState(() {
                              gname = value;
                            });
                          },
                          style: TextStyle(color: Colors.black),
                          decoration: textInputdecoration,
                        )
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text("CANCEL"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (gname != "") {
                      setState(() {
                        _isloading = true;
                      });
                      dbservice(uid: FirebaseAuth.instance.currentUser!.uid)
                          .creategroup(name,
                              FirebaseAuth.instance.currentUser!.uid, gname)
                          .whenComplete(() {
                        _isloading = false;
                      });
                      Navigator.of(context).pop();
                      showsnackbar(
                          context, Colors.green, "Group Succesfully created");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  child: Text("CREATE"),
                ),
              ],
            );
          }));
        });
  }

  nogroupwidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              popupDialog(context);
            },
            child: Icon(
              Icons.add_circle,
              color: Colors.grey[700],
              size: 75,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "You have not joined any group, tap on the add icon to create a new group or also search from top dearch button.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
