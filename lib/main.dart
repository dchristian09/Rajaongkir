import 'dart:convert';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:latihanweek6/services/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  
  final _loginKey = GlobalKey<FormState>();
  final ctrlEmail = TextEditingController();

  @override
  void dispose() {
    ctrlEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _loginKey,
          child: Column(
            children:[
              TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email)
                  ),
                  controller: ctrlEmail,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator:(value) {
                    return !EmailValidator.validate(value.toString()) ? 'Email tidak valid!': null;
                  },
                ),
            ]
          )
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          if(_loginKey.currentState!.validate()){
            await RajaOngkirService.sendEmail(ctrlEmail.text).then((value) {
            var result = json.decode(value.body);
            Fluttertoast.showToast(
              msg: result['message'].toString(),
              toastLength: Toast.LENGTH_LONG,
              fontSize: 14,
              backgroundColor: Colors.greenAccent,
              textColor: Colors.white
            );
          });
          }else{
            Fluttertoast.showToast(
              msg: "Please fill all fields",
              toastLength: Toast.LENGTH_LONG,
              fontSize: 14,
              backgroundColor: Colors.redAccent,
              textColor: Colors.white
            );
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.send),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
