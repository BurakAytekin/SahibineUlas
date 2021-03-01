import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';

class CodeStatus extends StatefulWidget {
  @override
  _CodeStatusState createState() => _CodeStatusState();
}

class _CodeStatusState extends State<CodeStatus> {
  GlobalKey<FormState> _codekey = new GlobalKey<FormState>();
  String code = "";
  bool error = false;
  String errormsg = "";
  String id = "";
  var session = FlutterSession();
  void updatecodestatu() async{
    dynamic userid = await session.get("id");
    FirebaseFirestore.instance.collection('codes').where('code', isEqualTo: code).limit(1).get().then((value) => {
      if(value.docs.length > 0)
      {
        if(value.docs.first['status'] == false)
        {
          id = value.docs.first.id,
          FirebaseFirestore.instance.collection('codes').doc(id).update({
            'status':true,
            'userid':userid
          }),
        }
      }
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dostumuzu Kaydedelim"),
      ),
      body: Container(
        child:Center(
          child:SingleChildScrollView(
            child: Form(
              key: _codekey,
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
                      child: Text("Dostumu Kaydet"),
                      onPressed: () {
                        _codekey.currentState.save();
                        updatecodestatu();
                      },
                    ),
                  ),
                  Container(
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