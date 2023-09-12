import 'package:alchat/widgets/widgets.dart';
import 'package:flutter/material.dart';

import '../pages/auth/chatpage.dart';

class grouptile extends StatefulWidget {
  final String gid;
  final String gname;
  final String name;
  grouptile(this.gid, this.gname, this.name);

  @override
  State<grouptile> createState() => _grouptileState();
}

class _grouptileState extends State<grouptile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextscreen(context, chatpage(widget.gid, widget.gname, widget.name));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).primaryColor,
            child: Text(
              widget.gname.substring(0, 1).toUpperCase(),
              textAlign: TextAlign.center,
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
            ),
          ),
          title: Text(
            widget.gname,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            "Join the conversation as ${widget.name}",
            style: TextStyle(fontSize: 13),
          ),
        ),
      ),
    );
  }
}
