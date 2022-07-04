import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
void main() {
  runApp(MyApp(name : "Pranjal"));
}

String Name="";

class MyApp extends StatelessWidget {
  MyApp({Key? key,required this.name}) : super(key: key);
  final String name;
  void assignName() => {Name=this.name};
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    assignName();
    return MaterialApp(
      title: 'Add Expense for '+name,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Expense for '+Name),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.fromLTRB(70, 20, 100, 20),
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child: const Icon(
                        Icons.note_add,
                        // color: Colors.pink,
                        size: 24.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Expanded(
                      flex:6,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add a note here',

                        ),

                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(70, 20, 100, 20),
                child: Row(
                  children: [
                    Expanded(
                      flex:1,
                      child: const Icon(
                        Icons.currency_rupee,
                        color: Colors.green,
                        size: 24.0,
                        semanticLabel: 'Text to announce in accessibility modes',
                      ),
                    ),
                    Expanded(
                      flex:6,
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Add amount here',

                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty|| int.parse(value)== 0) {
                            return 'Please enter a valid amount';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              RaisedButton.icon(onPressed: ()=>{
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  )
                }
              },
                label: Text('done'),
                icon: Icon(Icons.check_circle),
                color: Colors.green,

              )

            ],
          ),
        ),
      ),
    );
  }
}
