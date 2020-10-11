// import 'package:flutter/material.dart';
// import 'package:itp/config/config.dart';
// import 'package:itp/editprofile.dart';
// import 'package:itp/feed.dart';
// import 'package:itp/main.dart';
//
// class MyDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: ListView(children: [
//       Container(
//           padding: EdgeInsets.only(top: 25.0, bottom: 10.0),
//           decoration: new BoxDecoration(
//             gradient:
//                 new LinearGradient(colors: [Colors.red[700], Colors.redAccent]),
//           ),
//           child: Column(
//             children: [
//               Material(
//                   borderRadius: BorderRadius.all(Radius.circular(80.0)),
//                   elevation: 8.0,
//                   child: Container(
//                     height: 160.0,
//                     width: 160.0,
//                     child: CircleAvatar(
//                       backgroundImage: NetworkImage(
//                         Deliceus.sharedPreferences
//                             .getString(Deliceus.userAvatarUrl),
//                       ),
//                     ),
//                   )),
//               SizedBox(
//                 height: 10.0,
//               ),
//               Text(
//                 Deliceus.sharedPreferences.getString(Deliceus.userName),
//                 style: TextStyle(color: Colors.white, fontSize: 35.0),
//               ),
//             ],
//           )),
//       SizedBox(
//         height: 12.0,
//       ),
//       Container(
//           padding: EdgeInsets.only(top: 1.0),
//           decoration: new BoxDecoration(
//             gradient:
//                 new LinearGradient(colors: [Colors.red[700], Colors.redAccent]),
//           ),
//           child: Column(
//             children: [
//               ListTile(
//                 leading: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                 ),
//                 title: Text("Home", style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Route route = MaterialPageRoute(builder: (c) => Feed());
//                   Navigator.pushReplacement(context, route);
//                 },
//               ),
//               Divider(
//                 height: 10.0,
//                 color: Colors.white,
//                 thickness: 6.0,
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                 ),
//                 title:
//                     Text("Edit Profile", style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Route route =
//                       MaterialPageRoute(builder: (c) => EditProfile());
//                   Navigator.pushReplacement(context, route);
//                 },
//               ),
//               Divider(
//                 height: 10.0,
//                 color: Colors.white,
//                 thickness: 6.0,
//               ),
//               ListTile(
//                 leading: Icon(
//                   Icons.home,
//                   color: Colors.white,
//                 ),
//                 title: Text("Logout", style: TextStyle(color: Colors.white)),
//                 onTap: () {
//                   Deliceus.auth.signOut().then((c) {
//                     Route route = MaterialPageRoute(builder: (c) => MyApp());
//                     Navigator.pushReplacement(context, route);
//                   });
//                 },
//               ),
//               Divider(
//                 height: 10.0,
//                 color: Colors.white,
//                 thickness: 6.0,
//               ),
//             ],
//           ))
//     ]));
//   }
// }
