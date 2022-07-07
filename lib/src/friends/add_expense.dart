import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:campus_splitwise/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({Key? key, required this.friend}) : super(key: key);
  final Map<String, dynamic> friend;

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  String uid = FirebaseAuth.instance.currentUser?.uid ?? '';
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> friend = <String, dynamic>{};
  final DatabaseService _db = DatabaseService();
  String description = '';
  int amount = 0;
  // initial values of the friend as empty map
  @override
  void initState() {
    super.initState();
    friend.addAll(widget.friend);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'friend-${friend['id']}',
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add expense'),
          actions: [
            IconButton(
              icon: Icon(Icons.check),
              // shift 10 unit left
              padding: EdgeInsets.only(right: 10),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // const snackBar = SnackBar(
                  //   content: Text('Processing...'),
                  //   animation: null,
                  // );
                  Navigator.pop(context, friend);
                  _db.addExpense(uid, friend['id'], friend['name'], friend['IOU'], description, amount);
                }
              },
            ),
          ],
        ),
        body: ListView(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              
              children:<Widget> [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 5),
                  child:
                  Row(children: [
                    Text('Paid by', style: TextStyle( fontSize: 20)),
                    SizedBox(width: 10),
                    Container(
                      // make rounded
                      padding: const EdgeInsets.fromLTRB(20,5,20,5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.greenAccent,
                          width: 1,
                        ),
                      ),
                      child:
                          Text(friend['name'], style: TextStyle( fontSize: 18,)),
                    ),
                  ],)
                )
                    ,
                Container(
                  margin: EdgeInsets.only(left: 15),
                  padding: const EdgeInsets.fromLTRB(15, 0, 20, 20),
                  child:
                    Text('and split equally', style: TextStyle( fontSize: 18)),
                ),
              ]
            ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 15, 40, 20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child:  Icon(
                          Icons.note_add,
                          size: 24.0,
                          semanticLabel:
                              'Description icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter a description',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          autofocus: true,
                          onChanged: (val){
                            setState(() {
                              description = val;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 40, 20),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.currency_rupee,
                          size: 24.0,
                          semanticLabel: 'Rupee icon',
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: TextFormField(
                          decoration: const InputDecoration(
                            hintText: 'Enter amount',
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) == 0) {
                              return 'Please enter a valid amount';
                            }
                            return null;
                          },
                          onChanged: (val){
                            setState(() {
                              amount =  int.parse(val);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ] 
        ),
      ),
    );
  }
}
