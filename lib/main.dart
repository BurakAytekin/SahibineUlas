

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'login.dart';
import 'signPet.dart';
import 'changeStatus.dart';
import 'register.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:url_launcher/url_launcher.dart';
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  var session = FlutterSession();
  await session.set("id", "");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Sahibine Ulaş'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle menutextstyle = TextStyle(fontSize: 15, fontWeight: FontWeight.bold );
  String _url = "https://www.n11.com/";
  var session = FlutterSession();
  void paginatecheck(BuildContext cnt) async{
    dynamic userid = await session.get("id");
    print(userid);
    if(userid != null && userid != "")
    {
      Navigator.push(cnt, MaterialPageRoute(builder: (cnt) => CodeStatus()));
    }
    else{
      Navigator.push(cnt, MaterialPageRoute(builder: (cnt) => Register()));
    }
  }
  Future<void> _launchInBrowser() async {
    if (await canLaunch(_url)) {
      await launch(
        _url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $_url';
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget buttoncreator(String text,String title,double height)
    {
      return GestureDetector(
        child:Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                Image.asset('images/$text.png', fit: BoxFit.cover,height: height,),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  child:Text("$title", style: menutextstyle),
                ),
            ],
          ),
        ),
        onTap: () {
          if(text == "confirmation")
          {
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignPet()));
          }
          else if(text == "sign")
          {
            paginatecheck(context);
          }
          else {
            _launchInBrowser();
          }
        },
      );
    }
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15),
            child: GestureDetector(
              child: Icon(Icons.person),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            buttoncreator("confirmation", "Bulundu Bildirimi Girişi",100),
            buttoncreator("sign", "Ürününüzü Kaydedin",100),
            buttoncreator("buy","Etiket Satın Al",100),
          ],
        ),
      ),
    );
  }
}
