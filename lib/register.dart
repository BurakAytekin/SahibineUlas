import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:sahibineulas/login.dart';
import 'package:password_strength/password_strength.dart';
import 'package:email_validator/email_validator.dart';


class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  String name = "";
  String surname = "";
  String phone = "";
  String mail = "";
  String pass = "";
  bool error = false;
  String errormsg = "";
  GlobalKey<FormState> registrationkey = new GlobalKey<FormState>();
  var session = FlutterSession();
  void adduser() async{
    if(EmailValidator.validate(mail))
    {
      double pass_strength = estimatePasswordStrength(pass);
      if(pass_strength > 0.5)
      {
        await FirebaseFirestore.instance.collection('users').doc().set({
          'mail':mail,
          'name':name,
          'password':pass,
          'surname':surname,
          'telephone':phone,
        });
        Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
      }
      else{
        error = true;
        errormsg = "Daha güçlü bir parola seçin";
      }

    }else{
      error = false;
      errormsg = "E-posta adresinizi doğru giriniz";
    }
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/rg_background.jpg'),
            fit: BoxFit.fill,
          )
        ),
        child: Center(
        child: Form(
        key: registrationkey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 30),
                child: Hero(
                  tag: 'Register',
                  child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  child: Image.asset('images/register.png'),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child:TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Adınız',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    name = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child:TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Soyadınız',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    surname = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child:TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Mail',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    mail = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child:TextFormField(
                  obscureText: true,
                  obscuringCharacter: "*",
                  decoration: InputDecoration(
                    hintText: 'Şifreniz',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    pass = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child:TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Telefon Numaranız',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    phone = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:10,left: 20, right: 20),
                child: ElevatedButton(
                  child: Text("Kayıt Ol"),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
                  ),
                  onPressed: () {
                    registrationkey.currentState.save();
                    adduser();
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15),
                child: error ? Text("$errormsg") : Container(),
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