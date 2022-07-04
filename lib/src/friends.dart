import 'package:flutter/material.dart';
import 'package:adding_expense_2/src/adding_expenses.dart';
class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  _FriendsPageState createState() => _FriendsPageState();
}
class _FriendsPageState extends State<FriendsPage> {
  final List<Map<String,dynamic>> _allfriends = List.generate(20, (index) {
    return {
      'id': '$index',
      'name': 'Friend ${index + 1}',
      'IOU': index % 3 == 1
          ? 100
          : index % 3 == 2
          ? -100
          : 0, // pos or neg
    };
  });

  List<Map<String, dynamic>> _foundUsers = [];
  @override
  initState() {
    // at the beginning, all users are shown
    _foundUsers = _allfriends;
    super.initState();
  }

  // This function is called whenever the text field changes
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      // if the search field is empty or only contains white-space, we'll display all users
      results = _allfriends;
    } else {
      results = _allfriends
          .where((user) =>
          user["name"].toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
      // we use the toLowerCase() method to make it case-insensitive
    }

    // Refresh the UI
    setState(() {
      _foundUsers = results;
    });
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Friends"),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 35, 34, 34),
          ),
        ),
      ),

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
              child: _foundUsers.isNotEmpty
                  ? ListView.builder(
                itemCount: _foundUsers.length,
                itemBuilder: (context, index) =>
                    buildBox(_foundUsers[index]),
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
        onPressed: () {
          // Add your onPressed code here!
        },
        label: const Text('Add Friend '),
        icon: const Icon(Icons.person_add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet),
            label: 'Add Expense',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'account',
          ),
        ],
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget buildBox(Map<String,dynamic> friend) => Card(
    key: ValueKey(friend["id"]),
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      leading: const Icon(Icons.person),
      title: Text(friend['name']),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyApp(name: friend['name'])),
        );
      },
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            friend['IOU'] == 0
                ? 'settled'
                : friend['IOU'] > 0
                ? 'owes you'
                : 'you owe',
            style: TextStyle(
              color: friend['IOU'] == 0
                  ? Colors.grey
                  : friend['IOU'] > 0
                  ? Color.fromARGB(255, 112, 237, 116)
                  : Color.fromARGB(255, 255, 107, 97),
            ),
          ),
          Text(
            friend['IOU'] == 0
                ? ''
                : friend['IOU'] > 0
                ? ' ${friend['IOU']}'
                : ' ${-friend['IOU']}',
            style: TextStyle(
              // make the text bold and big
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: friend['IOU'] == 0
                  ? Colors.black
                  : friend['IOU'] > 0
                  ? Color.fromARGB(255, 112, 237, 116)
                  : Color.fromARGB(255, 255, 107, 97),
            ),
          )
        ],
      ),
    ),
  );

}