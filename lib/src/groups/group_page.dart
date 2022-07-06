import 'package:flutter/material.dart';

class Group extends StatefulWidget {
  const Group({Key? key, required this.group}) : super(key: key);
  final Map<String, dynamic> group;

  @override
  State<Group> createState() => _GroupState();
}

class _GroupState extends State<Group> {
  // CONNECTED USERS STUFF --------------------
  final List<Map<String, dynamic>> cnu = List.generate(3, (index) {
    return {
      'friend_name': 'Friend ${index + 1}',
      'amount': 100 * index + 100,
    };
  });
  final Map<String, dynamic> mapping = {
    'connected_users': <List<Map<String, dynamic>>>[],
    "get_back": true,
  };
  // GROUP MEMBERS STUFF ----------------------
  final List<Map<String, dynamic>> groupMembers = List.generate(10, (index) {
    return {
      'uid': '${index + 1}',
      'name': 'Friend ${index + 1}',
      'contribution': 100 * index + 100,
    };
  });
  // ------------------------------------------
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> group = <String, dynamic>{};

  // initial values of the friend as empty map
  @override
  void initState() {
    super.initState();
    group.addAll(widget.group);
    // use the group id from above to get the group members and stuff

    // CONNECTED USERS --------------
    mapping['connected_users'] = cnu;
    print(mapping.toString());
  }

  static const headingStyle = TextStyle(fontSize: 24, fontWeight: FontWeight.w500);
  static const textStyle  = TextStyle(fontSize: 18, fontWeight: FontWeight.w400);
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'group-${group['id']}',
      child: Scaffold(
        appBar: AppBar(
          title: Text('${group['name']}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(10), 
          child: 
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(

                child: ListView.builder(
                  itemCount: groupMembers.length + cnu.length + 2,
                  itemBuilder: (context, index) {
                    return
                      index == 0 ?
                      buildHeading1()
                      :
                      index == cnu.length + 1 ?
                      buildHeading2() 
                      :
                      index < cnu.length + 1 ?
                      buildConnectedUser(index - 1 )
                      :
                      index < groupMembers.length + cnu.length + 1 ?
                      buildMember(index - cnu.length - 1)
                      :
                      SizedBox(height: 10,);
                  }
                ),
              ),
              

            ],
          ),
        ),
      ),
    );
  }

  buildHeading1 () => 
      Padding(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        child: 
          mapping['get_back']
          ? (const Text('Get back from ', style: headingStyle))
          : (const Text( 'You owe ', style: headingStyle ))
      
      );
      
  buildHeading2 () => 
      const Padding(
        padding: EdgeInsets.fromLTRB(5, 20, 5, 10),
        child: 
         Text('Members and Contributions', style: headingStyle)
      );

  buildConnectedUser (int index) => 
    Card(
      key: ValueKey(mapping['connected_users'][index]['name']),
      elevation: 2,

      child: ListTile(
        title:
            Text(mapping['connected_users'][index]['friend_name'], style: textStyle,),
        trailing:
            Text('${mapping['connected_users'][index]['amount']}' , style: textStyle,),
      )
    );
  buildMember (int index) => 
    Card(
      key: ValueKey(groupMembers[index]['uid']),
      elevation: 2,

      child: ListTile(
        title:
            Text(groupMembers[index]['name'], style: textStyle,),
        trailing:
            Text('${groupMembers[index]['contribution']}' , style: textStyle,),
      ),
    );
}
