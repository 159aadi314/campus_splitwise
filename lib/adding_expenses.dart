import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
void main() {
  runApp(const MyApp(name : "Pranjal"));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key,required this.name}) : super(key: key);
  final String name;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
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

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text('Add Expense for '),
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
