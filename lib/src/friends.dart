import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/search.dart';

final List genfriends = List.generate(20, (index) {
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
final Map<String, dynamic> myfriends = {
  'friends': genfriends,
};

class FriendsPage extends StatefulWidget {
  @override
  FriendsPageState createState() => FriendsPageState();
}

class FriendsPageState extends State<FriendsPage> {
  late Map<String, dynamic> friends;
  String query = '';

  @override
  void initState() {
    super.initState();

    friends = myfriends;
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

      body: Column(children: <Widget>[
        buildSearch(),
        Expanded(
          child: ListView.builder(
            itemCount: friends['friends'].length,
            itemBuilder: (context, index) {
              final item = friends['friends'][index];
              return Card(
                elevation: 2,
                margin: EdgeInsets.all(8),
                child:buildBook(item))
                ;
            },
          ),
        )
      ]),

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

  Widget buildSearch() => SearchWidget(
        text: query,
        hintText: 'Search friends',
        onChanged: searchBook,
      );

  Widget buildBook(dynamic book) => ListTile(
        leading: const Icon(Icons.person),
        title: Text(book['name']),
        trailing: Text(
          book['IOU'] == 0
              ? 'settled'
              : book['IOU'] > 0
                  ? 'owes you ${book['IOU']}'
                  : 'you get back ${-book['IOU']}',
        ),
      );

  void searchBook(String query) {
    final books = myfriends['friends'].where((book) {
      final titleLower = book['name'].toLowerCase();
      final searchLower = query.toLowerCase();
      return titleLower.contains(searchLower);
    }).toList();

    setState(() {
      this.query = query;
      this.friends['friends'] = books;
    });
  }
}
