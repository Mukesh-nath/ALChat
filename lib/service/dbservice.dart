import 'package:cloud_firestore/cloud_firestore.dart';

class dbservice {
  final String? uid;
  dbservice({this.uid});

  //reference for collections
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");

  //update userdata
  Future savingUserData(String name, String email) async {
    return await userCollection.doc(uid).set({
      'name': name,
      'email': email,
      'groups': [],
      'profilepic': '',
      'uid': uid,
    });
  }

  Future gettinguserdata(String email) async {
    QuerySnapshot snapshot =
        await userCollection.where("email", isEqualTo: email).get();
    return snapshot;
  }

  getusergroups() async {
    return userCollection.doc(uid).snapshots();
  }

  Future creategroup(String name, String id, String gname) async {
    DocumentReference gdocumentReference = await groupCollection.add({
      "gname": gname,
      "gicon": "",
      "admin": "${id}_$name",
      "members": [],
      "gid": "",
      "recentmessage": "",
      "recentmessagesender": "",
    });

    await gdocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid!}_$name"]),
      "gid": gdocumentReference.id,
    });

    DocumentReference UserDocumentReference = userCollection.doc(uid);
    return await UserDocumentReference.update({
      "groups": FieldValue.arrayUnion(["${gdocumentReference.id}_$gname"])
    });
  }

  getchats(String gid) async {
    return groupCollection
        .doc(gid)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  Future getgroupadmin(String gid) async {
    DocumentReference d = groupCollection.doc(gid);
    DocumentSnapshot documentSnapshot = await d.get();
    return documentSnapshot["admin"];
  }

  getgmembers(groupid) async {
    return groupCollection.doc(groupid).snapshots();
  }

  searchbyname(String gname) {
    return groupCollection.where("gname", isEqualTo: gname).get();
  }

  Future<bool> isuserjoined(
    String gname,
    String gid,
    String name,
  ) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${gid}_$gname")) {
      return true;
    } else {
      return false;
    }
  }

  Future togglegroupjoin(String gid, String name, String gname) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentReference groupDocumentReference = groupCollection.doc(gid);

    DocumentSnapshot documentSnapshot = await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot["groups"];

    if (groups.contains("${gid}_$gname")) {
      await userDocumentReference.update({
        "groups": FieldValue.arrayRemove(["${gid}_$gname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayRemove(["${uid}_$name"])
      });
    } else {
      await userDocumentReference.update({
        "groups": FieldValue.arrayUnion(["${gid}_$gname"])
      });
      await groupDocumentReference.update({
        "members": FieldValue.arrayUnion(["${uid}_$name"])
      });
    }
  }

  sendmessage(String gid, Map<String, dynamic> chatmessagedata) async {
    groupCollection.doc(gid).collection("messages").add(chatmessagedata);
    groupCollection.doc(gid).update({
      "recentmeesage": chatmessagedata["message"],
      "recentmessagesender": chatmessagedata["sender"],
      "recentmessagetime": chatmessagedata["time"].toString(),
    });
  }
}
