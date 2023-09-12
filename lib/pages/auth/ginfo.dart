import 'package:alchat/pages/homepage.dart';
import 'package:alchat/service/dbservice.dart';
import 'package:alchat/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ginfo extends StatefulWidget {
  final String gid;
  final String gname;
  final String adminname;
  ginfo(this.gid, this.gname, this.adminname);
  @override
  State<ginfo> createState() => _ginfoState();
}

class _ginfoState extends State<ginfo> {
  Stream? members;
  @override
  void initState() {
    getmembers();
    super.initState();
  }

  getmembers() async {
    dbservice(uid: FirebaseAuth.instance.currentUser!.uid)
        .getgmembers(widget.gid)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        title: Text("Group Info"),
        actions: [
          IconButton(
              onPressed: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Exit'),
                        content:
                            Text('Are you sure you want to Exit the group? '),
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
                              dbservice(
                                      uid: FirebaseAuth
                                          .instance.currentUser!.uid)
                                  .togglegroupjoin(widget.gid,
                                      getname(widget.adminname), widget.gname)
                                  .whenComplete(() {
                                nextscreenreplace(context, homepage());
                              });
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
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Theme.of(context).primaryColor.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Theme.of(context).primaryColor,
                    child: Text(
                      widget.gname.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          fontWeight: FontWeight.w500, color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.gname}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 15),
                      Text("Admin: ROYAL PRINCE")
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: memberlist(),
            )
          ],
        ),
      ),
    );
  }

  String getid(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  memberlist() {
    return StreamBuilder(
      stream: members,
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
              return ListView.builder(
                itemCount: snapshot.data['members'].length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Text(
                          getname(snapshot.data['members'][index])
                              .substring(0, 1)
                              .toUpperCase(),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(getname(snapshot.data['members'][index])),
                      subtitle: Text(getid(snapshot.data['members'][index])),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
              child: Text("NO MEMBERS"),
            );
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ));
        }
      },
    );
  }
}
