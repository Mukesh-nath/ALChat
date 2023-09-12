import 'package:alchat/helper/helperfunc.dart';
import 'package:alchat/pages/auth/chatpage.dart';
import 'package:alchat/service/dbservice.dart';
import 'package:alchat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  TextEditingController searchController = TextEditingController();
  bool _isloading = false;
  QuerySnapshot? searchsnapshot;
  bool hasusersearch = false;
  String name = '';
  String gid = '';
  String gname = '';
  String admin = '';
  bool isjoined = false;

  User? user;
  @override
  void initState() {
    super.initState();
    getcurrentuseridandname();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "Search",
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 0),
                  child: TextField(
                    controller: searchController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Search Groups...",
                        hintStyle:
                            TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isearch();
                  });
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              )
            ]),
          ),
          _isloading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                )
              : grouplist(),
        ],
      ),
    );
  }

  String getid(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  String getname(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  isearch() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isloading = true;
      });
      await dbservice().searchbyname(searchController.text).then((snapshot) {
        setState(() {
          searchsnapshot = snapshot;
          _isloading = false;
          hasusersearch = true;
        });
      });
    }
  }

  grouplist() {
    return hasusersearch
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchsnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                name,
                searchsnapshot!.docs[index]['gid'],
                searchsnapshot!.docs[index]['gname'],
                searchsnapshot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  Widget groupTile(String name, String gid, String gname, String admin) {
    joinedornot(name, gid, gname, admin);
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).primaryColor,
        child: Text(
          gname.substring(0, 1).toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
      title: Text(
        gname,
        style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text("Admin: ${getname(admin)}"),
      trailing: InkWell(
        onTap: () async {
          await dbservice(uid: user!.uid).togglegroupjoin(gid, name, gname);
          if (isjoined) {
            setState(() {
              isjoined = !isjoined;
            });
            showsnackbar(context, Colors.green, "Succesfully joined the group");
            Future.delayed(Duration(seconds: 2), () {
              nextscreen(context, chatpage(gid, gname, name));
            });
          } else {
            setState(() {
              isjoined = !isjoined;
              showsnackbar(context, Colors.red, "Left the Group $gname");
            });
          }
        },
        child: isjoined
            ? Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 1),
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Joined",
                  style: TextStyle(color: Colors.white),
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  "Join",
                  style: TextStyle(color: Colors.white),
                ),
              ),
      ),
    );
  }

  getcurrentuseridandname() async {
    await helperfunc.getUsername().then((value) {
      setState(() {
        name = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }

  void joinedornot(String name, String gid, String gname, String admin) async {
    await dbservice(uid: user!.uid)
        .isuserjoined(gname, gid, name)
        .then((value) {
      setState(() {
        isjoined = value;
      });
    });
  }
}
