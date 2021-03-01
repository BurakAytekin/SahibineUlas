import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'usermenu.dart';
import 'package:flutter_session/flutter_session.dart';


class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _loginkey = new GlobalKey<FormState>();
  String _username = "";
  String _pass = "";
  bool error = false;
  String errormsg = "";
  var session = FlutterSession();
  void logon(context) async
  {
    String id = "";
    await FirebaseFirestore.instance.collection('users').where('mail', isEqualTo: _username).limit(1).get().then((value) => {
      if(value.docs.length > 0)
      {
        if(value.docs.first['password'] == _pass)
        {
          id = value.docs.first.id.toString(),
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => UserMenu()),
            (Route<dynamic> route) => false,
          )
        }else{
          error = true,
          errormsg = "Şifre Yanlış Girildi."
        }
      }
      else{
        error = true,
        errormsg = "E-Mail Yanlış Girildi"
      }
    });
    await session.set("id", id);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        title: Text("Kullanıcı Girişi", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.amber,

      ),
      body:Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/rg_background.jpg'),
            fit: BoxFit.fill,
          ),
        ),
        child:Center(
          child: SingleChildScrollView(
            child: Form(
              key: _loginkey,
              child: Column(
                children: [
                  Hero(
                    tag: 'Login',
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 50,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(50,20,50,0),
                    child:TextFormField(
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      onSaved: (String value){
                        _username = value;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(50,20,50,0),
                    child:TextFormField(
                      obscureText: true,
                      obscuringCharacter: '*',
                      decoration: InputDecoration(
                        hintText: 'Şifre',
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                        ),
                        onSaved: (String value){
                        _pass = value;
                      },
                    ),
                  ),
                  Container(
                   margin: EdgeInsets.fromLTRB(50,20,50,0),
                    child:ElevatedButton(
                      child: Text("Giriş Yap"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                      ),
                      onPressed: () {
                        _loginkey.currentState.save();
                        logon(context);
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(50,20,50,0),
                    child:error ? Container(
                      child: Text(
                        errormsg,
                        style: TextStyle(color: Colors.red, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ) : SizedBox(height: 1,),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}