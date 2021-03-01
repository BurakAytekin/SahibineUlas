import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session/flutter_session.dart';
import 'package:twilio_flutter/twilio_flutter.dart';

class FindedPet extends StatefulWidget {
  @override
  _FindedPetState createState() => _FindedPetState();
}

class _FindedPetState extends State<FindedPet> {
  var session = FlutterSession();
  String name;
  String surname;
  String phone;
  String mail;
  String message = "";
  GlobalKey<FormState> sender = new GlobalKey<FormState>();
  TextEditingController namectrl = new TextEditingController();
  TwilioFlutter twilioFlutter;

  void recordfind() async
  {
    dynamic id = await session.get("userid");
    await FirebaseFirestore.instance.collection('users').doc(id).get().then((value) => {
      name = value['name'].toString(),
      surname = value['surname'].toString(),
      phone = value['telephone'].toString(),
      mail = value['mail'].toString(),
    });
    setState(() {
      namectrl.text = name;
    });

  }

  @override
  void initState() {
    super.initState();
    twilioFlutter = TwilioFlutter(
      accountSid : 'ACb537151c6cb258c9492e274b6a35719a',
      authToken : '9d23077bca6352ef62862cb81a4eed93',
      twilioNumber : '+17867891197'
    );
    print("Geldi");
    recordfind();

      // Or call your function here
  }
  void smssend()
  {
    twilioFlutter.sendSMS(
    toNumber : '+905363050823',
     messageBody : message);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: sender,
              child: Column(
                children: [
                  Container(
                    child: Text("Mesaj Gönderilecek Kişi", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(60, 5, 60, 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                      ),
                      controller: namectrl,
                      readOnly: true,
                    ),
                  ),
                  Container(
                    child: Text("Gönderilecek Mesajı Giriniz", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(60, 5, 60, 5),
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Dostumuzun Sahibine Gönderilecek Mesajı Buraya Girebilirsiniz',
                        contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(30))
                      ),

                      maxLines: 5,
                      onSaved: (String value){
                        message = value;
                      },
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top:10,left: 20, right: 20),
                    child: ElevatedButton(
                      child: Text("Mesajı Gönder"),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                      ),
                      onPressed: () {
                        sender.currentState.save();
                        smssend();
                      },
                    ),
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