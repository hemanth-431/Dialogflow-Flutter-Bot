import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatefulWidget {
  HomePage createState() => HomePage();
}

class HomePage extends State<MainPage> {
  FToast fToast;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void response(querry) async {
    AuthGoogle authGoogle = await AuthGoogle(
            fileJson: "assets/turing-handler-288402-6a8ec671f18c.json")
        .build();
    Dialogflow dialogflow =
        await Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(querry);
    setState(() {
      messages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"][0].toString()
      });
    });
  }

  final messageInsert = TextEditingController();
  List<Map> messages = List();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Developer Student Clubs"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        child: Center(
            child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.all(10.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    if (messages[index]["data"] == 0) {
                      return Card(
                          elevation: 10.0,
                          color: Colors.grey,

                          child: SafeArea(
                              child: Text(messages[index]["message"].toString(),
                                  style: GoogleFonts.roboto(
                                    fontSize: 20,
                                    color: Colors.white

                                  ))));
                    } else {
                      return Card(
                        color: Colors.blue,

                        child: SafeArea(

                          child: Text(messages[index]["message"].toString(),
                              textAlign: TextAlign.right,

                              style: GoogleFonts.roboto(
                                fontSize: 20,
color: Colors.white
                              )),
                        ),
                      );
                    }
                  }),
            ),
            Divider(
              height: 3.0,
            ),
            Container(
              padding: EdgeInsets.only(left: 20.0),
              margin: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  Flexible(
                    child: TextField(
                      controller: messageInsert,
                      decoration: InputDecoration.collapsed(
                          hintText: "Send your message"),
                    ),
                  ),
                  Container(

                      margin: EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconButton(
                        icon: Icon(
                          Icons.send,
                          size: 30.0,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          if (messageInsert.text.isEmpty) {
                            print("Empty Message");
                          } else {
                            setState(() {
                              messages.insert(0,
                                  {"data": 1, "message": messageInsert.text});
                              // Image(image: AssetImage('assets/home1.png'),);
                            });
                            response(messageInsert.text);
                            messageInsert.clear();
                          }
                        },
                      ))
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
