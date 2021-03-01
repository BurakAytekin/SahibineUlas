import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sahibineulas/findalert.dart';
import 'lostNotify.dart';
import 'package:flutter_session/flutter_session.dart';
class SignPet extends StatefulWidget {
  @override
  _SignPetState createState() => _SignPetState();
}

class _SignPetState extends State<SignPet> {
   GlobalKey<FormState> _signform = new GlobalKey<FormState>();
  String code = "";
  bool error = false;
  String errormsg = "";
  var session = FlutterSession();
  void codecheck() async{
    await FirebaseFirestore.instance.collection('codes').where('code', isEqualTo: code).limit(1).get().then((value) => {
      if(value.docs.length > 0)
      {
        if(value.docs.first['status'])
        {
          session.set("userid", value.docs.first['userid']),
          Navigator.push(context, MaterialPageRoute(builder: (context) => FindedPet()))
        }else{
          error = true,
          errormsg = "Dost Kodu Etkinleştirilmemiş."
        }
      }
      else{
        error=true,
        errormsg="Dost Kodu Bulunamadı."
      }
    });
    setState(() {

    });
  }
  Widget _buildPopup(BuildContext context)
  {
    return new AlertDialog(
    title: const Text('Popup example'),
    content: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Hello"),
      ],
    ),
    actions: <Widget>[
      new FlatButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        textColor: Theme.of(context).primaryColor,
        child: const Text('Close'),
      ),
    ],
  );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Bulunan Dost Yardımı"),
      ),
      body: Center(
       child :SingleChildScrollView(
        child:Form(
          key: _signform,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: 'Sign',
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 50,
                  child: Image.asset('images/pets.png'),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(50, 20, 50, 0),
                child:TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Etiket Kodu',
                    contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                  ),
                  onSaved: (String value){
                    code = value;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top:20),
                child:ElevatedButton(
                  child: Text("Dostumuzu Buldum"),
                  onPressed: () {
                    _signform.currentState.save();
                    codecheck();
                  },
                ),
              ),
              Container(
                child: error ? Text("$errormsg") : Container(),
              ),

            ],
          ),
        )
      ),
      ),
    );
  }
}