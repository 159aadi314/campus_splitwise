import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/groups/create_group_addfriends.dart';

class GroupsPage extends StatefulWidget {
  const GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final List<Map<String,dynamic>> _allgroups = List.generate(20, (index) {
    return {
      'id': '$index',
      'name': 'Group ${index + 1}',
      'description': 'default group',
      'status': index % 2 == 1
          ? 'settled'
          : 'not settled',
    };
  });

  List<Map<String, dynamic>> _foundGroups = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundGroups = _allgroups;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allgroups;
    } else {
      results = _allgroups
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundGroups = results;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Friends"),
      //   flexibleSpace: Container(
      //     decoration: const BoxDecoration(
      //       color: Color.fromARGB(255, 35, 34, 34),
      //     ),
      //   ),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child:
        Column(
          children: [
            TextField(
              onChanged: (value) => _runFilter(value),
              decoration: const InputDecoration(
                  labelText: 'Search', suffixIcon: Icon(Icons.search)),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: _foundGroups.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundGroups.length,
                itemBuilder: (context, index) =>
                    buildBox(_foundGroups[index]),
              )
                  : const Text(
                'No results found',
                style: TextStyle(fontSize: 24),
              ),
            ),

          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'createGroup',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddGroupPage()),
          );
        },
        // Add your onPressed code here!
        label: const Text('Create Group'),
        icon: const Icon(Icons.group_add),
      ),


    );
  }

  Widget buildBox(Map<String,dynamic> group) => Hero(
    tag: 'group-${group['id']}',
    child: SizedBox(
      height: 90,
      child: Card(
        key: ValueKey(group["id"]),
        elevation: 2,

        margin: const EdgeInsets.symmetric(vertical: 10),
        child: ListTile(
          visualDensity: VisualDensity.comfortable,
          // increase size of this icon
          leading:
          const Icon(Icons.group),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5),
              Text(
                  '${group['name']}',
                  style: TextStyle(fontSize: 18 )
              ),
              SizedBox(height: 10),
              Text(
                '${group['description']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Roboto',
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          trailing: Text(
            '${group['status']}'
          ),
        ),
      ),
    ),
  );
}



