import 'package:flutter/material.dart';

class messasgetile extends StatefulWidget {
  final String message;
  final String sender;
  final bool sentbyme;
  messasgetile(this.message, this.sender, this.sentbyme);
  @override
  State<messasgetile> createState() => _messasgetileState();
}

class _messasgetileState extends State<messasgetile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: 4,
          bottom: 4,
          left: widget.sentbyme ? 0 : 24,
          right: widget.sentbyme ? 24 : 0),
      alignment: widget.sentbyme ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: widget.sentbyme
            ? EdgeInsets.only(
                left: 30,
              )
            : EdgeInsets.only(right: 30),
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 20, right: 20),
        decoration: BoxDecoration(
            borderRadius: widget.sentbyme
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            color: widget.sentbyme
                ? Theme.of(context).primaryColor
                : Colors.grey[700]),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            widget.sender.toUpperCase(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.2,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.message,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          )
        ]),
      ),
    );
  }
}
