import 'package:alchat/pages/auth/ginfo.dart';
import 'package:alchat/service/dbservice.dart';
import 'package:alchat/widgets/messagetile.dart';
import 'package:alchat/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class chatpage extends StatefulWidget {
  final String gid;
  final String gname;

  final String name;

  chatpage(this.gid, this.gname, this.name);
  @override
  State<chatpage> createState() => _chatpageState();
}

class _chatpageState extends State<chatpage> {
  Stream<QuerySnapshot>? chats;
  TextEditingController messagecontroller = TextEditingController();
  String admin = "";
  @override
  void initState() {
    getchatandadmin();
    super.initState();
  }

  getchatandadmin() {
    dbservice().getchats(widget.gid).then((val) {
      setState(() {
        chats = val;
      });
    });
    dbservice().getgroupadmin(widget.gid).then((val) {
      setState(() {
        admin = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.gname),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                nextscreen(context, ginfo(widget.gid, widget.gname, admin));
              },
              icon: Icon(Icons.info))
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatmessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: SizedBox(
              height: 70,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                color: Colors.grey[700],
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: messagecontroller,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Send a message...",
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: InputBorder.none),
                    )),
                    SizedBox(
                      width: 12,
                    ),
                    GestureDetector(
                      onTap: () {
                        sendmessage();
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Icon(Icons.send),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  chatmessages() {
    return StreamBuilder(
      stream: chats,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return messasgetile(
                      snapshot.data.docs[index]['message'],
                      snapshot.data.docs[index]['sender'],
                      widget.name == snapshot.data.docs[index]['sender']);
                },
              )
            : Container();
      },
    );
  }

  sendmessage() {
    if (messagecontroller.text.isNotEmpty) {
      Map<String, dynamic> chatmessagemap = {
        "message": messagecontroller.text,
        "sender": widget.name,
        "time": DateTime.now().millisecondsSinceEpoch,
      };
      dbservice().sendmessage(widget.gid, chatmessagemap);
      setState(() {
        messagecontroller.clear();
      });
    }
  }
}
