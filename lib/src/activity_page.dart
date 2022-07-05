import 'package:flutter/material.dart';
import 'package:campus_splitwise/src/friends.dart';

class ActivityPage extends StatefulWidget {
  const ActivityPage({Key? key}) : super(key: key);

  @override
  _ActivityPageState createState() => _ActivityPageState();
}

class _ActivityPageState extends State<ActivityPage> {
  final List<Map<String, dynamic>> _activity = List.generate(10, (index) {
    return {
      'id': index,
      'sender': 'Friend ${index+1}',
      'receiver' : 'Friend ${2*index+2}',
      'amount' : 100*index+100,
      'time' : DateTime.now(),
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: _activity.isNotEmpty
                  ? ListView.builder(
                itemCount: _activity.length,
                itemBuilder: (context, index) =>
                    buildBox(_activity[index]),
              )
                  : const Text(
                'Nothing to see here...',
                style: TextStyle(fontSize: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBox(Map<String,dynamic> activity) => SizedBox(
  height: 90,
  child: Card(
    key: ValueKey(activity["id"]),
    elevation: 2,

    margin: const EdgeInsets.symmetric(vertical: 10),
    child: ListTile(
      visualDensity: VisualDensity.comfortable,
      // increase size of this icon
      leading:
      const Icon(Icons.person),
      title: Text('${activity['sender']} paid ${activity['amount']} Rs to ${activity['receiver']}', style: TextStyle(fontSize: 19 )),
      onTap: () {},
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            '${activity['time']}',
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Roboto',
              color: Colors.grey,
            ),
          ),
        ],
      ),
    ),
  ),
);
